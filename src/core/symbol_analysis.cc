#include "symbol_analysis.h"

#include <gsl/gsl>
#include <queue>
#include <regex>

#include "absl/strings/str_join.h"
#include "absl/strings/str_replace.h"
#include "anno_context.h"

namespace symbol_analysis {

nlohmann::json GetAction(
    ResolveContext ctx,
    CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map,
    nlohmann::json *elem_to_analyze_dependency_out) {
  auto annotation = ctx.ir->GetAnnotation();

  if (annotation.contains("selector")) {
    if (elem_to_analyze_dependency_out)
      *elem_to_analyze_dependency_out = annotation["selector"];
    std::string str = annotation["selector"];
    const std::string custom_selector_name = str.substr(2);
    auto selector_callback = custom_action_selector_map.at(custom_selector_name)
                                 .select_action_callback;
    std::optional<std::string> option = selector_callback(ctx);
    if (option.has_value()) {
      return annotation[option.value()];
    } else {
      return nlohmann::json();
    }
  }

  std::vector<int> curs;
  std::vector<nlohmann::json> actions_order_preserved;

  for (auto &[_idx, action] : annotation.items()) {
    auto ast_context = action["ast_context"];

    assert(ast_context.is_array());
    int cur = action["ast_context"].size() - 1;
    if (cur == -1) {
      // [] empty context, match immediately
      assert(annotation.size() == 1 &&
             "Empty context takes precedence over all other contexts.");
      return action;
    }
    curs.push_back(cur);
    actions_order_preserved.push_back(action);
  }

  auto ir_cur = ctx.ir;
  while (ir_cur) {
    for (size_t action_idx = 0; action_idx < curs.size(); ++action_idx) {
      if (actions_order_preserved[action_idx]["ast_context"]
                                 [curs[action_idx]] == ir_cur->GetName()) {
        if (--curs[action_idx] == -1) {
          // If two actions get matched at the same time,
          //   the first one (randomly chosen due to
          //   unordered json K-Vs) will be returned.
          return actions_order_preserved[action_idx];
        }
      }
    }
    ir_cur = ir_cur->GetParent().lock();
  }
  return nlohmann::json();
}

std::string EscapeRegex(const std::string &input) {
  std::regex specialChars{R"([-[\]{}()*+?.,\^$|#\s])"};

  std::string sanitized = std::regex_replace(input, specialChars, R"(\$&)");
  return sanitized;
}

void SymbolAnalyzerListener::SetupActionExecutors() {
  action_executor_map_ = {
      {"CreateScope", &SymbolAnalyzerListener::ExecuteCreateScope},
      {"DefineSymbol", &SymbolAnalyzerListener::ExecuteDefineSymbol},
      {"UseSymbol", &SymbolAnalyzerListener::ExecuteUseSymbol},
      {"InvalidateSymbol", &SymbolAnalyzerListener::ExecuteInvalidateSymbol},
      {"AlterOrder", &SymbolAnalyzerListener::VoidActionHandler}};
}

SymbolAnalyzerListener::SymbolAnalyzerListener() {
  SetupActionExecutors();
  current_id_max_ = 0;
  current_scope_ = nullptr;
  analyzer_storage_ = std::make_shared<AnalyzerStorage>();
}

// 1. Evaluates the context expression
// 2. Builds the dependency graph
[[deprecated("Deprecated")]] std::string
SymbolAnalyzerListener::ExpandContextVariable(std::string str,
                                              ir::IR_PTR context) {
  anno_context::AnnoContextSequence seq =
      anno_context::AnnoContextAnalyzer::AnalyzeSequence(context, str);
  return seq.Evaluate(scopes_);
}

size_t SymbolAnalyzer::GetNumberOfVariables() const {
  size_t num_of_symbols = 0;

  auto &scopes = GetScopes();
  for (auto &scope : scopes) {
    auto sym_tbl = scope->GetSymbolTable();
    num_of_symbols += sym_tbl->GetSymbolMarkersMap().size();
  }
  return num_of_symbols;
}

std::vector<std::string> GetLabelsForDefiningSymbol(
    const nlohmann::json &sym_info) {
  absl::flat_hash_set<std::string> result;
  for (auto &[pattern, available_labels] : sym_info.items()) {
    // add available rules to the result set
    for (auto &[_ruletype, labels] : available_labels.items()) {
      if (!labels.is_array()) {
        MYLOG(FATAL, "Invalid labels: \n" << labels)
      }
      if (_ruletype == "DefineSymbol") {
        const std::vector<std::string> &labels_vec = labels;
        for (auto &label : labels_vec) {
          result.insert(label);
        }
      }
    }
  }
  return std::vector<std::string>(result.begin(), result.end());
}

std::vector<std::string> GetSupportingLabelsForSymbolType(
    std::string sym_type, const nlohmann::json &sym_info) {
  auto can_describe = [](const std::string &connonical_pattern,
                         const std::string &sym_type) {
    // `hello_?_key` can describe `hello_something_key`, where `something` is dynamically resolved

    return std::regex_match(sym_type, std::regex(absl::StrReplaceAll(
                                          connonical_pattern, {{"?", ".*"}})));
  };

  absl::flat_hash_set<std::string> result;

  for (auto &[pattern, available_labels] : sym_info.items()) {
    if (can_describe(pattern, sym_type)) {
      // add available rules to the result set
      for (auto &[_ruletype, labels] : available_labels.items()) {
        if (!labels.is_array()) {
          MYLOG(FATAL, "Invalid labels: \n" << labels)
        }
        const std::vector<std::string> &labels_vec = labels;
        for (auto &label : labels_vec) {
          result.insert(label);
        }
      }
    }
  }
  return std::vector<std::string>(result.begin(), result.end());
}

void SymbolAnalyzerListener::AddScope(Scope_PTR scope) {
  if (name_to_scope_map_.contains(scope->GetScopeName())) {
    MYLOG(FATAL, "Scope name " << scope->GetScopeName() << " redefined.");
  }
  scopes_.push_back(scope);
  name_to_scope_map_[scope->GetScopeName()] = scope;
}

Scope_PTR SymbolAnalyzerListener::FindScopeByName(
    std::string scope_name) const {
  if (name_to_scope_map_.contains(scope_name))
    return name_to_scope_map_.at(scope_name);
  return nullptr;
}

bool SymbolAnalyzerListener::CheckDependencyResolved(ir::IR_PTR ir) const {
  auto depends = dependency_graph_->GetDirectParents(ir);

  for (auto &each : depends) {
    if (ir_errors_map_.contains(each)) {
      MYLOG(INFO, ir->GetID() << "depends on " << each->GetID()
                              << " which is not resolved")
      // The ir that this ir depends on contains an error, therefore we also need to ensure
      // this ir contains an error.
      return false;
    }
  }

  return true;
}

bool SymbolAnalyzerListener::ExecuteInvalidateSymbol(
    nlohmann::json action_value, ir::IR_PTR context, ActionTime action_time) {
  if (action_time != ActionTime::kOnEnter)
    return true;  // do nothing in the OnExit event

  if (!CheckDependencyResolved(context)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedInvalidate,
         "Unresolved inval due to unresolved dependency on the name", context});
    return true;
  }

  /* An invalidation operation has 2 things to consider
    1. invalidation target should be defined (UseConstraint)
    2. after invalidation, the target will be invalidated (SideEffects)
  */

  bool any_name = !action_value.contains("name");
  bool any_type = !action_value.contains("type");

  bool type_block = action_value.contains("type_block");
  absl::flat_hash_set<std::string> blocked_types;

  if (type_block) {
    auto types_vec = ResolveValues(action_value["type_block"], context);
    blocked_types =
        absl::flat_hash_set<std::string>(types_vec.begin(), types_vec.end());
  }

  absl::flat_hash_set<std::string> allowed_names;
  if (!any_name) {
    auto names_vec = ResolveValues(action_value["name"], context);
    allowed_names =
        absl::flat_hash_set<std::string>(names_vec.begin(), names_vec.end());
  }

  absl::flat_hash_set<std::string> allowed_types;
  if (!any_type) {
    auto types_vec = ResolveValues(action_value["type"], context);
    allowed_types =
        absl::flat_hash_set<std::string>(types_vec.begin(), types_vec.end());
  }

  std::string used_name = context->ToSource(token_sep_);

  // check name requirements
  if (!any_name && !allowed_names.contains(used_name)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedInvalidate,
         absl::StrFormat("Can only invalidate %s, but invalidated %s",
                         absl::StrJoin(allowed_names, " or "), used_name),
         context});
    return true;
  }

  // check type requirements
  // check that a variable of `used_name` is defined as an allowed type

  bool legit = false;
  auto scope_seeker = current_scope_;
  while (scope_seeker) {
    auto symtbl = scope_seeker->GetSymbolTable();

    std::vector<Symbol_PTR> syms_tmp;
    if (any_type) {
      syms_tmp = symtbl->FindAllMatchingSymbols(
          absl::flat_hash_set<std::string>({used_name}), std::nullopt);
    } else {
      syms_tmp = symtbl->FindAllMatchingSymbols(
          absl::flat_hash_set<std::string>({used_name}), allowed_types);
    }

    std::vector<Symbol_PTR> syms;
    for (auto &sym : syms_tmp) {
      if (type_block) {
        if (blocked_types.contains(sym->GetType())) {
          continue;
        } else {
          syms.push_back(sym);
        }
      } else {
        syms.push_back(sym);
      }
    }

    if (syms.empty()) {
      scope_seeker = scope_seeker->GetParent();
      continue;
    }
    if (syms.size() > 1) {
      MYLOG(FATAL,
            "Multiple symbols are defined with the same name " << used_name)
    }
    auto symbol = syms[0];

    auto last_marker = symtbl->GetSymbolMarkers(symbol)->back();
    if (last_marker.type != SymbolTable::Marker::MarkerType::kInvalidate) {
      symtbl->InvalidateSymbol(symbol, context);

      legit = true;
      break;
    }
    scope_seeker = scope_seeker->GetParent();
    if (legit) break;
  }

  if (!legit) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedInvalidate,
         absl::StrFormat("Inval does not meet type and name requirements."),
         context});
  }

  return true;
}

