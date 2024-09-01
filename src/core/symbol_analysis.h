#ifndef SRC_SYMBOL_ANALYSIS_H_
#define SRC_SYMBOL_ANALYSIS_H_

#include <queue>

#include "absl/container/flat_hash_map.h"
#include "absl/container/flat_hash_set.h"
#include "absl/strings/str_format.h"
#include "ir.h"
#include "src/utils/libs/utils.h"
#include "subtree_collector.h"

#define CUSTOM_TYPE_RESOLVER_MAP_TYPE \
  absl::flat_hash_map<std::string, CustomResolverCallbacks>

template <typename C, typename... T>
std::shared_ptr<C> New(T... args) {
  return std::make_shared<C>(args...);
}

namespace anno_context {
class AnnoContextSequence;
}

namespace symbol_analysis {

class Scope;
class SymbolTable;
class Symbol;
class DependencyGraph;

typedef std::shared_ptr<DependencyGraph> DependencyGraph_PTR;
typedef std::shared_ptr<Scope> Scope_PTR;
typedef std::shared_ptr<SymbolTable> SymbolTable_PTR;
typedef std::shared_ptr<Symbol> Symbol_PTR;

}  // namespace symbol_analysis

// This storage can be used by the custom resolvers.
class AnalyzerStorage {
 public:
  AnalyzerStorage() {}
  bool EntryExists(std::string key) { return storage_map_.contains(key); }
  std::shared_ptr<void> RemoveEntry(std::string key) {
    if (!EntryExists(key)) {
      MYLOG(FATAL, key << " does not exist in the storage")
    }
    auto res = storage_map_[key];
    storage_map_.erase(key);
    return res;
  }
  void AddEntry(std::string key, std::shared_ptr<void> value) {
    storage_map_[key] = value;
    MYLOG(INFO, "Adding <" << key << ", " << value << "> to the storage.");
  }
  std::shared_ptr<void> GetEntry(std::string key) {
    if (!EntryExists(key)) {
      MYLOG(FATAL, key << " does not exist in the storage")
    }
    return storage_map_[key];
  }

  absl::flat_hash_map<std::string, std::shared_ptr<void>> storage_map_;
};

struct ResolveContext {
  std::optional<bool> is_enter;
  ir::IR_PTR ir;
  std::optional<std::vector<symbol_analysis::Scope_PTR>> scopes;
  std::optional<std::string> token_sep;
  std::shared_ptr<AnalyzerStorage> storage;
};

#define CUSTOM_ACTION_SELECTOR_MAP_TYPE \
  absl::flat_hash_map<std::string, CustomActionSelectorCallback>
struct CustomActionSelectorCallback {
  std::function<std::vector<ir::IR_PTR>(ir::IR_PTR)> get_dependencies_callback;
  std::function<std::optional<std::string>(ResolveContext)>
      select_action_callback;
};

struct CustomResolverCallbacks {
  std::function<std::vector<ir::IR_PTR>(ir::IR_PTR)> get_dependencies_callback;
  std::function<std::vector<std::string>(ResolveContext)>
      resolve_values_callback;
};

namespace symbol_analysis {
nlohmann::json GetAction(
    ResolveContext ctx,
    CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map,
    nlohmann::json *elem_to_analyze_dependency_out = nullptr);
bool AnnotationContain(ir::IR_PTR ir, std::string action_type);

struct Range {
  uint64_t start = 0;
  uint64_t end = UINT64_MAX;
  std::string ToString() const {
    return absl::StrFormat("[%d, %d]", start, end);
  }
};

struct UnresolvedError {
  enum class ErrorCode {
    kUnresolvedDefine =
        0,  // The order here matters; a smaller number indicates
            // a higher fix priority.
    kUnresolvedInvalidate = 1,
    kUnresolvedUse = 2
  } error_code;
  std::string error_message;
  ir::IR_PTR error_ir;
  bool operator<(const UnresolvedError &rhs) const {
    return error_ir->GetOrderID() > rhs.error_ir->GetOrderID();
  }
};

class Symbol {
 public:
  Symbol() {}
  Symbol(const Symbol &sym) {
    type_ = sym.type_;
    name_ = sym.name_;
  }
  Symbol(std::string name, std::string type) {
    name_ = name;
    type_ = type;
  }

  std::string ToString() const {
    return absl::StrFormat("(type: %s, name: %s)", type_, name_);
  }

  const std::string &GetType() const { return type_; }
  void SetType(std::string type) { type_ = type; }
  const std::string &GetName() const { return name_; }
  void SetName(std::string name) { name_ = name; }

