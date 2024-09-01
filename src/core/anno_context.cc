#include "anno_context.h"

#include "absl/strings/str_format.h"
#include "parsers/anno_context/generated_parser/AnnoContextLexer.h"
#include "parsers/anno_context/generated_parser/AnnoContextListener.h"
#include "parsers/anno_context/generated_parser/AnnoContextParser.h"
#include "subtree_collector.h"

namespace anno_context {

symbol_analysis::Symbol_PTR AnnoContext::GetSymbolAssociateWithIR(
    ir::IR_PTR ir,
    symbol_analysis::SymbolTable::Marker::MarkerType association_type,
    const std::vector<symbol_analysis::Scope_PTR>& scopes) {
  symbol_analysis::Scope_PTR enclosing_scope = nullptr;
  for (auto& scope : scopes) {
    if (scope->ContainIR(ir)) {
      enclosing_scope = scope;
      break;
    }
  }
  if (!enclosing_scope) {
    MYLOG(FATAL, "No scope contains the target IR")
  }
  absl::flat_hash_map<
      symbol_analysis::Symbol_PTR,
      std::shared_ptr<std::list<symbol_analysis::SymbolTable::Marker>>>&
      tbl_markers_map =
          enclosing_scope->GetSymbolTable()->GetSymbolMarkersMap();
  for (auto& [symbol, markers] : tbl_markers_map) {
    MYLOG(INFO, "checking marker seq for symbol: " << symbol->ToString())
    for (auto each = markers->begin(); each != markers->end(); ++each) {
      MYLOG(INFO, each->ToString())
      if (each->ir == ir && each->type == association_type) {
        return symbol;
      }
    }
  }
  return nullptr;
}

std::string AnnoContextNodeSymUseType::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  symbol_analysis::Symbol_PTR symbol = GetSymbolAssociateWithIR(
      GetTargetIR(), symbol_analysis::SymbolTable::Marker::MarkerType::kUse,
      scopes);
  if (!symbol) {
    MYLOG(FATAL, "Unable to evaluate symusetype for ir: "
                     << target_ir_->ToLinearString());
  }
  return symbol->GetType();
}

std::string AnnoContextNodeSymDefType::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  symbol_analysis::Symbol_PTR symbol = GetSymbolAssociateWithIR(
      GetTargetIR(), symbol_analysis::SymbolTable::Marker::MarkerType::kDefine,
      scopes);
  if (!symbol) {
    MYLOG(FATAL, "Unable to evaluate symdeftype for ir: "
                     << target_ir_->ToLinearString());
  }
  return symbol->GetType();
}

std::string AnnoContextNodeSymInvalType::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  symbol_analysis::Symbol_PTR symbol = GetSymbolAssociateWithIR(
      GetTargetIR(),
      symbol_analysis::SymbolTable::Marker::MarkerType::kInvalidate, scopes);
  if (!symbol) {
    MYLOG(FATAL, "Unable to evaluate syminvaltype for ir: "
                     << target_ir_->ToLinearString());
  }
  return symbol->GetType();
}

std::string AnnoContextID::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  return absl::StrFormat("%d", target_ir_->GetID());
}

std::string AnnoContextTermNum::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  std::vector<ir::IR_PTR> terms =
      subtree_collector::CollectTerminals(target_ir_);
  return absl::StrFormat("%d", terms.size());
}

std::string AnnoContextNodeNum::Evaluate(
    const std::vector<symbol_analysis::Scope_PTR>& scopes,
    std::string token_sep) const {
  std::vector<ir::IR_PTR> terms =
      subtree_collector::CollectNodesOfName(target_ir_, node_name_);
  return absl::StrFormat("%d", terms.size());
}

class MyLexerErrorListener : public antlr4::ANTLRErrorListener {
 public:
  bool GetHasError() const { return has_error_; }
  virtual void syntaxError(antlr4::Recognizer* recognizer,
                           antlr4::Token* offendingSymbol, size_t line,
                           size_t charPositionInLine, const std::string& msg,
                           std::exception_ptr e) override {
    has_error_ = true;
  }
  virtual void reportAmbiguity(antlr4::Parser* recognizer,
                               const antlr4::dfa::DFA& dfa, size_t startIndex,
                               size_t stopIndex, bool exact,
                               const antlrcpp::BitSet& ambigAlts,
                               antlr4::atn::ATNConfigSet* configs) override{};