bool SymbolAnalyzerListener::VoidActionHandler(nlohmann::json action_value,
                                               ir::IR_PTR context,
                                               ActionTime action_time) {
  return true;
}

std::vector<std::string> SymbolAnalyzerListener::ResolveValues(
    const nlohmann::json &anno, ir::IR_PTR ir) {
  if (anno.is_string()) {
    const std::string anno_str = anno;
    if (anno_str.starts_with("##")) {
      const std::string custom_handler_name = anno_str.substr(2);
      auto resolve_values_callback =
          custom_resolver_map_.at(custom_handler_name).resolve_values_callback;
      ResolveContext ctx = ResolveContext{std::nullopt, ir, scopes_, token_sep_,
                                          analyzer_storage_};

      return resolve_values_callback(ctx);

    } else {
      std::vector<std::string> values;
      auto anno_seq =
          anno_context::AnnoContextAnalyzer::AnalyzeSequence(ir, anno_str);
      values.push_back(anno_seq.Evaluate(scopes_));

      return values;
    }

  } else {
    // it's an arr of strings
    std::vector<std::string> values;
    std::vector<std::string> anno_strs = anno;
    for (auto &anno_str : anno_strs) {
      assert(!anno_str.starts_with("##"));
      auto anno_seq =
          anno_context::AnnoContextAnalyzer::AnalyzeSequence(ir, anno_str);
      values.push_back(anno_seq.Evaluate(scopes_));
    }
    return values;
  }
}

// Analyzes whether it uses a symbol that's been defined
bool SymbolAnalyzerListener::ExecuteUseSymbol(nlohmann::json action_value,
                                              ir::IR_PTR context,
                                              ActionTime action_time) {
  if (action_time != ActionTime::kOnEnter)
    return true;  // do nothing in the OnExit event

  if (!CheckDependencyResolved(context)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedUse,
         "Unresolved use due to unresolved dependency on the name", context});
    return true;
  }

  bool any_name = !action_value.contains("name");
  bool any_type = !action_value.contains("type");

  absl::flat_hash_set<std::string> allowed_names;
  if (!any_name) {
    auto names_vec = ResolveValues(action_value["name"], context);
    allowed_names =
        absl::flat_hash_set<std::string>(names_vec.begin(), names_vec.end());
  }

  absl::flat_hash_set<std::string> allowed_types;
  if (!any_type) {
    auto types_vec = ResolveValues(action_value["type"], context);
    allowed_types =
        absl::flat_hash_set<std::string>(types_vec.begin(), types_vec.end());
  }

  bool type_block = action_value.contains("type_block");
  absl::flat_hash_set<std::string> blocked_types;
  if (type_block) {
    auto types_vec = ResolveValues(action_value["type_block"], context);
    blocked_types =
        absl::flat_hash_set<std::string>(types_vec.begin(), types_vec.end());
  }

  std::string used_name = context->ToSource(token_sep_);

  // check name requirements
  if (!any_name && !allowed_names.contains(used_name)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedUse,
         absl::StrFormat("Can only use %s, but used %s",
                         absl::StrJoin(allowed_names, " or "), used_name),
         context});
    return true;
  }

  // check type requirements
  // check that a variable of `used_name` is defined as an allowed type

  bool legit = false;
  auto scope_seeker = current_scope_;
  while (scope_seeker) {
    auto symtbl = scope_seeker->GetSymbolTable();

    std::vector<Symbol_PTR> syms_tmp;
    if (any_type) {
      syms_tmp = symtbl->FindAllMatchingSymbols(
          absl::flat_hash_set<std::string>({used_name}), std::nullopt);
    } else {
      syms_tmp = symtbl->FindAllMatchingSymbols(
          absl::flat_hash_set<std::string>({used_name}), allowed_types);
    }
    std::vector<Symbol_PTR> syms;
    for (auto &sym : syms_tmp) {
      if (type_block) {
        if (blocked_types.contains(sym->GetType())) {
          continue;
        } else {
          syms.push_back(sym);
        }
      } else {
        syms.push_back(sym);
      }
    }

    if (syms.empty()) {
      scope_seeker = scope_seeker->GetParent();
      continue;
    }
    if (syms.size() > 1) {
      MYLOG(FATAL,
            "Multiple symbols are defined with the same name " << used_name)
    }
    auto sym = syms[0];
    if (symtbl->UseSymbol(sym, context)) {
      legit = true;
    }
    scope_seeker = scope_seeker->GetParent();
    if (legit) break;
  }

  if (!legit) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedUse,
         absl::StrFormat(
             "Use does not meet type and name requirements. %s",
             context->ToSourceAndHighlightPositionInRoot(token_sep_)),
         context});
  }

  return true;
}

