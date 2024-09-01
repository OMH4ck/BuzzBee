// clang-format off
#include <cstddef>
#include <iostream>

#include "##grammar##_frontend.h"
#include "##Grammar##BaseListener.h"
#include "##Grammar##Lexer.h"
#include "##Grammar##Parser.h"
#include "absl/container/flat_hash_map.h"
#include "glog/logging.h"
#include "src/core/ir.h"

using namespace antlr4;
using namespace frontend;

namespace ##grammar##_frontend {

#include "##Grammar##AnnotationCollector.h"

##GLOBALS##

misc::Interval GetTreeSourceInterval(tree::ParseTree * tree) {
if (tree->getTreeType() == antlr4::tree::ParseTreeType::RULE) {
    return misc::Interval(
        ((ParserRuleContext *)tree)->getStart()->getStartIndex(),
        ((ParserRuleContext *)tree)->getStop()->getStopIndex());
} else {
    return misc::Interval(
        ((antlr4::tree::TerminalNode *)tree)->getSymbol()->getStartIndex(),
        ((antlr4::tree::TerminalNode *)tree)->getSymbol()->getStopIndex());
}
}

ir::IR_PTR TranslateANTLR4ParseTreeToIR(
    tree::ParseTree * tree, Parser * parser, ANTLRInputStream * input,
    ##Grammar##AnnotationListener * l) {
ir::IR_PTR root = ir::IR::NewIR();

switch (tree->getTreeType()) {
    case antlr4::tree::ParseTreeType::RULE: {
    if (l->tagged_rules_.contains(tree)) {
        auto &[label, annotation] = l->tagged_rules_[tree];
        root->SetAnnotationLabel(label);
        root->SetAnnotationFromString(annotation);
    }

    ParserRuleContext *rule = (ParserRuleContext *)tree;
    root->SetIRType(AsRule(rule->getRuleIndex()));
    root->SetIsTerminal(false);

    root->SetName(
        std::string(parser->getRuleNames()[rule->getRuleIndex()]));

    for (auto &each : tree->children) {
        ir::IR_PTR child =
            TranslateANTLR4ParseTreeToIR(each, parser, input, l);

        if (child) {
        child->SetParent(root);
        root->GetChildren().push_back(child);
        }
    }
    return root;
    }

    case antlr4::tree::ParseTreeType::TERMINAL: {
    antlr4::tree::TerminalNode *node = (antlr4::tree::TerminalNode *)tree;

    if (node->getSymbol()->getType() == (size_t)-1) {
        // this is EOF
        return nullptr;
    }

    if (l->tagged_rules_.contains(node->getSymbol())) {
        auto ptr = node->getSymbol();
        auto &[label, annotation] = l->tagged_rules_[ptr];
        root->SetAnnotationLabel(label);
        root->SetAnnotationFromString(annotation);
    }
    root->SetIRType(AsTerminal(node->getSymbol()->getType()));
    root->SetIsTerminal(true);
    misc::Interval interval(GetTreeSourceInterval(tree));
    root->SetName(input->getText(interval));
    return root;
    }

    default:
    assert(false && "ERROR");
}
}

class MyLexerErrorListener : public ANTLRErrorListener {
public:
bool GetHasError() const { return has_error_; }
virtual void syntaxError(Recognizer *recognizer, Token *offendingSymbol,
                            size_t line, size_t charPositionInLine,
                            const std::string &msg,
                            std::exception_ptr e) override {
    has_error_ = true;
}
virtual void reportAmbiguity(Parser *recognizer, const dfa::DFA &dfa,
                                size_t startIndex, size_t stopIndex,
                                bool exact, const antlrcpp::BitSet &ambigAlts,
                                atn::ATNConfigSet *configs) override{};

virtual void reportAttemptingFullContext(
    Parser *recognizer, const dfa::DFA &dfa, size_t startIndex,
    size_t stopIndex, const antlrcpp::BitSet &conflictingAlts,
    atn::ATNConfigSet *configs) override{};

virtual void reportContextSensitivity(
    Parser *recognizer, const dfa::DFA &dfa, size_t startIndex,
    size_t stopIndex, size_t prediction,
    atn::ATNConfigSet *configs) override{};

private:
bool has_error_ = false;
};

std::string GetSymInfo() {
    ##ReturnRawSymInfoPlaceholder##
}


std::vector<InsertableType> GetInsertableTypes() {
return {
##InsertableTypesPlaceholder##
};
}

uint64_t GetReplaceBoundaryType() {
    return ##ReplaceBoundary##;
}

