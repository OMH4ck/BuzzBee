
// Generated from ./AnnoContext.g4 by ANTLR 4.11.1


#include "AnnoContextListener.h"

#include "AnnoContextParser.h"


using namespace antlrcpp;

using namespace antlr4;

namespace {

struct AnnoContextParserStaticData final {
  AnnoContextParserStaticData(std::vector<std::string> ruleNames,
                        std::vector<std::string> literalNames,
                        std::vector<std::string> symbolicNames)
      : ruleNames(std::move(ruleNames)), literalNames(std::move(literalNames)),
        symbolicNames(std::move(symbolicNames)),
        vocabulary(this->literalNames, this->symbolicNames) {}

  AnnoContextParserStaticData(const AnnoContextParserStaticData&) = delete;
  AnnoContextParserStaticData(AnnoContextParserStaticData&&) = delete;
  AnnoContextParserStaticData& operator=(const AnnoContextParserStaticData&) = delete;
  AnnoContextParserStaticData& operator=(AnnoContextParserStaticData&&) = delete;

  std::vector<antlr4::dfa::DFA> decisionToDFA;
  antlr4::atn::PredictionContextCache sharedContextCache;
  const std::vector<std::string> ruleNames;
  const std::vector<std::string> literalNames;
  const std::vector<std::string> symbolicNames;
  const antlr4::dfa::Vocabulary vocabulary;
  antlr4::atn::SerializedATNView serializedATN;
  std::unique_ptr<antlr4::atn::ATN> atn;
};

::antlr4::internal::OnceFlag annocontextParserOnceFlag;
AnnoContextParserStaticData *annocontextParserStaticData = nullptr;

void annocontextParserInitialize() {
  assert(annocontextParserStaticData == nullptr);
  auto staticData = std::make_unique<AnnoContextParserStaticData>(
    std::vector<std::string>{
      "node_property", "pointer", "term", "context", "entry_point"
    },
    std::vector<std::string>{
      "", "'@id'", "'@text'", "'@sym_use_type'", "'@sym_def_type'", "'@sym_inval_type'", 
      "'@term_num'", "'@node_num'", "'('", "')'", "'.parent'", "'.child'", 
      "'.lsib'", "'.rsib'", "'.parentuntil'", "'{'", "'}'"
    },
    std::vector<std::string>{
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
      "INTEGER", "IDENT"
    }
  );
  static const int32_t serializedATNSegment[] = {
  	4,1,18,63,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,1,0,1,0,1,0,1,0,1,0,
  	1,0,1,0,1,0,1,0,1,0,3,0,21,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,40,8,1,1,2,1,2,5,2,44,8,2,10,2,12,2,
  	47,9,2,1,2,1,2,1,2,1,2,3,2,53,8,2,1,3,4,3,56,8,3,11,3,12,3,57,1,4,1,4,
  	1,4,1,4,0,0,5,0,2,4,6,8,0,0,70,0,20,1,0,0,0,2,39,1,0,0,0,4,52,1,0,0,0,
  	6,55,1,0,0,0,8,59,1,0,0,0,10,21,5,1,0,0,11,21,5,2,0,0,12,21,5,3,0,0,13,
  	21,5,4,0,0,14,21,5,5,0,0,15,21,5,6,0,0,16,17,5,7,0,0,17,18,5,8,0,0,18,
  	19,5,18,0,0,19,21,5,9,0,0,20,10,1,0,0,0,20,11,1,0,0,0,20,12,1,0,0,0,20,
  	13,1,0,0,0,20,14,1,0,0,0,20,15,1,0,0,0,20,16,1,0,0,0,21,1,1,0,0,0,22,
  	40,5,10,0,0,23,24,5,11,0,0,24,25,5,8,0,0,25,26,5,17,0,0,26,40,5,9,0,0,
  	27,28,5,12,0,0,28,29,5,8,0,0,29,30,5,17,0,0,30,40,5,9,0,0,31,32,5,13,
  	0,0,32,33,5,8,0,0,33,34,5,17,0,0,34,40,5,9,0,0,35,36,5,14,0,0,36,37,5,
  	8,0,0,37,38,5,18,0,0,38,40,5,9,0,0,39,22,1,0,0,0,39,23,1,0,0,0,39,27,
  	1,0,0,0,39,31,1,0,0,0,39,35,1,0,0,0,40,3,1,0,0,0,41,45,5,15,0,0,42,44,
  	3,2,1,0,43,42,1,0,0,0,44,47,1,0,0,0,45,43,1,0,0,0,45,46,1,0,0,0,46,48,
  	1,0,0,0,47,45,1,0,0,0,48,49,3,0,0,0,49,50,5,16,0,0,50,53,1,0,0,0,51,53,
  	5,18,0,0,52,41,1,0,0,0,52,51,1,0,0,0,53,5,1,0,0,0,54,56,3,4,2,0,55,54,
  	1,0,0,0,56,57,1,0,0,0,57,55,1,0,0,0,57,58,1,0,0,0,58,7,1,0,0,0,59,60,
  	3,6,3,0,60,61,5,0,0,1,61,9,1,0,0,0,5,20,39,45,52,57
  };
  staticData->serializedATN = antlr4::atn::SerializedATNView(serializedATNSegment, sizeof(serializedATNSegment) / sizeof(serializedATNSegment[0]));

  antlr4::atn::ATNDeserializer deserializer;
  staticData->atn = deserializer.deserialize(staticData->serializedATN);

  const size_t count = staticData->atn->getNumberOfDecisions();
  staticData->decisionToDFA.reserve(count);
  for (size_t i = 0; i < count; i++) { 
    staticData->decisionToDFA.emplace_back(staticData->atn->getDecisionState(i), i);
  }
  annocontextParserStaticData = staticData.release();
}

}