std::vector<Symbol_PTR> SymbolTable::FindAllMatchingSymbols(
    std::optional<absl::flat_hash_set<std::string>> sym_name,
    std::optional<absl::flat_hash_set<std::string>> sym_type) const {
  std::vector<Symbol_PTR> result;

  for (auto &[type, name_to_symbol] : type_name_to_symbol_map_) {
    if (sym_type && !(sym_type.value().contains(type))) {
      continue;
    }
    for (auto &[name, symbol] : name_to_symbol) {
      if (sym_name && !(sym_name.value().contains(name))) {
        continue;
      }
      result.push_back(symbol);
    }
  }
  return result;
}

std::vector<Symbol_PTR> SymbolTable::FindAllMatchingSymbolsInternal(
    std::string name, std::string type) const {
  std::vector<Symbol_PTR> result;
  std::string processed_type =
      absl::StrReplaceAll(EscapeRegex(type), {{"NBANY", ".*"}});

  std::string processed_name =
      absl::StrReplaceAll(EscapeRegex(name), {{"NBANY", ".*"}});
  // do not support name yet since name could be of any text that doesn't
  // conform to the regex format

  for (auto &[type, name_to_symbol] : type_name_to_symbol_map_) {
    if (std::regex_match(type, std::regex(processed_type))) {
      for (auto &[name, symbol] : name_to_symbol) {
        if (std::regex_match(name, std::regex(processed_name))) {
          result.push_back(symbol);
        }
      }
    }
  }
  return result;
}

bool SymbolAnalyzerListener::ExecuteCreateScope(nlohmann::json action_value,
                                                ir::IR_PTR context,
                                                ActionTime action_time) {
  if (!action_value.contains("scope_name")) {
    MYLOG(WARNING, "action doesn't provide a scope_name");
    return false;
  }

  if (!action_value["scope_name"].is_string()) {
    MYLOG(WARNING, "scope_name should be a string");
    return false;
  }
  std::string scope_name = action_value["scope_name"];
  // expand context vars

  auto scope_name_seq =
      anno_context::AnnoContextAnalyzer::AnalyzeSequence(context, scope_name);
  // scope doesn't support context dependence on other IRs yet
  // we do a simple check here
  for (auto &each : scope_name_seq.GetContextSequence()) {
    auto target = each->GetTargetIR();
    if (target && (target != context)) {
      MYLOG(FATAL, "Invalid scope name: "
                       << scope_name
                       << ". Context dependency for scope names is limited. ")
    }
  }
  std::string evaluated_scope_name = scope_name_seq.Evaluate(scopes_);

  if (action_time == ActionTime::kOnEnter) {
    Scope_PTR new_scope = New<Scope>(evaluated_scope_name);
    new_scope->SetScopeStart(context->GetID());

    if (current_scope_) {
      new_scope->SetParent(current_scope_);
    }
    current_scope_ = new_scope;

    AddScope(new_scope);
    return true;
  } else /*if (action_time == ActionTime::kOnExit) */ {
    Scope_PTR scope = FindScopeByName(evaluated_scope_name);
    if (!scope) {
      MYLOG(WARNING, "Unable to find scope with name " << evaluated_scope_name);
      return false;
    }
    scope->SetScopeEnd(context->GetMaxIDInTheTree());
    if (scope->GetParent()) {
      current_scope_ = scope->GetParent();
    } else {
      current_scope_ = nullptr;
    }
    return true;
  }
}

bool SymbolAnalyzerListener::ExecuteDefineSymbol(nlohmann::json args,
                                                 ir::IR_PTR context,
                                                 ActionTime action_time) {
  if (action_time != ActionTime::kOnEnter)
    return true;  // do nothing in the OnExit event

  if (!args.contains("type")) {
    MYLOG(WARNING, "action doesn't provide a symbol type");
    return false;
  }

  std::string used_name;
  if (args.contains("name")) {
    auto resolved_names = ResolveValues(args["name"], context);
    if (resolved_names.size() != 1) {
      MYLOG(FATAL, "Name in DefineSymbol resolves to multiple values")
    }
    used_name = resolved_names[0];
  } else {
    // otherwise, defaults to "{@text}"
    //used_name = context->ToSource(token_sep_);
    auto resolved_names = ResolveValues("{@text}", context);
    if (resolved_names.size() != 1) {
      MYLOG(FATAL, "Name in DefineSymbol resolves to multiple values")
    }
    used_name = resolved_names[0];
  }
  if (!CheckDependencyResolved(context)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedDefine,
         "Unresolved define due to unresolved dependency on the name",
         context});
    return true;
  }

  if (!CheckDependencyResolved(context)) {
    EmitUnresolvedError(
        {UnresolvedError::ErrorCode::kUnresolvedDefine,
         "Unresolved define due to unresolved dependency on the type",
         context});
    return true;
  }

  std::vector<std::string> resolved_types =
      ResolveValues(args["type"], context);
  if (resolved_types.size() != 1) {
    MYLOG(FATAL, "DefineSymbol can only resolve one type")
  }

  if (!current_scope_) {
    MYLOG(FATAL,
          absl::StrFormat("No scope available for adding symbols\nCtx: %s",
                          context->ToLinearString()))
  }

  SymbolTable_PTR symtbl;
  if (args.contains("scope")) {
    auto scope = FindScopeByName(args["scope"]);
    if (!scope) {
      MYLOG(FATAL,
            "Unable to find scope " << args["scope"] << " for DefineSymbol")
    }
    symtbl = scope->GetSymbolTable();
  } else {
    symtbl = current_scope_->GetSymbolTable();
  }

  bool success = symtbl->DefineSymbol(used_name, resolved_types[0], context);

  if (!success) {
    EmitUnresolvedError({UnresolvedError::ErrorCode::kUnresolvedDefine,
                         "Unresolved define due to already defined symbol",
                         context});
    return true;
  }

  return true;
}

bool SymbolTable::InvalidateSymbol(Symbol_PTR symbol, ir::IR_PTR ir) {
  if (!symbol_markers_map_.contains(symbol)) {
    MYLOG(WARNING, "Unable to find symbol: " << symbol->ToString());
    return false;
  }
  auto &markers = symbol_markers_map_.at(symbol);

  bool ok = false;
  for (auto iter = markers->rbegin(); iter != markers->rend(); ++iter) {
    if (iter->type == Marker::MarkerType::kDefine) {
      ok = true;
      break;
    } else if (iter->type == Marker::MarkerType::kInvalidate) {
      ok = false;
      break;
    }
  }

  if (ok) {
    markers->push_back({Marker::MarkerType::kInvalidate, ir});
    return true;
  } else {
    MYLOG(WARNING, "Error: Invalidating before def.")
    return false;
  }
}

bool SymbolTable::UseSymbol(Symbol_PTR symbol, ir::IR_PTR ir) {
  if (!symbol_markers_map_.contains(symbol)) return false;

  auto &markers = symbol_markers_map_.at(symbol);
  assert(markers->size());

  bool ok = false;
  for (auto iter = markers->rbegin(); iter != markers->rend(); ++iter) {
    if (iter->type == Marker::MarkerType::kDefine) {
      ok = true;
      break;
    } else if (iter->type == Marker::MarkerType::kInvalidate) {
      ok = false;
      break;
    }
  }

  if (ok) {
    auto new_marker = Marker{Marker::MarkerType::kUse, ir};
    auto insert_before_iter = std::upper_bound(
        markers->begin(), markers->end(), new_marker,
        [](const symbol_analysis::SymbolTable::Marker &left,
           const symbol_analysis::SymbolTable::Marker &right) {
          return left.ir->GetOrderID() < right.ir->GetOrderID();
        });
    markers->insert(insert_before_iter, new_marker);
  }

  return ok;
}