 private:
  std::string type_;
  std::string name_;
};

class SymbolTable {
 public:
  // Markers identify symbol define, use, and invalidate positions
  struct Marker {
    enum class MarkerType { kDefine, kUse, kInvalidate } type;
    ir::IR_PTR ir;
    std::string ToString() const {
      return absl::StrFormat("Marker(ir: %d, type: %d)", ir->GetID(), type);
    }
  };

  std::vector<Symbol_PTR> FindSymbolForUseAtIR(
      std::optional<absl::flat_hash_set<std::string>> symbol_types,
      ir::IR_PTR ir) const;

  bool CheckSymbolOfNameExists(std::string name) const {
    for (auto &[_type, _name_to_symbol] : type_name_to_symbol_map_) {
      for (auto &[_name, _symbol] : _name_to_symbol) {
        if (_name == name) {
          return true;
        }
      }
    }
    return false;
  }

  bool CheckSymbolExists(Symbol_PTR symbol) const {
    return symbol_markers_map_.contains(symbol);
  }

  bool CheckIfAnySymbolOfNameValidAtIR(std::string symbol_name,
                                       ir::IR_PTR ir) const;

  std::vector<Symbol_PTR> FindAllMatchingSymbols(
      std::optional<absl::flat_hash_set<std::string>> sym_name,
      std::optional<absl::flat_hash_set<std::string>> sym_type) const;

  Symbol_PTR FindSymbol(std::string sym_type, std::string sym_name) const;
  Symbol_PTR FindSymbol(std::string sym_name) const;

  void DefineSymbolInternal(std::string name, std::string type, ir::IR_PTR ir);
  bool DefineSymbol(std::string sym_name, std::string sym_type,
                    ir::IR_PTR ir_defining_this_sym);

  bool InvalidateSymbol(Symbol_PTR symbol, ir::IR_PTR ir);
  bool UseSymbol(Symbol_PTR symbol, ir::IR_PTR ir);

  std::string ToString() const;

  // It's the caller's duty to ensure `type` exists in the map
  const absl::flat_hash_map<std::string, Symbol_PTR> GetAllSymbolsOfType(
      std::string type) const {
    return type_name_to_symbol_map_.at(type);
  }

  absl::flat_hash_map<Symbol_PTR, std::shared_ptr<std::list<Marker>>>
      &GetSymbolMarkersMap() {
    return symbol_markers_map_;
  }

  std::shared_ptr<std::list<Marker>> GetSymbolMarkers(Symbol_PTR symbol) {
    return symbol_markers_map_.at(symbol);
  }

  bool ExistsSymbolOfType(std::string type) const {
    return type_name_to_symbol_map_.contains(type);
  }

 private:
  std::vector<Symbol_PTR> FindAllMatchingSymbolsInternal(
      std::string name, std::string type) const;
  absl::flat_hash_map<std::string /*type*/,
                      absl::flat_hash_map<std::string /*name*/, Symbol_PTR>>
      type_name_to_symbol_map_;
  absl::flat_hash_map<Symbol_PTR, std::shared_ptr<std::list<Marker>>>
      symbol_markers_map_;  // legit seq of def/use/inval
};

class Scope {
 public:
  Scope(std::string scope_name) : scope_name_(scope_name) {
    symbol_table_ = New<SymbolTable>();
  }
  [[deprecated]] Scope() {}

  std::string ToString() const;
  SymbolTable_PTR GetSymbolTable() { return symbol_table_; }
  void SetScopeName(std::string scope_name) { scope_name_ = scope_name; }
  const std::string &GetScopeName() const { return scope_name_; }
  const Range &GetScopeRange() const { return scope_range_; }
  bool ContainIR(const ir::IR_PTR ir) const {
    return scope_range_.start <= ir->GetID() && scope_range_.end >= ir->GetID();
  }
  void SetScopeStart(uint64_t start) { scope_range_.start = start; }
  void SetScopeEnd(uint64_t end) { scope_range_.end = end; }
  void SetParent(Scope_PTR parent) { parent_scope_ = parent; }
  Scope_PTR GetParent() const { return parent_scope_; }

 private:
  std::string scope_name_;
  Range scope_range_;

