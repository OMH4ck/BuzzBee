
// Generated from ./AnnoContext.g4 by ANTLR 4.11.1

#pragma once

#include "AnnoContextListener.h"
#include "antlr4-runtime.h"

/**
 * This class provides an empty implementation of AnnoContextListener,
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
class AnnoContextBaseListener : public AnnoContextListener {
 public:
  virtual void enterNodePropertyID(
      AnnoContextParser::NodePropertyIDContext* /*ctx*/) override {}
  virtual void exitNodePropertyID(
      AnnoContextParser::NodePropertyIDContext* /*ctx*/) override {}

  virtual void enterNodePropertyText(
      AnnoContextParser::NodePropertyTextContext* /*ctx*/) override {}
  virtual void exitNodePropertyText(
      AnnoContextParser::NodePropertyTextContext* /*ctx*/) override {}

  virtual void enterNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext* /*ctx*/) override {}
  virtual void exitNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext* /*ctx*/) override {}

  virtual void enterNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext* /*ctx*/) override {}
  virtual void exitNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext* /*ctx*/) override {}

  virtual void enterNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext* /*ctx*/) override {}
  virtual void exitNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext* /*ctx*/) override {}

  virtual void enterNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext* /*ctx*/) override {}
  virtual void exitNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext* /*ctx*/) override {}

  virtual void enterNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext* /*ctx*/) override {}
  virtual void exitNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext* /*ctx*/) override {}

  virtual void enterPointerParent(
      AnnoContextParser::PointerParentContext* /*ctx*/) override {}
  virtual void exitPointerParent(
      AnnoContextParser::PointerParentContext* /*ctx*/) override {}

  virtual void enterPointerChild(
      AnnoContextParser::PointerChildContext* /*ctx*/) override {}
  virtual void exitPointerChild(
      AnnoContextParser::PointerChildContext* /*ctx*/) override {}

  virtual void enterPointerLSib(
      AnnoContextParser::PointerLSibContext* /*ctx*/) override {}
  virtual void exitPointerLSib(
      AnnoContextParser::PointerLSibContext* /*ctx*/) override {}

  virtual void enterPointerRSib(
      AnnoContextParser::PointerRSibContext* /*ctx*/) override {}
  virtual void exitPointerRSib(
      AnnoContextParser::PointerRSibContext* /*ctx*/) override {}

  virtual void enterPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext* /*ctx*/) override {}
  virtual void exitPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext* /*ctx*/) override {}

  virtual void enterDynamic(
      AnnoContextParser::DynamicContext* /*ctx*/) override {}
  virtual void exitDynamic(
      AnnoContextParser::DynamicContext* /*ctx*/) override {}

  virtual void enterFixed(AnnoContextParser::FixedContext* /*ctx*/) override {}
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
};