bool SymbolTable::DefineSymbol(std::string sym_name, std::string sym_type,
                               ir::IR_PTR ir_defining_this_sym) {
  if (CheckSymbolOfNameExists(sym_name)) {
    MYLOG(INFO, "DefineSymbol failure because `" << sym_name
                                                 << "` is already defined")
    MYLOG(INFO, ir_defining_this_sym->ToSourceAndHighlightPositionInRoot())
    return false;
  }

  // otherwise, define the symbol
  static_cast<void>(
      DefineSymbolInternal(sym_name, sym_type, ir_defining_this_sym));

  return true;
}

std::vector<Symbol_PTR> SymbolTable::FindSymbolForUseAtIR(
    std::optional<absl::flat_hash_set<std::string>> symbol_types,
    ir::IR_PTR ir) const {
  std::vector<Symbol_PTR> result;

  for (auto &[sym, markers] : symbol_markers_map_) {
    if (symbol_types && !symbol_types->contains(sym->GetType())) {
      continue;
    }
    auto new_marker = Marker{Marker::MarkerType::kUse, ir};
    auto insert_before_iter = std::upper_bound(
        markers->begin(), markers->end(), new_marker,
        [](const symbol_analysis::SymbolTable::Marker &left,
           const symbol_analysis::SymbolTable::Marker &right) {
          return left.ir->GetOrderID() < right.ir->GetOrderID();
        });

    if (insert_before_iter != markers->begin() &&
        std::prev(insert_before_iter)->type !=
            Marker::MarkerType::kInvalidate) {
      // this symbol is valid at ir
      result.push_back(sym);
    }
  }
  return result;
}

bool SymbolTable::CheckIfAnySymbolOfNameValidAtIR(std::string symbol_name,
                                                  ir::IR_PTR ir) const {
  std::string processed_name =
      absl::StrReplaceAll(EscapeRegex(symbol_name), {{"NBANY", ".*"}});

  for (auto &[sym, markers] : symbol_markers_map_) {
    if (std::regex_match(sym->GetName(), std::regex(processed_name))) {
      // try to check if the symbol is available at ir

      auto new_marker = Marker{Marker::MarkerType::kUse, ir};
      auto insert_before_iter = std::upper_bound(
          markers->begin(), markers->end(), new_marker,
          [](const symbol_analysis::SymbolTable::Marker &left,
             const symbol_analysis::SymbolTable::Marker &right) {
            return left.ir->GetOrderID() < right.ir->GetOrderID();
          });

      // the first marker before `insert_before_iter` should be kInvalidate
      assert(insert_before_iter != markers->begin());
      if (std::prev(insert_before_iter)->type !=
          Marker::MarkerType::kInvalidate) {
        // this symbol is valid at ir
        return true;
      }
    }
  }
  return false;
}

void SymbolTable::DefineSymbolInternal(std::string name, std::string type,
                                       ir::IR_PTR ir) {
  auto syms = FindAllMatchingSymbolsInternal(name, type);
  if (syms.size() > 1) {
    for (auto &each : syms) MYLOG(INFO, each->ToString())
    MYLOG(FATAL,
          "Exists multiple symbols matching the one we are trying to define.")
  }
  if (syms.size() == 1) {
    auto sym = syms[0];
    auto &markers = symbol_markers_map_.at(sym);

    // Define symbol could be called after the first traversal,
    // therefore we may insert a define in the middle of the marker seq.

    // So we need to find the right pos to insert the marker.
    auto new_marker = Marker{Marker::MarkerType::kDefine, ir};
    auto insert_before_iter = std::upper_bound(
        markers->begin(), markers->end(), new_marker,
        [](const symbol_analysis::SymbolTable::Marker &left,
           const symbol_analysis::SymbolTable::Marker &right) {
          return left.ir->GetOrderID() < right.ir->GetOrderID();
        });
    markers->insert(insert_before_iter, new_marker);

  } else {
    auto new_symbol = New<Symbol>(name, type);
    auto new_marker_seq = std::make_shared<std::list<Marker>>();
    new_marker_seq->push_back({Marker::MarkerType::kDefine, ir});
    symbol_markers_map_[new_symbol] = new_marker_seq;
    type_name_to_symbol_map_[new_symbol->GetType()][new_symbol->GetName()] =
        new_symbol;
  }
}

void SymbolAnalyzerListener::ExecuteAction(nlohmann::json action,
                                           ir::IR_PTR context,
                                           ActionTime action_time) {
  std::string action_type = action["action"];

  if (!action_executor_map_.contains(action_type)) {
    MYLOG(FATAL, "Unsupported action type: " << action_type);
  }

  bool exec_status = (this->*(action_executor_map_[action_type]))(
      action["args"], context, action_time);
  if (!exec_status) {
    MYLOG(FATAL, "Error executing action: " << action);
  }
}

std::string SymbolTable::ToString() const {
  std::vector<std::string> symbol_strs;

  for (auto &[symbol, markers] : symbol_markers_map_) {
    symbol_strs.emplace_back(absl::StrFormat(
        "  name: %s, type: %s,", symbol->GetName(), symbol->GetType()));
  }
  return absl::StrFormat("{\n%s\n }", absl::StrJoin(symbol_strs, "\n"));
}

std::string Scope::ToString() const {
  return absl::StrFormat(
      "Scope {\n"
      " scope_name: %s\n"
      " scope_range: %s\n"
      " parent: %s\n"
      " symbol table: "
      "%s\n"
      "}",
      scope_name_, scope_range_.ToString(),
      parent_scope_ ? parent_scope_->GetScopeName() : "null",
      symbol_table_->ToString());
}

std::vector<ir::IR_PTR>
SymbolAnalyzerBuildDependencyGraphListener::GetDependencies(
    const nlohmann::json &anno_type, ir::IR_PTR ir) {
  if (anno_type.is_string()) {
    const std::string anno_type_str = anno_type;

    if (anno_type_str.starts_with("##")) {
      const std::string custom_handler_name = anno_type_str.substr(2);
      if (custom_resolver_map_.contains(custom_handler_name)) {
        auto get_dependencies_callback =
            custom_resolver_map_.at(custom_handler_name)
                .get_dependencies_callback;

        return get_dependencies_callback(ir);
      }
      if (custom_action_selector_map_.contains(custom_handler_name)) {
        auto get_dependencies_callback =
            custom_action_selector_map_.at(custom_handler_name)
                .get_dependencies_callback;

        return get_dependencies_callback(ir);
      }

      MYLOG(FATAL, custom_handler_name << " custom handler not found")
    } else {
      absl::flat_hash_set<ir::IR_PTR> dependencies;
      auto anno_seq =
          anno_context::AnnoContextAnalyzer::AnalyzeSequence(ir, anno_type_str);
      for (auto &anno_ctx : anno_seq.GetContextSequence()) {
        ir::IR_PTR ir_being_depended = anno_ctx->GetTargetIR();
        if (!ir_being_depended || ir_being_depended == ir) continue;
        dependencies.insert(ir_being_depended);
      }
      return std::vector<ir::IR_PTR>(dependencies.begin(), dependencies.end());
    }

  } else {
    // it's an arr of strings
    std::vector<std::string> anno_type_strs = anno_type;
    absl::flat_hash_set<ir::IR_PTR> dependencies;
    for (auto &anno_type_str : anno_type_strs) {
      assert(!anno_type_str.starts_with("##"));
      auto anno_seq =
          anno_context::AnnoContextAnalyzer::AnalyzeSequence(ir, anno_type_str);
      for (auto &anno_ctx : anno_seq.GetContextSequence()) {
        ir::IR_PTR ir_being_depended = anno_ctx->GetTargetIR();
        if (!ir_being_depended || ir_being_depended == ir) continue;
        dependencies.insert(ir_being_depended);
      }
    }

    return std::vector<ir::IR_PTR>(dependencies.begin(), dependencies.end());
  }
  MYLOG(FATAL, "Unexpected")
}