  Scope_PTR parent_scope_;
  SymbolTable_PTR symbol_table_;
};

class DependencyGraph {
 public:
  void AddVertex(ir::IR_PTR ir);
  // Means `from` depends on `to`.
  // dup edges are ignored
  void AddEdge(ir::IR_PTR from, ir::IR_PTR to);
  void FinalizeGraph();
  void Reset();
  bool HasVertex(ir::IR_PTR ir) const {
    return vertices_adj_list_.contains(ir);
  }
  std::string GetGraphAsString() const;
  void TopoWalk(ir::IRListener_PTR listener) const;

  // Gets all vertices depending on `ir`.
  std::vector<ir::IR_PTR> GetAllDescendentsOfVertex(ir::IR_PTR ir) const;
  // Gets all direct parents which `ir` depends on.
  absl::flat_hash_set<ir::IR_PTR> GetDirectParents(ir::IR_PTR ir) const;

 private:
  void PerformTopoSort();

  std::vector<ir::IR_PTR>
      ordered_vec_;  // valid after call to `PerformTopoSort`

  absl::flat_hash_map<ir::IR_PTR, absl::flat_hash_set<ir::IR_PTR>>
      vertices_adj_list_;  // from -> to
  absl::flat_hash_map<ir::IR_PTR, absl::flat_hash_set<ir::IR_PTR>>
      vertices_adj_list_rev_;  // to -> from
};

// This listener will be invoked by a statement order Walker
class SymbolAnalyzerBuildDependencyGraphListener : public ir::IRListener {
 public:
  SymbolAnalyzerBuildDependencyGraphListener() {
    dependency_graph_ = New<DependencyGraph>();
    analyzer_storage_ = std::make_shared<AnalyzerStorage>();
  }
  ~SymbolAnalyzerBuildDependencyGraphListener(){};
  virtual void EnterIR(ir::IR_PTR ir) override;
  virtual void ExitIR(ir::IR_PTR ir) override;
  void FinalizeDependencyGraph() { dependency_graph_->FinalizeGraph(); }
  const DependencyGraph_PTR GetDependencyGraph() const {
    return dependency_graph_;
  }
  std::vector<ir::IR_PTR> GetAllDescendentsOfIR(ir::IR_PTR ir) const {
    return dependency_graph_->GetAllDescendentsOfVertex(ir);
  }
  void TopoWalk(ir::IRListener_PTR listener) const {
    return dependency_graph_->TopoWalk(listener);
  }
  void SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map) {
    custom_resolver_map_ = map;
  }

  void SetCustomActionSelectorMap(CUSTOM_ACTION_SELECTOR_MAP_TYPE map) {
    custom_action_selector_map_ = map;
  }

 private:
  std::vector<ir::IR_PTR> GetDependencies(const nlohmann::json &anno_type,
                                          ir::IR_PTR context);

  DependencyGraph_PTR dependency_graph_;  // captures the context dependency
  CUSTOM_TYPE_RESOLVER_MAP_TYPE custom_resolver_map_;
  CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map_;
  std::shared_ptr<AnalyzerStorage> analyzer_storage_;
};

