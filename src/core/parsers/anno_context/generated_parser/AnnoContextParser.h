
// Generated from ./AnnoContext.g4 by ANTLR 4.11.1

#pragma once

#include "antlr4-runtime.h"

class AnnoContextParser : public antlr4::Parser {
 public:
  enum {
    T__0 = 1,
    T__1 = 2,
    T__2 = 3,
    T__3 = 4,
    T__4 = 5,
    T__5 = 6,
    T__6 = 7,
    T__7 = 8,
    T__8 = 9,
    T__9 = 10,
    T__10 = 11,
    T__11 = 12,
    T__12 = 13,
    T__13 = 14,
    T__14 = 15,
    T__15 = 16,
    INTEGER = 17,
    IDENT = 18
  };

  enum {
    RuleNode_property = 0,
    RulePointer = 1,
    RuleTerm = 2,
    RuleContext = 3,
    RuleEntry_point = 4
  };

  explicit AnnoContextParser(antlr4::TokenStream *input);

  AnnoContextParser(antlr4::TokenStream *input,
                    const antlr4::atn::ParserATNSimulatorOptions &options);

  ~AnnoContextParser() override;

  std::string getGrammarFileName() const override;

  const antlr4::atn::ATN &getATN() const override;

  const std::vector<std::string> &getRuleNames() const override;

  const antlr4::dfa::Vocabulary &getVocabulary() const override;

  antlr4::atn::SerializedATNView getSerializedATN() const override;

  class Node_propertyContext;
  class PointerContext;
  class TermContext;
  class ContextContext;
  class Entry_pointContext;

  class Node_propertyContext : public antlr4::ParserRuleContext {
   public:
    Node_propertyContext(antlr4::ParserRuleContext *parent,
                         size_t invokingState);

    Node_propertyContext() = default;
    void copyFrom(Node_propertyContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;
  };

  class NodePropertyIDContext : public Node_propertyContext {
   public:
    NodePropertyIDContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertyNodeNumContext : public Node_propertyContext {
   public:
    NodePropertyNodeNumContext(Node_propertyContext *ctx);

    antlr4::Token *nodetype = nullptr;
    antlr4::tree::TerminalNode *IDENT();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertySymDefTypeContext : public Node_propertyContext {
   public:
    NodePropertySymDefTypeContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertyTextContext : public Node_propertyContext {
   public:
    NodePropertyTextContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertySymInvalTypeContext : public Node_propertyContext {
   public:
    NodePropertySymInvalTypeContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertySymUseTypeContext : public Node_propertyContext {
   public:
    NodePropertySymUseTypeContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class NodePropertyTermNumContext : public Node_propertyContext {
   public:
    NodePropertyTermNumContext(Node_propertyContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Node_propertyContext *node_property();

  class PointerContext : public antlr4::ParserRuleContext {
   public:
    PointerContext(antlr4::ParserRuleContext *parent, size_t invokingState);

    PointerContext() = default;
    void copyFrom(PointerContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;
  };

  class PointerParentContext : public PointerContext {
   public:
    PointerParentContext(PointerContext *ctx);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class PointerChildContext : public PointerContext {
   public:
    PointerChildContext(PointerContext *ctx);

    antlr4::Token *idx = nullptr;
    antlr4::tree::TerminalNode *INTEGER();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class PointerLSibContext : public PointerContext {
   public:
    PointerLSibContext(PointerContext *ctx);

    antlr4::Token *offset = nullptr;
    antlr4::tree::TerminalNode *INTEGER();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class PointerParentUntilContext : public PointerContext {
   public:
    PointerParentUntilContext(PointerContext *ctx);

    antlr4::Token *nodetype = nullptr;
    antlr4::tree::TerminalNode *IDENT();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class PointerRSibContext : public PointerContext {
   public:
    PointerRSibContext(PointerContext *ctx);

    antlr4::Token *offset = nullptr;
    antlr4::tree::TerminalNode *INTEGER();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  PointerContext *pointer();

  class TermContext : public antlr4::ParserRuleContext {
   public:
    TermContext(antlr4::ParserRuleContext *parent, size_t invokingState);

    TermContext() = default;
    void copyFrom(TermContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;
  };

  class DynamicContext : public TermContext {
   public:
    DynamicContext(TermContext *ctx);

    Node_propertyContext *node_property();
    std::vector<PointerContext *> pointer();
    PointerContext *pointer(size_t i);
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  class FixedContext : public TermContext {
   public:
    FixedContext(TermContext *ctx);

    antlr4::tree::TerminalNode *IDENT();
    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  TermContext *term();

  class ContextContext : public antlr4::ParserRuleContext {
   public:
    ContextContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<TermContext *> term();
    TermContext *term(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  ContextContext *context();

  class Entry_pointContext : public antlr4::ParserRuleContext {
   public:
    Entry_pointContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ContextContext *context();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Entry_pointContext *entry_point();

  // By default the static state used to implement the parser is lazily initialized during the first
  // call to the constructor. You can call this function if you wish to initialize the static state
  // ahead of time.
  static void initialize();

 private:
};