void SymbolAnalyzerBuildDependencyGraphListener::EnterIR(ir::IR_PTR ir) {
  dependency_graph_->AddVertex(ir);

  auto analyze_dependency = [&](const nlohmann::json &elem) {
    std::vector<ir::IR_PTR> dependencies = GetDependencies(elem, ir);

    for (auto &depend_on : dependencies) {
      auto to_subtrees = subtree_collector::CollectSubtrees(depend_on);
      auto from_subtrees = subtree_collector::CollectSubtrees(ir);
      for (auto &from_subtree : from_subtrees) {
        for (auto &to_subtree : to_subtrees) {
          if (from_subtree != to_subtree) {
            dependency_graph_->AddEdge(from_subtree, to_subtree);
          }
        }
      }
    }
  };

  ResolveContext ctx =
      ResolveContext{true, ir, std::nullopt, std::nullopt, analyzer_storage_};
  nlohmann::json elem_to_analyze_dependency;
  auto action =
      GetAction(ctx, custom_action_selector_map_, &elem_to_analyze_dependency);
  if (!elem_to_analyze_dependency.empty()) {
    analyze_dependency(elem_to_analyze_dependency);
  }
  if (action.empty()) return;

  auto &action_type = action["action"];
  auto &args = action["args"];
  if (action_type == "DefineSymbol" || action_type == "InvalidateSymbol" ||
      action_type == "UseSymbol") {
    if (args.contains("type")) {
      analyze_dependency(args["type"]);
    }
    if (args.contains("name")) {
      analyze_dependency(args["name"]);
    }
  } else if (action_type == "AlterOrder") {
    if (args.contains("after")) {
      analyze_dependency(args["after"]);
    }
  } else if (action_type == "CreateScope") {
    // do nothing
  } else {
    MYLOG(FATAL, "Invalid action type: " << action_type << "\n"
                                         << action << "\n"
                                         << ir->GetAnnotationLabel() << "\n"
                                         << ir->GetAnnotationLabel());
  }
}
void SymbolAnalyzerBuildDependencyGraphListener::ExitIR(ir::IR_PTR ir) {}

void SymbolAnalyzerListener::EnterIR(ir::IR_PTR ir) {
  ++label_freq_map_[ir->GetAnnotationLabel()];

  ResolveContext ctx =
      ResolveContext{true, ir, scopes_, token_sep_, analyzer_storage_};

  auto action = GetAction(ctx, custom_action_selector_map_, nullptr);

  if (!action.empty()) {
    ExecuteAction(action, ir, ActionTime::kOnEnter);
  }
}

UnresolvedError SymbolAnalyzerListener::PopOneUnresolvedErrorFromQueue() {
  auto tmp = errors_.top();
  errors_.pop();
  ir_errors_map_.erase(tmp.error_ir);
  return tmp;
}

void SymbolAnalyzerListener::EmitUnresolvedError(UnresolvedError err) {
  if (!ir_errors_map_.contains(err.error_ir)) {
    errors_.push(err);
    ir_errors_map_[err.error_ir] = err;
  } else {
    MYLOG(INFO, "Dup error, ignoring")
  }
  MYLOG(INFO, absl::StrFormat("EmitUnresolvedError: err_type: %d, message: %s",
                              err.error_code, err.error_message))
}

void SymbolAnalyzerListener::ExitIR(ir::IR_PTR ir) {
  ResolveContext ctx =
      ResolveContext{false, ir, std::nullopt, std::nullopt, analyzer_storage_};
  auto action = GetAction(ctx, custom_action_selector_map_, nullptr);

  if (!action.empty()) {
    ExecuteAction(action, ir, ActionTime::kOnExit);
  }
}

bool SymbolAnalyzer::TryFixUnresolvedDefine(
    symbol_analysis::UnresolvedError error) {
  // 1. resolve the sym type
  ResolveContext ctx =
      ResolveContext{std::nullopt, error.error_ir, listener_->GetScopes(),
                     token_sep_, listener_->GetAnalyzerStorage()};
  auto action = GetAction(ctx, custom_action_selector_map_, nullptr);

  auto args = action["args"];
  std::vector<std::string> resolved_types =
      listener_->ResolveValues(args["type"], error.error_ir);
  assert(resolved_types.size() == 1);

  std::string sym_type = resolved_types[0];

  std::string defined_name;
  if (args.contains("name")) {
    defined_name = args["name"];
  } else {
    defined_name = "{@text}";
  }

  SymbolTable_PTR symtbl;
  if (args.contains("scope")) {
    auto scope = listener_->FindScopeByName(args["scope"]);
    if (!scope) {
      MYLOG(FATAL,
            "Unable to find scope " << args["scope"] << " for DefineSymbol")
    }
    symtbl = scope->GetSymbolTable();
  } else {
    Scope_PTR current_scope_ = GetScopeContainingIR(error.error_ir);
    symtbl = current_scope_->GetSymbolTable();
  }

  // 2. try to get a uniq name that's never used in this symbol table

  std::regex pattern("\\{.*?\\}");
  std::smatch m;
  bool contain_context = std::regex_search(defined_name, m, pattern);

  if (!contain_context) {
    // defined name is fixed and cannot be changed, so there is no way to fix
    return false;
  }

  // Try to fix
  std::string uniq_name = "v0";
  std::string formatted_uniq_name =
      std::regex_replace(defined_name, pattern, uniq_name);
  size_t i = 1;
  while (symtbl->CheckSymbolOfNameExists(formatted_uniq_name)) {
    MYLOG(INFO, absl::StrFormat("Name %s exists", uniq_name))
    uniq_name = absl::StrFormat("v%d", i++);
    formatted_uniq_name = std::regex_replace(defined_name, pattern, uniq_name);
    MYLOG(INFO, absl::StrFormat("Trying %s", uniq_name))
  }

  UpdateTerminalWithNewName(error.error_ir, formatted_uniq_name);

  std::string new_symbol_name =
      listener_->ResolveValues(defined_name, error.error_ir)[0];

  // 3. insert the new sym def into the corresponding symbol table.
  if (!symtbl->DefineSymbol(new_symbol_name, sym_type, error.error_ir)) {
    MYLOG(INFO, sym_type)
    MYLOG(INFO, new_symbol_name)
    MYLOG(INFO, "Unbale to define symbol during fix.")
    return false;
  }
  MYLOG(INFO, "Fixed unresolved define. The new symbol defined is: "
                  << new_symbol_name)

  // Fixing an unresolved define will not introduce new errors
  return true;
}