// This listener will be invoked by a dependency (topo) order Walker.
// Most analyses are performed in this listener.
class SymbolAnalyzerListener : public ir::IRListener {
 public:
  SymbolAnalyzerListener();
  void RegisterDependencyGraph(DependencyGraph_PTR graph) {
    dependency_graph_ = graph;
  }
  ~SymbolAnalyzerListener(){};
  virtual void EnterIR(ir::IR_PTR ir) override;
  virtual void ExitIR(ir::IR_PTR ir) override;
  std::priority_queue<UnresolvedError> &GetUnresolvedErrors() {
    return errors_;
  }
  void SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map) {
    custom_resolver_map_ = map;
  }
  void SetCustomActionSelectorMap(CUSTOM_ACTION_SELECTOR_MAP_TYPE map) {
    custom_action_selector_map_ = map;
  }

  void RevokeAll(std::vector<ir::IR_PTR> irs);
  const bool CheckIRHasUnresolvedError(ir::IR_PTR ir) const {
    return ir_errors_map_.contains(ir);
  }
  const absl::flat_hash_map<std::string, size_t> GetLabelFreqMap() const {
    return label_freq_map_;
  }
  std::shared_ptr<AnalyzerStorage> GetAnalyzerStorage() {
    return analyzer_storage_;
  }
  const std::vector<Scope_PTR> &GetScopes() const { return scopes_; }
  DependencyGraph_PTR GetDependencyGraph() { return dependency_graph_; }
  void SetTokenSep(std::string token_sep) { token_sep_ = token_sep; }

  // Locates the use marker with the ir and removes it. Returns ir itself (which
  // becomes an error).
  void RemoveIRSymbolUse(ir::IR_PTR ir);

  // Locates the inval marker with the ir, removes it, and refreshes lifetime.
  // Returns ir itself (which becomes an error).
  void RemoveIRSymbolInvalidate(ir::IR_PTR ir);

  // Locates the def marker with the ir, removes it along with uses/invals until
  // the next def, and refreshes lifetime. Returns the error irs.
  void RemoveIRSymbolDefine(ir::IR_PTR ir);

  void EmitUnresolvedError(UnresolvedError err);

  UnresolvedError PopOneUnresolvedErrorFromQueue();

  bool HasUnresolvedError() { return !errors_.empty(); }

  std::vector<std::string> ResolveValues(const nlohmann::json &anno_type,
                                         ir::IR_PTR context);

  Scope_PTR FindScopeByName(std::string scope_name) const;

 private:
  enum class ActionTime { kOnEnter, kOnExit };

  CUSTOM_TYPE_RESOLVER_MAP_TYPE custom_resolver_map_;
  CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map_;

  absl::flat_hash_map<std::string, size_t> label_freq_map_;

  std::string ExpandContextVariable(std::string str, ir::IR_PTR context);

  bool CheckDependencyResolved(ir::IR_PTR ir) const;

  void SetupActionExecutors();
  void ExecuteAction(nlohmann::json action, ir::IR_PTR context,
                     ActionTime action_time);

  // A handler that does nothing. Used to ignore certain actions.
  bool VoidActionHandler(nlohmann::json action_value, ir::IR_PTR context,
                         ActionTime action_time);
  bool ExecuteCreateScope(nlohmann::json action_value, ir::IR_PTR context,
                          ActionTime action_time);
  bool ExecuteExitScope(nlohmann::json action_value, ir::IR_PTR context,
                        ActionTime action_time);
  bool ExecuteDefineSymbol(nlohmann::json action_value, ir::IR_PTR context,
                           ActionTime action_time);
  bool ExecuteInvalidateSymbol(nlohmann::json action_value, ir::IR_PTR context,
                               ActionTime action_time);
  bool ExecuteUseSymbol(nlohmann::json action_value, ir::IR_PTR context,
                        ActionTime action_time);

  void AddScope(Scope_PTR scope);

  absl::flat_hash_map<std::string, bool (SymbolAnalyzerListener::*)(
                                       nlohmann::json, ir::IR_PTR, ActionTime)>
      action_executor_map_;

  std::vector<Scope_PTR> scopes_;
  absl::flat_hash_map<std::string, Scope_PTR> name_to_scope_map_;

  Scope_PTR current_scope_;

  std::shared_ptr<AnalyzerStorage> analyzer_storage_;

  uint64_t
      current_id_max_;  // Stores the current biggest node id during traversal.
                        // This is used to mark the range of the scopes.

  std::priority_queue<symbol_analysis::UnresolvedError> errors_;

  absl::flat_hash_map<ir::IR_PTR, UnresolvedError>
      ir_errors_map_;  // for faster indexing
  std::string token_sep_;
  DependencyGraph_PTR dependency_graph_;  // this is constructed in the
                                          // dependency graph builder listener
};

std::vector<std::string> GetLabelsForDefiningSymbol(
    const nlohmann::json &sym_info);

// Returns a vector of IR labels that can define/use/invalidate a symbol of
// `sym_type`.
std::vector<std::string> GetSupportingLabelsForSymbolType(
    std::string sym_type, const nlohmann::json &sym_info);

class SymbolAnalyzer {
 public:
  SymbolAnalyzer() {
    listener_ = New<SymbolAnalyzerListener>();
    build_depen_graph_listener_ =
        New<SymbolAnalyzerBuildDependencyGraphListener>();
    token_sep_ = " ";
    bitgen_ = std::make_shared<absl::BitGen>();
    listener_->SetTokenSep(token_sep_);
  }
  SymbolAnalyzer(std::string token_sep, std::shared_ptr<absl::BitGen> bitgen) {
    token_sep_ = token_sep;
    bitgen_ = bitgen;
    listener_ = New<SymbolAnalyzerListener>();
    build_depen_graph_listener_ =
        New<SymbolAnalyzerBuildDependencyGraphListener>();
    listener_->SetTokenSep(token_sep_);
  }

  void SetTokenSep(std::string token_sep) { token_sep_ = token_sep; }

  std::vector<ir::IR_PTR> GetAllDescendentsOfIR(ir::IR_PTR ir) const {
    return build_depen_graph_listener_->GetAllDescendentsOfIR(ir);
  }

