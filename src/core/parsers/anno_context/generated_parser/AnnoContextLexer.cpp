
// Generated from ./AnnoContext.g4 by ANTLR 4.11.1


#include "AnnoContextLexer.h"


using namespace antlr4;



using namespace antlr4;

namespace {

struct AnnoContextLexerStaticData final {
  AnnoContextLexerStaticData(std::vector<std::string> ruleNames,
                          std::vector<std::string> channelNames,
                          std::vector<std::string> modeNames,
                          std::vector<std::string> literalNames,
                          std::vector<std::string> symbolicNames)
      : ruleNames(std::move(ruleNames)), channelNames(std::move(channelNames)),
        modeNames(std::move(modeNames)), literalNames(std::move(literalNames)),
        symbolicNames(std::move(symbolicNames)),
        vocabulary(this->literalNames, this->symbolicNames) {}

  AnnoContextLexerStaticData(const AnnoContextLexerStaticData&) = delete;
  AnnoContextLexerStaticData(AnnoContextLexerStaticData&&) = delete;
  AnnoContextLexerStaticData& operator=(const AnnoContextLexerStaticData&) = delete;
  AnnoContextLexerStaticData& operator=(AnnoContextLexerStaticData&&) = delete;

  std::vector<antlr4::dfa::DFA> decisionToDFA;
  antlr4::atn::PredictionContextCache sharedContextCache;
  const std::vector<std::string> ruleNames;
  const std::vector<std::string> channelNames;
  const std::vector<std::string> modeNames;
  const std::vector<std::string> literalNames;
  const std::vector<std::string> symbolicNames;
  const antlr4::dfa::Vocabulary vocabulary;
  antlr4::atn::SerializedATNView serializedATN;
  std::unique_ptr<antlr4::atn::ATN> atn;
};

::antlr4::internal::OnceFlag annocontextlexerLexerOnceFlag;
AnnoContextLexerStaticData *annocontextlexerLexerStaticData = nullptr;

void annocontextlexerLexerInitialize() {
  assert(annocontextlexerLexerStaticData == nullptr);
  auto staticData = std::make_unique<AnnoContextLexerStaticData>(
    std::vector<std::string>{
      "T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
      "T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "NonzeroDigit", 
      "Digit", "INTEGER", "IDENT"
    },
    std::vector<std::string>{
      "DEFAULT_TOKEN_CHANNEL", "HIDDEN"
    },
    std::vector<std::string>{
      "DEFAULT_MODE"
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
  	4,0,18,184,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
  	6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,14,
  	7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,1,0,1,0,1,0,1,
  	0,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
  	1,2,1,2,1,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
  	4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,5,1,5,
  	1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
  	6,1,7,1,7,1,8,1,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,10,1,10,1,10,1,10,
  	1,10,1,10,1,10,1,11,1,11,1,11,1,11,1,11,1,11,1,12,1,12,1,12,1,12,1,12,
  	1,12,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,
  	1,14,1,14,1,15,1,15,1,16,1,16,1,17,1,17,1,18,1,18,5,18,170,8,18,10,18,
  	12,18,173,9,18,1,18,3,18,176,8,18,1,19,1,19,5,19,180,8,19,10,19,12,19,
  	183,9,19,0,0,20,1,1,3,2,5,3,7,4,9,5,11,6,13,7,15,8,17,9,19,10,21,11,23,
  	12,25,13,27,14,29,15,31,16,33,0,35,0,37,17,39,18,1,0,4,1,0,49,57,1,0,
  	48,57,4,0,42,42,65,90,95,95,97,122,5,0,42,42,48,57,65,90,95,95,97,122,
  	184,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,
  	1,0,0,0,0,13,1,0,0,0,0,15,1,0,0,0,0,17,1,0,0,0,0,19,1,0,0,0,0,21,1,0,
  	0,0,0,23,1,0,0,0,0,25,1,0,0,0,0,27,1,0,0,0,0,29,1,0,0,0,0,31,1,0,0,0,
  	0,37,1,0,0,0,0,39,1,0,0,0,1,41,1,0,0,0,3,45,1,0,0,0,5,51,1,0,0,0,7,65,
  	1,0,0,0,9,79,1,0,0,0,11,95,1,0,0,0,13,105,1,0,0,0,15,115,1,0,0,0,17,117,
  	1,0,0,0,19,119,1,0,0,0,21,127,1,0,0,0,23,134,1,0,0,0,25,140,1,0,0,0,27,
  	146,1,0,0,0,29,159,1,0,0,0,31,161,1,0,0,0,33,163,1,0,0,0,35,165,1,0,0,
  	0,37,175,1,0,0,0,39,177,1,0,0,0,41,42,5,64,0,0,42,43,5,105,0,0,43,44,
  	5,100,0,0,44,2,1,0,0,0,45,46,5,64,0,0,46,47,5,116,0,0,47,48,5,101,0,0,
  	48,49,5,120,0,0,49,50,5,116,0,0,50,4,1,0,0,0,51,52,5,64,0,0,52,53,5,115,
  	0,0,53,54,5,121,0,0,54,55,5,109,0,0,55,56,5,95,0,0,56,57,5,117,0,0,57,
  	58,5,115,0,0,58,59,5,101,0,0,59,60,5,95,0,0,60,61,5,116,0,0,61,62,5,121,
  	0,0,62,63,5,112,0,0,63,64,5,101,0,0,64,6,1,0,0,0,65,66,5,64,0,0,66,67,
  	5,115,0,0,67,68,5,121,0,0,68,69,5,109,0,0,69,70,5,95,0,0,70,71,5,100,
  	0,0,71,72,5,101,0,0,72,73,5,102,0,0,73,74,5,95,0,0,74,75,5,116,0,0,75,
  	76,5,121,0,0,76,77,5,112,0,0,77,78,5,101,0,0,78,8,1,0,0,0,79,80,5,64,
  	0,0,80,81,5,115,0,0,81,82,5,121,0,0,82,83,5,109,0,0,83,84,5,95,0,0,84,
  	85,5,105,0,0,85,86,5,110,0,0,86,87,5,118,0,0,87,88,5,97,0,0,88,89,5,108,
  	0,0,89,90,5,95,0,0,90,91,5,116,0,0,91,92,5,121,0,0,92,93,5,112,0,0,93,
  	94,5,101,0,0,94,10,1,0,0,0,95,96,5,64,0,0,96,97,5,116,0,0,97,98,5,101,
  	0,0,98,99,5,114,0,0,99,100,5,109,0,0,100,101,5,95,0,0,101,102,5,110,0,
  	0,102,103,5,117,0,0,103,104,5,109,0,0,104,12,1,0,0,0,105,106,5,64,0,0,
  	106,107,5,110,0,0,107,108,5,111,0,0,108,109,5,100,0,0,109,110,5,101,0,
  	0,110,111,5,95,0,0,111,112,5,110,0,0,112,113,5,117,0,0,113,114,5,109,
  	0,0,114,14,1,0,0,0,115,116,5,40,0,0,116,16,1,0,0,0,117,118,5,41,0,0,118,
  	18,1,0,0,0,119,120,5,46,0,0,120,121,5,112,0,0,121,122,5,97,0,0,122,123,
  	5,114,0,0,123,124,5,101,0,0,124,125,5,110,0,0,125,126,5,116,0,0,126,20,
  	1,0,0,0,127,128,5,46,0,0,128,129,5,99,0,0,129,130,5,104,0,0,130,131,5,
  	105,0,0,131,132,5,108,0,0,132,133,5,100,0,0,133,22,1,0,0,0,134,135,5,
  	46,0,0,135,136,5,108,0,0,136,137,5,115,0,0,137,138,5,105,0,0,138,139,
  	5,98,0,0,139,24,1,0,0,0,140,141,5,46,0,0,141,142,5,114,0,0,142,143,5,
  	115,0,0,143,144,5,105,0,0,144,145,5,98,0,0,145,26,1,0,0,0,146,147,5,46,
  	0,0,147,148,5,112,0,0,148,149,5,97,0,0,149,150,5,114,0,0,150,151,5,101,
  	0,0,151,152,5,110,0,0,152,153,5,116,0,0,153,154,5,117,0,0,154,155,5,110,
  	0,0,155,156,5,116,0,0,156,157,5,105,0,0,157,158,5,108,0,0,158,28,1,0,
  	0,0,159,160,5,123,0,0,160,30,1,0,0,0,161,162,5,125,0,0,162,32,1,0,0,0,
  	163,164,7,0,0,0,164,34,1,0,0,0,165,166,7,1,0,0,166,36,1,0,0,0,167,171,
  	3,33,16,0,168,170,3,35,17,0,169,168,1,0,0,0,170,173,1,0,0,0,171,169,1,
  	0,0,0,171,172,1,0,0,0,172,176,1,0,0,0,173,171,1,0,0,0,174,176,5,48,0,
  	0,175,167,1,0,0,0,175,174,1,0,0,0,176,38,1,0,0,0,177,181,7,2,0,0,178,
  	180,7,3,0,0,179,178,1,0,0,0,180,183,1,0,0,0,181,179,1,0,0,0,181,182,1,
  	0,0,0,182,40,1,0,0,0,183,181,1,0,0,0,4,0,171,175,181,0
  };
  staticData->serializedATN = antlr4::atn::SerializedATNView(serializedATNSegment, sizeof(serializedATNSegment) / sizeof(serializedATNSegment[0]));

  antlr4::atn::ATNDeserializer deserializer;
  staticData->atn = deserializer.deserialize(staticData->serializedATN);

  const size_t count = staticData->atn->getNumberOfDecisions();
  staticData->decisionToDFA.reserve(count);
  for (size_t i = 0; i < count; i++) { 
    staticData->decisionToDFA.emplace_back(staticData->atn->getDecisionState(i), i);
  }
  annocontextlexerLexerStaticData = staticData.release();
}

}

AnnoContextLexer::AnnoContextLexer(CharStream *input) : Lexer(input) {
  AnnoContextLexer::initialize();
  _interpreter = new atn::LexerATNSimulator(this, *annocontextlexerLexerStaticData->atn, annocontextlexerLexerStaticData->decisionToDFA, annocontextlexerLexerStaticData->sharedContextCache);
}

AnnoContextLexer::~AnnoContextLexer() {
  delete _interpreter;
}

std::string AnnoContextLexer::getGrammarFileName() const {
  return "AnnoContext.g4";
}

const std::vector<std::string>& AnnoContextLexer::getRuleNames() const {
  return annocontextlexerLexerStaticData->ruleNames;
}

const std::vector<std::string>& AnnoContextLexer::getChannelNames() const {
  return annocontextlexerLexerStaticData->channelNames;
}

const std::vector<std::string>& AnnoContextLexer::getModeNames() const {
  return annocontextlexerLexerStaticData->modeNames;
}

const dfa::Vocabulary& AnnoContextLexer::getVocabulary() const {
  return annocontextlexerLexerStaticData->vocabulary;
}

antlr4::atn::SerializedATNView AnnoContextLexer::getSerializedATN() const {
  return annocontextlexerLexerStaticData->serializedATN;
}

const atn::ATN& AnnoContextLexer::getATN() const {
  return *annocontextlexerLexerStaticData->atn;
}




void AnnoContextLexer::initialize() {
  ::antlr4::internal::call_once(annocontextlexerLexerOnceFlag, annocontextlexerLexerInitialize);
}