// Find the terminal IR in `ir_to_fix` and update its name to `new_name`.
void SymbolAnalyzer::UpdateTerminalWithNewName(ir::IR_PTR ir_to_fix,
                                               std::string new_name) const {
  std::vector<ir::IR_PTR> terminals =
      subtree_collector::CollectTerminals(ir_to_fix);
  if (terminals.size() != 1) {
    MYLOG(FATAL, absl::StrFormat("Annotation `%s` can only be applied to "
                                 "nodes that contain only one terminal leaf.",
                                 ir_to_fix->GetAnnotation().dump()))
  }
  ir::IR_PTR terminal = terminals[0];

  MYLOG(INFO, "The following terminal has been updated, original name: "
                  << terminal->GetName())
  terminal->SetName(new_name);
  MYLOG(INFO, terminal->ToSourceAndHighlightPositionInRoot(token_sep_))
}

// Revoke the operation done by each ir in `irs`. For example, if ir is a
// DefineSymbol, remove the symbol definition.
// The removed operations will be emitted as unresolved errors.
void SymbolAnalyzerListener::RevokeAll(std::vector<ir::IR_PTR> irs) {
  for (auto &each : irs) {
    // If it's already an error, skip
    if (CheckIRHasUnresolvedError(each)) {
      continue;
    }
    MYLOG(INFO,
          "revoking ir on the dependency tree: " << each->ToSource(token_sep_))

    ResolveContext ctx = ResolveContext{std::nullopt, each, scopes_, token_sep_,
                                        analyzer_storage_};
    auto action =
        symbol_analysis::GetAction(ctx, custom_action_selector_map_, nullptr);

    if (action["action"] == "UseSymbol") {
      // remove the use, make it an error
      RemoveIRSymbolUse(each);
      MYLOG(INFO, "a use has been revoked")
    }
    if (action["action"] == "DefineSymbol") {
      RemoveIRSymbolDefine(each);
      MYLOG(INFO, "a def has been revoked")
    }
    if (action["action"] == "InvalidateSymbol") {
      // inval -> remove the inval, refresh lifetime, make it an error
      // (inval before def)
      RemoveIRSymbolInvalidate(each);
      MYLOG(INFO, "a inval has been revoked")
    }
  }
}

void SymbolAnalyzer::InsertMarkerForSymbol(
    Symbol_PTR symbol, ir::IR_PTR marker_ir,
    symbol_analysis::SymbolTable::Marker::MarkerType marker_type) {
  auto symtbl = GetSymbolTableForSymbol(symbol);
  auto markers = symtbl->GetSymbolMarkers(symbol);
  auto new_marker =
      symbol_analysis::SymbolTable::Marker{marker_type, marker_ir};
  auto insert_before_iter =
      std::upper_bound(markers->begin(), markers->end(), new_marker,
                       [](const symbol_analysis::SymbolTable::Marker &left,
                          const symbol_analysis::SymbolTable::Marker &right) {
                         return left.ir->GetID() < right.ir->GetID();
                       });

  markers->insert(insert_before_iter, new_marker);

  if (marker_type == SymbolTable::Marker::MarkerType::kInvalidate) {
    // Emit errors for the markers between the inserted inval and the next
    // def, meanwhile remove them from the list.
    while (insert_before_iter != markers->end() &&
           insert_before_iter->type !=
               symbol_analysis::SymbolTable::Marker::MarkerType::kDefine) {
      symbol_analysis::UnresolvedError::ErrorCode errcode;
      switch (insert_before_iter->type) {
        case symbol_analysis::SymbolTable::Marker::MarkerType::kInvalidate: {
          errcode = symbol_analysis::UnresolvedError::ErrorCode::
              kUnresolvedInvalidate;

          break;
        }
        case symbol_analysis::SymbolTable::Marker::MarkerType::kUse: {
          errcode = symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedUse;
          break;
        }
        default:
          MYLOG(FATAL, "Unexpected");
      }
      listener_->EmitUnresolvedError(symbol_analysis::UnresolvedError{
          errcode, "error introduced by invalidating a symbol",
          insert_before_iter->ir});
      listener_->RevokeAll(GetAllDescendentsOfIR(insert_before_iter->ir));
      insert_before_iter = markers->erase(insert_before_iter);
    }
  } else if (marker_type == SymbolTable::Marker::MarkerType::kUse) {
    // the use has been changed to another, so we revoke IRs depending on it
    // listener_->RevokeAll(GetAllDescendentsOfIR(marker_ir));
  }
}

bool SymbolAnalyzer::TryFixUnresolvedUseOrInvalidate(
    symbol_analysis::UnresolvedError error) {
  ir::IR_PTR ir_to_fix = error.error_ir;

  ResolveContext ctx =
      ResolveContext{std::nullopt, ir_to_fix, listener_->GetScopes(),
                     token_sep_, listener_->GetAnalyzerStorage()};

  nlohmann::json action = GetAction(ctx, custom_action_selector_map_, nullptr);

  auto &args = action["args"];

  absl::flat_hash_set<Symbol_PTR> available_symbol_set;
  std::vector<std::string> required_symtypes;

  if (args.contains("type")) {
    required_symtypes = listener_->ResolveValues(args["type"], ir_to_fix);
    auto required_symtypes_set = absl::flat_hash_set<std::string>(
        required_symtypes.begin(), required_symtypes.end());
    auto tmp = GetSymbolsForUseAtIR(ir_to_fix, required_symtypes_set);
    available_symbol_set.insert(tmp.begin(), tmp.end());
  } else {
    auto tmp = GetSymbolsForUseAtIR(ir_to_fix, std::nullopt);
    available_symbol_set.insert(tmp.begin(), tmp.end());
  }

  bool type_block = args.contains("type_block");
  absl::flat_hash_set<std::string> blocked_types;
  if (type_block) {
    auto types_vec = listener_->ResolveValues(args["type_block"], ir_to_fix);
    blocked_types =
        absl::flat_hash_set<std::string>(types_vec.begin(), types_vec.end());
  }

  std::vector<Symbol_PTR> tmp;

  if (args.contains("name")) {
    auto names = listener_->ResolveValues(args["name"], ir_to_fix);
    auto available_symbol_names =
        absl::flat_hash_set<std::string>(names.begin(), names.end());
    for (auto &each : available_symbol_set) {
      if (available_symbol_names.contains(each->GetName())) {
        tmp.push_back(each);
      }
    }
  } else {
    tmp = std::vector<Symbol_PTR>(available_symbol_set.begin(),
                                  available_symbol_set.end());
  }

  std::vector<Symbol_PTR> available_symbols;
  for (auto &each : tmp) {
    if (type_block) {
      if (blocked_types.contains(each->GetType())) {
        continue;
      }
      available_symbols.push_back(each);
    } else {
      available_symbols.push_back(each);
    }
  }

  if (available_symbols.empty()) {
    MYLOG(INFO, "No symbol available!")
    return false;
  }

  std::string log_available_syms;
  for (auto &each : available_symbols) {
    log_available_syms += absl::StrFormat("%s, ", each->ToString());
  }
  MYLOG(INFO, "Choosing from available symbols to fix the use/invalidate: ")
  MYLOG(INFO, log_available_syms)

  auto chosen_symbol = utils::RandomChoice(available_symbols, bitgen_);
  std::string chosen_fix = chosen_symbol->GetName();
  MYLOG(INFO, "Choice: " << chosen_fix)

  UpdateTerminalWithNewName(ir_to_fix,
                            chosen_fix);  // side effects of this are handled in
                                          // `InsertMarkerForSymbol`

  auto marker_type =
      error.error_code ==
              symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedInvalidate
          ? SymbolTable::Marker::MarkerType::kInvalidate
          : SymbolTable::Marker::MarkerType::kUse;

  InsertMarkerForSymbol(chosen_symbol, ir_to_fix, marker_type);

  return true;
}