  const absl::flat_hash_map<std::string, size_t> GetLabelFreqMap() const {
    return listener_->GetLabelFreqMap();
  }

  void SetCustomActionSelectorMap(CUSTOM_ACTION_SELECTOR_MAP_TYPE map) {
    custom_action_selector_map_ = map;
    build_depen_graph_listener_->SetCustomActionSelectorMap(map);
    listener_->SetCustomActionSelectorMap(map);
  }

  void SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map) {
    custom_resolver_map_ = map;
    build_depen_graph_listener_->SetCustomResolverMap(map);
    listener_->SetCustomResolverMap(map);
  }

  void Analyze(ir::IR_PTR root);
  // Tries to fix all the unresolved errors. Returns true if all errors are
  // fixed. Returns false otherwise.
  bool FixUnresolvedErrors();

  std::vector<Symbol_PTR> GetSymbolsForUseAtIR(
      ir::IR_PTR ir,
      std::optional<absl::flat_hash_set<std::string>> symbol_types,
      bool after_ir = false);

  SymbolTable_PTR GetSymbolTableForSymbol(Symbol_PTR symbol) const;
  Scope_PTR GetScopeForSymbolTable(SymbolTable_PTR symtbl) const;

  Scope_PTR GetScopeContainingIR(ir::IR_PTR ir) const;

  Symbol_PTR GetSymbolAssociateWithIR(
      ir::IR_PTR ir, SymbolTable::Marker::MarkerType association_type) const;

  bool InvalidateSymbol(Symbol_PTR symbol, ir::IR_PTR ir);
  void Reset() {
    listener_ = New<SymbolAnalyzerListener>();
    build_depen_graph_listener_ =
        New<SymbolAnalyzerBuildDependencyGraphListener>();

    listener_->SetTokenSep(token_sep_);

    build_depen_graph_listener_->SetCustomResolverMap(custom_resolver_map_);
    listener_->SetCustomResolverMap(custom_resolver_map_);

    build_depen_graph_listener_->SetCustomActionSelectorMap(
        custom_action_selector_map_);
    listener_->SetCustomActionSelectorMap(custom_action_selector_map_);
  }
  void PrintScopes() const;

  size_t GetNumberOfUnresolvedErrors() {
    return listener_->GetUnresolvedErrors().size();
  }

  bool HasUnresolvedError() { return listener_->HasUnresolvedError(); }

  UnresolvedError PopOneUnresolvedErrorFromQueue() {
    return listener_->PopOneUnresolvedErrorFromQueue();
  }

  const bool CheckIRHasUnresolvedError(ir::IR_PTR ir) const {
    return listener_->CheckIRHasUnresolvedError(ir);
  }

  const std::vector<Scope_PTR> &GetScopes() const {
    return listener_->GetScopes();
  }

  size_t GetNumberOfVariables() const;

 private:
  ir::IR_PTR ir_being_analyzed_;
  std::shared_ptr<SymbolAnalyzerListener> listener_;
  std::shared_ptr<SymbolAnalyzerBuildDependencyGraphListener>
      build_depen_graph_listener_;

  struct FixStatus {
    bool fixed = false;
    std::vector<symbol_analysis::UnresolvedError> new_errors;
  };

  ir::IR_PTR GetNextIRInAST(ir::IR_PTR ir) const;
  bool TryFixUnresolvedError(symbol_analysis::UnresolvedError error);
  bool TryFixUnresolvedDefine(symbol_analysis::UnresolvedError error);
  bool TryFixUnresolvedUseOrInvalidate(symbol_analysis::UnresolvedError error);

  void RevokeAll(std::vector<ir::IR_PTR> irs) { listener_->RevokeAll(irs); }
  void InsertMarkerForSymbol(
      Symbol_PTR symbol, ir::IR_PTR marker_ir,
      symbol_analysis::SymbolTable::Marker::MarkerType marker_type);
  void UpdateTerminalWithNewName(ir::IR_PTR ir_to_fix,
                                 std::string new_name) const;

  std::vector<ir::IR_PTR> GetAllLaterUsesAndInvalsOfSymbolBeforeNextDefine(
      ir::IR_PTR after, Symbol_PTR symbol);

  std::string token_sep_ = " ";
  std::shared_ptr<absl::BitGen> bitgen_;
  CUSTOM_TYPE_RESOLVER_MAP_TYPE custom_resolver_map_;
  CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map_;
};

}  // namespace symbol_analysis

#endif  // SRC_SYMBOL_ANALYSIS_H_