  virtual void reportAttemptingFullContext(
      antlr4::Parser* recognizer, const antlr4::dfa::DFA& dfa,
      size_t startIndex, size_t stopIndex,
      const antlrcpp::BitSet& conflictingAlts,
      antlr4::atn::ATNConfigSet* configs) override{};

  virtual void reportContextSensitivity(
      antlr4::Parser* recognizer, const antlr4::dfa::DFA& dfa,
      size_t startIndex, size_t stopIndex, size_t prediction,
      antlr4::atn::ATNConfigSet* configs) override{};

 private:
  bool has_error_ = false;
};

// Modified from AnnoContextBaseListener
class MyAnnoContextListener : public AnnoContextListener {
 public:
  MyAnnoContextListener(ir::IR_PTR starting_ir)
      : current_ir_(starting_ir), starting_ir_(starting_ir) {}

  virtual void enterNodePropertyID(
      AnnoContextParser::NodePropertyIDContext* /*ctx*/) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextID>(current_ir_));
  }
  virtual void exitNodePropertyID(
      AnnoContextParser::NodePropertyIDContext* /*ctx*/) override {}

  virtual void enterNodePropertyText(
      AnnoContextParser::NodePropertyTextContext* /*ctx*/) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextText>(current_ir_));
  }
  virtual void exitNodePropertyText(
      AnnoContextParser::NodePropertyTextContext* /*ctx*/) override {}

  virtual void enterNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext* /*ctx*/) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextTermNum>(current_ir_));
  }
  virtual void exitNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext* /*ctx*/) override {}

  virtual void enterNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext* ctx) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextNodeNum>(current_ir_,
                                             ctx->nodetype->getText()));
  }
  virtual void exitNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext* /*ctx*/) override {}

  virtual void enterPointerParent(
      AnnoContextParser::PointerParentContext* /*ctx*/) override {
    current_ir_ = current_ir_->GetParent().lock();
    if (!current_ir_) {
      MYLOG(FATAL, "Failed to perform .parent at:\n"
                       << current_ir_->ToLinearString())
    }
  }
  virtual void exitPointerParent(
      AnnoContextParser::PointerParentContext* /*ctx*/) override {}

  virtual void enterPointerChild(
      AnnoContextParser::PointerChildContext* ctx) override {
    auto& children = current_ir_->GetChildren();
    std::string idx_text = ctx->idx->getText();
    size_t idx = strtoul(idx_text.c_str(), nullptr, 10);
    if (idx >= children.size()) {
      MYLOG(FATAL, "Failed to perform .child at:\n"
                       << current_ir_->ToLinearString())
    }
    current_ir_ = children.at(idx);
  }
  virtual void exitPointerChild(
      AnnoContextParser::PointerChildContext* ctx) override {}

  virtual void enterPointerLSib(
      AnnoContextParser::PointerLSibContext* ctx) override {
    ir::IR_PTR parent = current_ir_->GetParent().lock();
    if (!parent) {
      MYLOG(INFO, "error seeking to parent when performing .lsib at:\n"
                      << current_ir_->ToLinearString())
    }
    // get current idx
    size_t cur_idx = (uint64_t)-1;
    auto& sibs = parent->GetChildren();
    for (size_t i = 0; i < sibs.size(); ++i) {
      if (sibs[i] == current_ir_) {
        cur_idx = i;
        break;
      }
    }
    std::string offset_text = ctx->offset->getText();
    size_t offset = strtoul(offset_text.c_str(), nullptr, 10);
    size_t idx = cur_idx - offset;
    if (idx >= sibs.size()) {
      MYLOG(FATAL, "Failed to perform .lsib at:\n"
                       << current_ir_->ToLinearString())
    }
    current_ir_ = sibs.at(idx);
  }
  virtual void exitPointerLSib(
      AnnoContextParser::PointerLSibContext* /*ctx*/) override {}

  virtual void enterPointerRSib(
      AnnoContextParser::PointerRSibContext* ctx) override {
    auto parent = current_ir_->GetParent().lock();
    if (!parent) {
      MYLOG(INFO, "error seeking to parent when performing .rsib at:\n"
                      << current_ir_->ToLinearString())
    }
    // get current idx
    size_t cur_idx = (uint64_t)-1;
    auto& sibs = parent->GetChildren();
    for (size_t i = 0; i < sibs.size(); ++i) {
      if (sibs[i] == current_ir_) {
        cur_idx = i;
        break;
      }
    }
    std::string offset_text = ctx->offset->getText();
    size_t offset = strtoul(offset_text.c_str(), nullptr, 10);
    size_t idx = cur_idx + offset;
    if (idx >= sibs.size()) {
      MYLOG(FATAL, "Failed to perform .rsib at:\n"
                       << current_ir_->ToLinearString())
    }
    current_ir_ = sibs.at(idx);
  }
  virtual void exitPointerRSib(
      AnnoContextParser::PointerRSibContext* /*ctx*/) override {}

  virtual void enterPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext* ctx) override {
    std::string name = ctx->nodetype->getText();
    while (current_ir_->GetName() != name) {
      current_ir_ = current_ir_->GetParent().lock();
      if (!current_ir_) {
        MYLOG(FATAL, "Invalid parentuntil");
      }
    }
  }

  virtual void exitPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext* /*ctx*/) override {}

  virtual void enterNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext* ctx) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextNodeSymUseType>(current_ir_));
  }
  virtual void exitNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext* ctx) override {}

  virtual void enterNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext* ctx) override {}
  virtual void exitNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext* ctx) override {}

  virtual void enterNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext* ctx) override {}
  virtual void exitNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext* ctx) override {}

  virtual void enterDynamic(
      AnnoContextParser::DynamicContext* /*ctx*/) override {
    current_ir_ = starting_ir_;
  }
  virtual void exitDynamic(
      AnnoContextParser::DynamicContext* /*ctx*/) override {}

  virtual void enterFixed(AnnoContextParser::FixedContext* ctx) override {
    context_seq_.GetContextSequence().push_back(
        std::make_shared<AnnoContextPlainText>(ctx->getText()));
  }
  virtual void exitFixed(AnnoContextParser::FixedContext* /*ctx*/) override {}

  virtual void enterContext(
      AnnoContextParser::ContextContext* /*ctx*/) override {}
  virtual void exitContext(
      AnnoContextParser::ContextContext* /*ctx*/) override {}

  virtual void enterEntry_point(
      AnnoContextParser::Entry_pointContext* /*ctx*/) override {}
  virtual void exitEntry_point(
      AnnoContextParser::Entry_pointContext* /*ctx*/) override {}

  virtual void enterEveryRule(antlr4::ParserRuleContext* /*ctx*/) override {}
  virtual void exitEveryRule(antlr4::ParserRuleContext* /*ctx*/) override {}
  virtual void visitTerminal(antlr4::tree::TerminalNode* /*node*/) override {}
  virtual void visitErrorNode(antlr4::tree::ErrorNode* /*node*/) override {}
  AnnoContextSequence GetContextSequence() const { return context_seq_; }

 private:
  AnnoContextSequence context_seq_;
  ir::IR_PTR current_ir_;
  ir::IR_PTR starting_ir_;
};