bool SymbolAnalyzer::TryFixUnresolvedError(
    symbol_analysis::UnresolvedError error) {
  static absl::flat_hash_map<symbol_analysis::UnresolvedError::ErrorCode,
                             bool (SymbolAnalyzer::*)(
                                 symbol_analysis::UnresolvedError error)>
      error_fixer_map = {
          {symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedDefine,
           &SymbolAnalyzer::TryFixUnresolvedDefine},
          {symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedUse,
           &SymbolAnalyzer::TryFixUnresolvedUseOrInvalidate},
          {symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedInvalidate,
           &SymbolAnalyzer::TryFixUnresolvedUseOrInvalidate}};
  if (!error_fixer_map.contains(error.error_code)) {
    MYLOG(FATAL, "Fixer function for error " << int(error.error_code)
                                             << " unregistered.");
  }
  return (this->*(error_fixer_map.at(error.error_code)))(error);
}

bool SymbolAnalyzer::FixUnresolvedErrors() {
  while (listener_->HasUnresolvedError()) {
    auto err_to_fix = listener_->PopOneUnresolvedErrorFromQueue();

    MYLOG(INFO, "Trying to fix this error:")
    MYLOG(INFO, err_to_fix.error_message)
    MYLOG(INFO,
          err_to_fix.error_ir->ToSourceAndHighlightPositionInRoot(token_sep_))

    bool fix_status = TryFixUnresolvedError(err_to_fix);
    if (!fix_status) {
      MYLOG(INFO, "Failed to fix the following ir:")

      MYLOG(INFO,
            err_to_fix.error_ir->ToSourceAndHighlightPositionInRoot(token_sep_))

      MYLOG(INFO, "It has an unresolved error: " << err_to_fix.error_message)

      // PrintScopes();

      return false;
    }
  }
  return true;
}

ir::IR_PTR SymbolAnalyzer::GetNextIRInAST(ir::IR_PTR ir) const {
  return build_depen_graph_listener_->GetIDIR(ir->GetID() + 1);
}

void SymbolAnalyzer::Analyze(ir::IR_PTR root) {
  Reset();
  ir::IRWalker::Walk(root, build_depen_graph_listener_);

  build_depen_graph_listener_->FinalizeDependencyGraph();
  listener_->RegisterDependencyGraph(
      build_depen_graph_listener_->GetDependencyGraph());
  build_depen_graph_listener_->TopoWalk(listener_);

  ir_being_analyzed_ = root;
}

std::vector<Symbol_PTR> SymbolAnalyzer::GetSymbolsForUseAtIR(
    ir::IR_PTR ir, std::optional<absl::flat_hash_set<std::string>> symbol_types,
    bool after_ir) {
  std::vector<Symbol_PTR> result;
  if (after_ir) {
    ir = GetNextIRInAST(ir);
  }

  auto scope = GetScopeContainingIR(ir);
  if (!scope) {
    MYLOG(FATAL, "IR doesn't belong to any scope!")
  }
  while (scope) {
    auto tbl = scope->GetSymbolTable();
    std::vector<Symbol_PTR> syms = tbl->FindSymbolForUseAtIR(symbol_types, ir);
    result.insert(result.end(), syms.begin(), syms.end());
    scope = scope->GetParent();
  }

  return result;
}

Scope_PTR SymbolAnalyzer::GetScopeForSymbolTable(SymbolTable_PTR symtbl) const {
  auto &scopes = listener_->GetScopes();
  for (auto &scope : scopes) {
    if (symtbl == scope->GetSymbolTable()) {
      return scope;
    }
  }
  return nullptr;
}

// This finds the inner most scope that contains the IR
Scope_PTR SymbolAnalyzer::GetScopeContainingIR(ir::IR_PTR ir) const {
  auto &scopes = listener_->GetScopes();

  absl::flat_hash_set<Scope_PTR> result_scopes;
  for (auto &scope : scopes) {
    auto range = scope->GetScopeRange();
    if (range.start <= ir->GetID() && range.end >= ir->GetID()) {
      result_scopes.insert(scope);
      auto pa = scope->GetParent();
      if (pa && result_scopes.contains(pa)) {
        result_scopes.erase(pa);
      }
    }
  }
  if (result_scopes.empty()) return nullptr;
  if (result_scopes.size() != 1) {
    MYLOG(FATAL, "Two non-nested scopes contain the same IR!")
  }
  return *result_scopes.begin();
}

Symbol_PTR SymbolAnalyzer::GetSymbolAssociateWithIR(
    ir::IR_PTR ir, SymbolTable::Marker::MarkerType association_type) const {
  auto scope = GetScopeContainingIR(ir);
  if (!scope) return nullptr;
  auto tbl_markers_map = scope->GetSymbolTable()->GetSymbolMarkersMap();
  for (auto &[symbol, markers] : tbl_markers_map) {
    for (auto each = markers->begin(); each != markers->end(); ++each) {
      if (each->ir == ir && each->type == association_type) {
        return symbol;
      }
    }
  }
  return nullptr;
}

SymbolTable_PTR SymbolAnalyzer::GetSymbolTableForSymbol(
    Symbol_PTR symbol) const {
  auto &scopes = listener_->GetScopes();
  for (auto &scope : scopes) {
    auto tbl = scope->GetSymbolTable();
    if (tbl->CheckSymbolExists(symbol)) return tbl;
  }
  return nullptr;
}

void SymbolAnalyzerListener::RemoveIRSymbolUse(ir::IR_PTR ir) {
  bool success = false;
  auto &scopes = GetScopes();
  for (auto &scope : scopes) {
    auto tbl_markers_map = scope->GetSymbolTable()->GetSymbolMarkersMap();
    for (auto &[sym, markers] : tbl_markers_map) {
      for (auto each = markers->begin(); each != markers->end(); ++each) {
        if (each->ir == ir &&
            each->type == SymbolTable::Marker::MarkerType::kUse) {
          success = true;
          markers->erase(each);
          break;
        }
      }
    }
  }
  if (!success) {
    MYLOG(FATAL, "Failure in RemoveIRSymbolUse for ir: " << ir->ToSource());
  }
  EmitUnresolvedError(
      UnresolvedError{UnresolvedError::ErrorCode::kUnresolvedUse,
                      "error introduced by removing a use marker", ir});
}