AnnoContextParser::AnnoContextParser(TokenStream *input) : AnnoContextParser(input, antlr4::atn::ParserATNSimulatorOptions()) {}

AnnoContextParser::AnnoContextParser(TokenStream *input, const antlr4::atn::ParserATNSimulatorOptions &options) : Parser(input) {
  AnnoContextParser::initialize();
  _interpreter = new atn::ParserATNSimulator(this, *annocontextParserStaticData->atn, annocontextParserStaticData->decisionToDFA, annocontextParserStaticData->sharedContextCache, options);
}

AnnoContextParser::~AnnoContextParser() {
  delete _interpreter;
}

const atn::ATN& AnnoContextParser::getATN() const {
  return *annocontextParserStaticData->atn;
}

std::string AnnoContextParser::getGrammarFileName() const {
  return "AnnoContext.g4";
}

const std::vector<std::string>& AnnoContextParser::getRuleNames() const {
  return annocontextParserStaticData->ruleNames;
}

const dfa::Vocabulary& AnnoContextParser::getVocabulary() const {
  return annocontextParserStaticData->vocabulary;
}

antlr4::atn::SerializedATNView AnnoContextParser::getSerializedATN() const {
  return annocontextParserStaticData->serializedATN;
}


//----------------- Node_propertyContext ------------------------------------------------------------------

AnnoContextParser::Node_propertyContext::Node_propertyContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t AnnoContextParser::Node_propertyContext::getRuleIndex() const {
  return AnnoContextParser::RuleNode_property;
}

void AnnoContextParser::Node_propertyContext::copyFrom(Node_propertyContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- NodePropertyIDContext ------------------------------------------------------------------

AnnoContextParser::NodePropertyIDContext::NodePropertyIDContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertyIDContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertyID(this);
}
void AnnoContextParser::NodePropertyIDContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertyID(this);
}
//----------------- NodePropertyNodeNumContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::NodePropertyNodeNumContext::IDENT() {
  return getToken(AnnoContextParser::IDENT, 0);
}

AnnoContextParser::NodePropertyNodeNumContext::NodePropertyNodeNumContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertyNodeNumContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertyNodeNum(this);
}
void AnnoContextParser::NodePropertyNodeNumContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertyNodeNum(this);
}
//----------------- NodePropertySymDefTypeContext ------------------------------------------------------------------

AnnoContextParser::NodePropertySymDefTypeContext::NodePropertySymDefTypeContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertySymDefTypeContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertySymDefType(this);
}
void AnnoContextParser::NodePropertySymDefTypeContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertySymDefType(this);
}
//----------------- NodePropertyTextContext ------------------------------------------------------------------

AnnoContextParser::NodePropertyTextContext::NodePropertyTextContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertyTextContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertyText(this);
}
void AnnoContextParser::NodePropertyTextContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertyText(this);
}
//----------------- NodePropertySymInvalTypeContext ------------------------------------------------------------------