// `ir`'s annotation contains `context_str`, but it may contain multiple other `context_str`s, so for easier impl reasons
// we do not look into `ir`'s annotion here.
AnnoContextSequence AnnoContextAnalyzer::AnalyzeSequence(
    ir::IR_PTR ir, std::string context_str) {
  antlr4::ANTLRInputStream input(context_str);
  AnnoContextLexer lexer(&input);
  antlr4::CommonTokenStream tokens(&lexer);
  AnnoContextParser parser(&tokens);

  MyLexerErrorListener lexer_error_listener;
  lexer.addErrorListener(&lexer_error_listener);

  antlr4::tree::ParseTree* tree = parser.entry_point();

  MyAnnoContextListener l(ir);
  antlr4::tree::ParseTreeWalker::DEFAULT.walk(
      (antlr4::tree::ParseTreeListener*)&l, tree);

  if (lexer_error_listener.GetHasError()) {
    MYLOG(FATAL,
          absl::StrFormat("Lexer error when processing anno context expr: `%s`",
                          context_str))
  }

  if (parser.getNumberOfSyntaxErrors()) {
    MYLOG(FATAL, absl::StrFormat(
                     "Syntax error when processing anno context expr: `%s`",
                     context_str))
  }
  return l.GetContextSequence();
}

}  // namespace anno_context