void SymbolAnalyzerListener::RemoveIRSymbolDefine(ir::IR_PTR ir) {
  bool success = false;
  auto &scopes = GetScopes();
  for (auto &scope : scopes) {
    auto tbl_markers_map = scope->GetSymbolTable()->GetSymbolMarkersMap();
    for (auto &[_, markers] : tbl_markers_map) {
      for (auto each = markers->begin(); each != markers->end(); ++each) {
        if (each->ir == ir &&
            each->type == SymbolTable::Marker::MarkerType::kDefine) {
          success = true;
          // find the def, make all markers until the next def errors
          do {
            UnresolvedError::ErrorCode error_code;
            switch (each->type) {
              case SymbolTable::Marker::MarkerType::kDefine:
                error_code = UnresolvedError::ErrorCode::kUnresolvedDefine;
                break;

              case SymbolTable::Marker::MarkerType::kInvalidate:
                error_code = UnresolvedError::ErrorCode::kUnresolvedInvalidate;
                break;

              case SymbolTable::Marker::MarkerType::kUse:
                error_code = UnresolvedError::ErrorCode::kUnresolvedUse;
                break;
              default:
                assert(false && "unhandled");
            }
            EmitUnresolvedError(UnresolvedError{
                error_code, "error introduced by removing a define marker",
                each->ir});

            RevokeAll(dependency_graph_->GetAllDescendentsOfVertex(each->ir));
            MYLOG(INFO, "Erasing marker: " << each->ToString())
            each = markers->erase(each);

          } while (each != markers->end() &&
                   each->type != SymbolTable::Marker::MarkerType::kDefine);

          break;
        }
      }
    }
  }
  if (!success) {
    MYLOG(FATAL, "Failure in RemoveIRSymbolDefine for ir: " << ir->ToSource());
  }
}

void SymbolAnalyzerListener::RemoveIRSymbolInvalidate(ir::IR_PTR ir) {
  bool success = false;
  auto &scopes = GetScopes();
  for (auto &scope : scopes) {
    auto tbl_markers_map = scope->GetSymbolTable()->GetSymbolMarkersMap();
    for (auto &[_, markers] : tbl_markers_map) {
      for (auto each = markers->begin(); each != markers->end(); ++each) {
        if (each->ir == ir &&
            each->type == SymbolTable::Marker::MarkerType::kInvalidate) {
          success = true;
          markers->erase(each);
          break;
        }
      }
    }
  }
  if (!success) {
    MYLOG(FATAL,
          "Failure in RemoveIRSymbolInvalidate for ir: " << ir->ToSource());
  }

  EmitUnresolvedError(
      UnresolvedError{UnresolvedError::ErrorCode::kUnresolvedInvalidate,
                      "error introduced by removing an invalidate marker", ir});
}

// Searches for the (first) matching symbol in all scopes and invalidates it.
bool SymbolAnalyzer::InvalidateSymbol(Symbol_PTR symbol, ir::IR_PTR ir) {
  auto &scopes = listener_->GetScopes();
  for (auto &scope : scopes) {
    auto tbl = scope->GetSymbolTable();
    if (!tbl->GetSymbolMarkersMap().contains(symbol)) continue;
    bool res = tbl->InvalidateSymbol(symbol, ir);
    if (res) {
      return true;
    }
  }
  return false;
}

// for debugging
void SymbolAnalyzer::PrintScopes() const {
  for (auto &each : listener_->GetScopes()) {
    std::cout << each->ToString() << std::endl;
  }
}

void DependencyGraph::TopoWalk(ir::IRListener_PTR listener) const {
  // An IR's onEnter will be called in topo order.
  // After an IR's onEnter is called, its onExit will be called
  //   when all of its children's onExit are called.
  // The children here means the children in the AST, not in the dependency
  // graph.
  absl::flat_hash_map<ir::IR_PTR, uint64_t>
      ir_to_children_onexit_not_called_map;
  std::queue<ir::IR_PTR> onexit_q;
  for (auto &ir : ordered_vec_) {
    listener->EnterIR(ir);

    ir_to_children_onexit_not_called_map[ir] = ir->GetChildren().size();

    if (!ir_to_children_onexit_not_called_map[ir]) {
      onexit_q.push(ir);
    }
    while (onexit_q.size()) {
      auto elem = onexit_q.front();
      onexit_q.pop();
      listener->ExitIR(elem);

      --ir_to_children_onexit_not_called_map[elem->GetParent().lock()];
      if (!ir_to_children_onexit_not_called_map[elem->GetParent().lock()]) {
        onexit_q.push(elem->GetParent().lock());
      }
    }
  }
}

void DependencyGraph::AddVertex(ir::IR_PTR ir) {
  if (vertices_adj_list_.contains(ir)) return;
  vertices_adj_list_[ir] = {};
  vertices_adj_list_rev_[ir] = {};
}

void DependencyGraph::AddEdge(ir::IR_PTR from, ir::IR_PTR to) {
  AddVertex(from);
  AddVertex(to);
  vertices_adj_list_[from].insert(to);
  vertices_adj_list_rev_[to].insert(from);
}

void DependencyGraph::FinalizeGraph() { PerformTopoSort(); }
void DependencyGraph::Reset() {
  vertices_adj_list_.clear();
  vertices_adj_list_rev_.clear();
}

void DependencyGraph::PerformTopoSort() {
  ordered_vec_.clear();

  std::stack<ir::IR_PTR> tmpstack;
  absl::flat_hash_map<ir::IR_PTR, bool> visited;
  auto cmp = [](const ir::IR_PTR &l, const ir::IR_PTR &r) {
    return l->GetID() > r->GetID();
  };
  std::priority_queue<ir::IR_PTR, std::vector<ir::IR_PTR>, decltype(cmp)> pq(
      cmp);
  absl::flat_hash_map<ir::IR_PTR, uint64_t> inorder_map;

  for (auto &[from, tos] : vertices_adj_list_rev_) {
    if (!inorder_map.contains(from)) inorder_map[from] = 0;
    for (auto &to : tos) ++inorder_map[to];
  }
  for (auto &[elem, inorder] : inorder_map) {
    if (inorder == 0) {
      pq.push(elem);
    }
  }
  const auto numofnodes = vertices_adj_list_rev_.size();
  uint64_t rank = 0;
  while (pq.size()) {
    auto elem = pq.top();
    pq.pop();
    elem->SetOrderID(rank);
    ordered_vec_.push_back(elem);
    ++rank;
    for (auto &to : vertices_adj_list_rev_[elem]) {
      --inorder_map[to];
      if (inorder_map[to] == 0) {
        pq.push(to);
      }
    }
  }
  // sanity check for cycles
  if (numofnodes != rank) {
    MYLOG(FATAL, "Unable to perform topo sort: a dependency cycle exists. "
                     << rank << " remaining nodes form a loop.")
  }
}

absl::flat_hash_set<ir::IR_PTR> DependencyGraph::GetDirectParents(
    ir::IR_PTR ir) const {
  return vertices_adj_list_.at(ir);
}

std::vector<ir::IR_PTR> DependencyGraph::GetAllDescendentsOfVertex(
    ir::IR_PTR ir) const {
  std::vector<ir::IR_PTR> result;

  auto collect_tree = [&](const auto &self, const ir::IR_PTR &ir) -> void {
    if (!vertices_adj_list_rev_.contains(ir)) return;
    for (auto &each : vertices_adj_list_rev_.at(ir)) {
      result.push_back(each);
      self(self, each);
    }
  };
  collect_tree(collect_tree, ir);
  return result;
}

std::string DependencyGraph::GetGraphAsString() const {
  std::string result;
  for (auto &[from, tos] : vertices_adj_list_) {
    for (auto &to : tos) {
      result += absl::StrFormat("%d -> %d\n", from->GetID(), to->GetID());
    }
  }
  return result;
}

}  // namespace symbol_analysis