AnnoContextParser::NodePropertySymInvalTypeContext::NodePropertySymInvalTypeContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertySymInvalTypeContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertySymInvalType(this);
}
void AnnoContextParser::NodePropertySymInvalTypeContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertySymInvalType(this);
}
//----------------- NodePropertySymUseTypeContext ------------------------------------------------------------------

AnnoContextParser::NodePropertySymUseTypeContext::NodePropertySymUseTypeContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertySymUseTypeContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertySymUseType(this);
}
void AnnoContextParser::NodePropertySymUseTypeContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertySymUseType(this);
}
//----------------- NodePropertyTermNumContext ------------------------------------------------------------------

AnnoContextParser::NodePropertyTermNumContext::NodePropertyTermNumContext(Node_propertyContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::NodePropertyTermNumContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterNodePropertyTermNum(this);
}
void AnnoContextParser::NodePropertyTermNumContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitNodePropertyTermNum(this);
}
AnnoContextParser::Node_propertyContext* AnnoContextParser::node_property() {
  Node_propertyContext *_localctx = _tracker.createInstance<Node_propertyContext>(_ctx, getState());
  enterRule(_localctx, 0, AnnoContextParser::RuleNode_property);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(20);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case AnnoContextParser::T__0: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertyIDContext>(_localctx);
        enterOuterAlt(_localctx, 1);
        setState(10);
        match(AnnoContextParser::T__0);
        break;
      }

      case AnnoContextParser::T__1: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertyTextContext>(_localctx);
        enterOuterAlt(_localctx, 2);
        setState(11);
        match(AnnoContextParser::T__1);
        break;
      }

      case AnnoContextParser::T__2: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertySymUseTypeContext>(_localctx);
        enterOuterAlt(_localctx, 3);
        setState(12);
        match(AnnoContextParser::T__2);
        break;
      }

      case AnnoContextParser::T__3: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertySymDefTypeContext>(_localctx);
        enterOuterAlt(_localctx, 4);
        setState(13);
        match(AnnoContextParser::T__3);
        break;
      }

      case AnnoContextParser::T__4: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertySymInvalTypeContext>(_localctx);
        enterOuterAlt(_localctx, 5);
        setState(14);
        match(AnnoContextParser::T__4);
        break;
      }

      case AnnoContextParser::T__5: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertyTermNumContext>(_localctx);
        enterOuterAlt(_localctx, 6);
        setState(15);
        match(AnnoContextParser::T__5);
        break;
      }

      case AnnoContextParser::T__6: {
        _localctx = _tracker.createInstance<AnnoContextParser::NodePropertyNodeNumContext>(_localctx);
        enterOuterAlt(_localctx, 7);
        setState(16);
        match(AnnoContextParser::T__6);
        setState(17);
        match(AnnoContextParser::T__7);
        setState(18);
        antlrcpp::downCast<NodePropertyNodeNumContext *>(_localctx)->nodetype = match(AnnoContextParser::IDENT);
        setState(19);
        match(AnnoContextParser::T__8);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- PointerContext ------------------------------------------------------------------

AnnoContextParser::PointerContext::PointerContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t AnnoContextParser::PointerContext::getRuleIndex() const {
  return AnnoContextParser::RulePointer;
}

void AnnoContextParser::PointerContext::copyFrom(PointerContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- PointerParentContext ------------------------------------------------------------------

AnnoContextParser::PointerParentContext::PointerParentContext(PointerContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::PointerParentContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterPointerParent(this);
}
void AnnoContextParser::PointerParentContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitPointerParent(this);
}
//----------------- PointerChildContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::PointerChildContext::INTEGER() {
  return getToken(AnnoContextParser::INTEGER, 0);
}

AnnoContextParser::PointerChildContext::PointerChildContext(PointerContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::PointerChildContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterPointerChild(this);
}
void AnnoContextParser::PointerChildContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitPointerChild(this);
}
//----------------- PointerLSibContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::PointerLSibContext::INTEGER() {
  return getToken(AnnoContextParser::INTEGER, 0);
}