absl::flat_hash_map<uint64_t, double> GetWeightMap() {
    return ##WeightMap##;
}

std::vector<RemovableType> GetRemovableTypes() {
return {
##RemovableTypesPlaceholder##
};
}

##ExposeRuleTypeAPIPlaceholder##


##CustomActionSelectorPlaceholder##

CUSTOM_ACTION_SELECTOR_MAP_TYPE
kCustomActionSelectorMap = {
##CustomActionSelectorMapPlaceholder##
};


##CustomTypeResolversPlaceholder##

CUSTOM_TYPE_RESOLVER_MAP_TYPE
kCustomHandlerMap = {
##CustomTypeResolversMapPlaceholder##
};

MUTATION_CANDIDATE_MAP_TYPE GetMutationCandidateMap() {
  return {
##GetMutationCandidateMapPlaceHolder##
  };
}

CUSTOM_ACTION_SELECTOR_MAP_TYPE GetCustomActionSelectorMap() {
    return kCustomActionSelectorMap;
}

CUSTOM_TYPE_RESOLVER_MAP_TYPE GetCustomTypeResolverMap() {
    return kCustomHandlerMap;
}


size_t GetNumOfRuleIRTypes() {
  static auto parser = ##Grammar##Parser(nullptr);
  return parser.getRuleNames().size();
}

size_t GetNumOfTerminalIRTypes() {
  static auto parser = ##Grammar##Parser(nullptr);
  return parser.getVocabulary().getMaxTokenType() + 1;
}

std::string GetIRTypeNameFromGrammar(uint64_t ir_type) {
  static auto parser = ##Grammar##Parser(nullptr);
  if(ir_type & 3 == 0) {
    // AsRule
    size_t rule_idx = ir_type >> 2;
    return parser.getRuleNames()[rule_idx];
  } else {
    // TERMINAL TYPE
    size_t token_idx = ir_type >> 2;
    return parser.getVocabulary().getDisplayName(token_idx);
  }
}

// Returns nullptr upon parsing error
ir::IR_PTR ParseSourceToIR(std::string source) {
  static ##Grammar##Parser s_parser(nullptr);
  static atn::ParserATNSimulator* s_parser_interpreter;
  static std::vector<antlr4::dfa::DFA>* s_decision_to_dfa;
  static std::unique_ptr<antlr4::atn::PredictionContextCache> s_cache;
  static bool init = false;
  if (!init) {
    init = true;
    s_cache = std::make_unique<antlr4::atn::PredictionContextCache>();
    auto parser_interpreter =
        s_parser.getInterpreter<atn::ParserATNSimulator>();
    s_decision_to_dfa = &parser_interpreter->decisionToDFA;
    s_parser_interpreter = new atn::ParserATNSimulator(
        &s_parser, s_parser.getATN(), *s_decision_to_dfa, *s_cache);
    s_parser.setInterpreter(s_parser_interpreter);
  }

    ANTLRInputStream input(source);
    ##Grammar##Lexer lexer(&input);
    CommonTokenStream tokens(&lexer);
    tokens.fill();

    s_parser.setTokenStream(&tokens);
    

    MyLexerErrorListener lexer_error_listener;
    lexer.removeErrorListeners();
    lexer.addErrorListener(&lexer_error_listener);

    MyLexerErrorListener parser_error_listener;
    s_parser.removeErrorListeners();
    s_parser.addErrorListener(&parser_error_listener);

    tree::ParseTree *tree = s_parser.entry_point();


    ##Grammar##AnnotationListener l;
    tree::ParseTreeWalker::DEFAULT.walk((tree::ParseTreeListener *)&l, tree);

    if (lexer_error_listener.GetHasError()) {
      return nullptr;
    }

    if (parser_error_listener.GetHasError()) {
      return nullptr;
    }

    static size_t s_counter = 0;

    if (s_counter++ > 10000) {
    s_counter = 0;
    s_parser_interpreter->clearDFA();
    s_cache = std::make_unique<antlr4::atn::PredictionContextCache>();
    s_parser_interpreter = new atn::ParserATNSimulator(
        &s_parser, s_parser.getATN(), *s_decision_to_dfa, *s_cache);
    s_parser.setInterpreter(s_parser_interpreter);
  }


    ir::IR_PTR root = TranslateANTLR4ParseTreeToIR(tree, &s_parser, &input, &l);
    return root;
}

extern "C" {
    std::shared_ptr<##Grammar##Interface> interface = std::make_shared<##Grammar##Interface>();
}

}  // namespace ##grammar##_frontend