AnnoContextParser::PointerLSibContext::PointerLSibContext(PointerContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::PointerLSibContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterPointerLSib(this);
}
void AnnoContextParser::PointerLSibContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitPointerLSib(this);
}
//----------------- PointerParentUntilContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::PointerParentUntilContext::IDENT() {
  return getToken(AnnoContextParser::IDENT, 0);
}

AnnoContextParser::PointerParentUntilContext::PointerParentUntilContext(PointerContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::PointerParentUntilContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterPointerParentUntil(this);
}
void AnnoContextParser::PointerParentUntilContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitPointerParentUntil(this);
}
//----------------- PointerRSibContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::PointerRSibContext::INTEGER() {
  return getToken(AnnoContextParser::INTEGER, 0);
}

AnnoContextParser::PointerRSibContext::PointerRSibContext(PointerContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::PointerRSibContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterPointerRSib(this);
}
void AnnoContextParser::PointerRSibContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitPointerRSib(this);
}
AnnoContextParser::PointerContext* AnnoContextParser::pointer() {
  PointerContext *_localctx = _tracker.createInstance<PointerContext>(_ctx, getState());
  enterRule(_localctx, 2, AnnoContextParser::RulePointer);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(39);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case AnnoContextParser::T__9: {
        _localctx = _tracker.createInstance<AnnoContextParser::PointerParentContext>(_localctx);
        enterOuterAlt(_localctx, 1);
        setState(22);
        match(AnnoContextParser::T__9);
        break;
      }

      case AnnoContextParser::T__10: {
        _localctx = _tracker.createInstance<AnnoContextParser::PointerChildContext>(_localctx);
        enterOuterAlt(_localctx, 2);
        setState(23);
        match(AnnoContextParser::T__10);
        setState(24);
        match(AnnoContextParser::T__7);
        setState(25);
        antlrcpp::downCast<PointerChildContext *>(_localctx)->idx = match(AnnoContextParser::INTEGER);
        setState(26);
        match(AnnoContextParser::T__8);
        break;
      }

      case AnnoContextParser::T__11: {
        _localctx = _tracker.createInstance<AnnoContextParser::PointerLSibContext>(_localctx);
        enterOuterAlt(_localctx, 3);
        setState(27);
        match(AnnoContextParser::T__11);
        setState(28);
        match(AnnoContextParser::T__7);
        setState(29);
        antlrcpp::downCast<PointerLSibContext *>(_localctx)->offset = match(AnnoContextParser::INTEGER);
        setState(30);
        match(AnnoContextParser::T__8);
        break;
      }

      case AnnoContextParser::T__12: {
        _localctx = _tracker.createInstance<AnnoContextParser::PointerRSibContext>(_localctx);
        enterOuterAlt(_localctx, 4);
        setState(31);
        match(AnnoContextParser::T__12);
        setState(32);
        match(AnnoContextParser::T__7);
        setState(33);
        antlrcpp::downCast<PointerRSibContext *>(_localctx)->offset = match(AnnoContextParser::INTEGER);
        setState(34);
        match(AnnoContextParser::T__8);
        break;
      }

      case AnnoContextParser::T__13: {
        _localctx = _tracker.createInstance<AnnoContextParser::PointerParentUntilContext>(_localctx);
        enterOuterAlt(_localctx, 5);
        setState(35);
        match(AnnoContextParser::T__13);
        setState(36);
        match(AnnoContextParser::T__7);
        setState(37);
        antlrcpp::downCast<PointerParentUntilContext *>(_localctx)->nodetype = match(AnnoContextParser::IDENT);
        setState(38);
        match(AnnoContextParser::T__8);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- TermContext ------------------------------------------------------------------

AnnoContextParser::TermContext::TermContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t AnnoContextParser::TermContext::getRuleIndex() const {
  return AnnoContextParser::RuleTerm;
}

void AnnoContextParser::TermContext::copyFrom(TermContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- DynamicContext ------------------------------------------------------------------

AnnoContextParser::Node_propertyContext* AnnoContextParser::DynamicContext::node_property() {
  return getRuleContext<AnnoContextParser::Node_propertyContext>(0);
}

std::vector<AnnoContextParser::PointerContext *> AnnoContextParser::DynamicContext::pointer() {
  return getRuleContexts<AnnoContextParser::PointerContext>();
}

AnnoContextParser::PointerContext* AnnoContextParser::DynamicContext::pointer(size_t i) {
  return getRuleContext<AnnoContextParser::PointerContext>(i);
}

AnnoContextParser::DynamicContext::DynamicContext(TermContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::DynamicContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterDynamic(this);
}
void AnnoContextParser::DynamicContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitDynamic(this);
}
//----------------- FixedContext ------------------------------------------------------------------

tree::TerminalNode* AnnoContextParser::FixedContext::IDENT() {
  return getToken(AnnoContextParser::IDENT, 0);
}

AnnoContextParser::FixedContext::FixedContext(TermContext *ctx) { copyFrom(ctx); }

void AnnoContextParser::FixedContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterFixed(this);
}
void AnnoContextParser::FixedContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitFixed(this);
}
AnnoContextParser::TermContext* AnnoContextParser::term() {
  TermContext *_localctx = _tracker.createInstance<TermContext>(_ctx, getState());
  enterRule(_localctx, 4, AnnoContextParser::RuleTerm);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(52);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case AnnoContextParser::T__14: {
        _localctx = _tracker.createInstance<AnnoContextParser::DynamicContext>(_localctx);
        enterOuterAlt(_localctx, 1);
        setState(41);
        match(AnnoContextParser::T__14);
        setState(45);
        _errHandler->sync(this);
        _la = _input->LA(1);
        while (((_la & ~ 0x3fULL) == 0) &&
          ((1ULL << _la) & 31744) != 0) {
          setState(42);
          pointer();
          setState(47);
          _errHandler->sync(this);
          _la = _input->LA(1);
        }
        setState(48);
        node_property();
        setState(49);
        match(AnnoContextParser::T__15);
        break;
      }

      case AnnoContextParser::IDENT: {
        _localctx = _tracker.createInstance<AnnoContextParser::FixedContext>(_localctx);
        enterOuterAlt(_localctx, 2);
        setState(51);
        match(AnnoContextParser::IDENT);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- ContextContext ------------------------------------------------------------------

AnnoContextParser::ContextContext::ContextContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<AnnoContextParser::TermContext *> AnnoContextParser::ContextContext::term() {
  return getRuleContexts<AnnoContextParser::TermContext>();
}

AnnoContextParser::TermContext* AnnoContextParser::ContextContext::term(size_t i) {
  return getRuleContext<AnnoContextParser::TermContext>(i);
}


size_t AnnoContextParser::ContextContext::getRuleIndex() const {
  return AnnoContextParser::RuleContext;
}

void AnnoContextParser::ContextContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterContext(this);
}

void AnnoContextParser::ContextContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitContext(this);
}

AnnoContextParser::ContextContext* AnnoContextParser::context() {
  ContextContext *_localctx = _tracker.createInstance<ContextContext>(_ctx, getState());
  enterRule(_localctx, 6, AnnoContextParser::RuleContext);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(55); 
    _errHandler->sync(this);
    _la = _input->LA(1);
    do {
      setState(54);
      term();
      setState(57); 
      _errHandler->sync(this);
      _la = _input->LA(1);
    } while (_la == AnnoContextParser::T__14

    || _la == AnnoContextParser::IDENT);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Entry_pointContext ------------------------------------------------------------------

AnnoContextParser::Entry_pointContext::Entry_pointContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

AnnoContextParser::ContextContext* AnnoContextParser::Entry_pointContext::context() {
  return getRuleContext<AnnoContextParser::ContextContext>(0);
}

tree::TerminalNode* AnnoContextParser::Entry_pointContext::EOF() {
  return getToken(AnnoContextParser::EOF, 0);
}


size_t AnnoContextParser::Entry_pointContext::getRuleIndex() const {
  return AnnoContextParser::RuleEntry_point;
}

void AnnoContextParser::Entry_pointContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterEntry_point(this);
}

void AnnoContextParser::Entry_pointContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<AnnoContextListener *>(listener);
  if (parserListener != nullptr)
    parserListener->exitEntry_point(this);
}

AnnoContextParser::Entry_pointContext* AnnoContextParser::entry_point() {
  Entry_pointContext *_localctx = _tracker.createInstance<Entry_pointContext>(_ctx, getState());
  enterRule(_localctx, 8, AnnoContextParser::RuleEntry_point);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(59);
    context();
    setState(60);
    match(AnnoContextParser::EOF);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

void AnnoContextParser::initialize() {
  ::antlr4::internal::call_once(annocontextParserOnceFlag, annocontextParserInitialize);
}
