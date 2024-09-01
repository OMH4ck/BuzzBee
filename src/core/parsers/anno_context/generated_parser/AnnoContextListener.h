
// Generated from ./AnnoContext.g4 by ANTLR 4.11.1

#pragma once

#include "AnnoContextParser.h"
#include "antlr4-runtime.h"

/**
 * This interface defines an abstract listener for a parse tree produced by AnnoContextParser.
 */
class AnnoContextListener : public antlr4::tree::ParseTreeListener {
 public:
  virtual void enterNodePropertyID(
      AnnoContextParser::NodePropertyIDContext *ctx) = 0;
  virtual void exitNodePropertyID(
      AnnoContextParser::NodePropertyIDContext *ctx) = 0;

  virtual void enterNodePropertyText(
      AnnoContextParser::NodePropertyTextContext *ctx) = 0;
  virtual void exitNodePropertyText(
      AnnoContextParser::NodePropertyTextContext *ctx) = 0;

  virtual void enterNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext *ctx) = 0;
  virtual void exitNodePropertySymUseType(
      AnnoContextParser::NodePropertySymUseTypeContext *ctx) = 0;

  virtual void enterNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext *ctx) = 0;
  virtual void exitNodePropertySymDefType(
      AnnoContextParser::NodePropertySymDefTypeContext *ctx) = 0;

  virtual void enterNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext *ctx) = 0;
  virtual void exitNodePropertySymInvalType(
      AnnoContextParser::NodePropertySymInvalTypeContext *ctx) = 0;

  virtual void enterNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext *ctx) = 0;
  virtual void exitNodePropertyTermNum(
      AnnoContextParser::NodePropertyTermNumContext *ctx) = 0;

  virtual void enterNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext *ctx) = 0;
  virtual void exitNodePropertyNodeNum(
      AnnoContextParser::NodePropertyNodeNumContext *ctx) = 0;

  virtual void enterPointerParent(
      AnnoContextParser::PointerParentContext *ctx) = 0;
  virtual void exitPointerParent(
      AnnoContextParser::PointerParentContext *ctx) = 0;

  virtual void enterPointerChild(
      AnnoContextParser::PointerChildContext *ctx) = 0;
  virtual void exitPointerChild(
      AnnoContextParser::PointerChildContext *ctx) = 0;

  virtual void enterPointerLSib(AnnoContextParser::PointerLSibContext *ctx) = 0;
  virtual void exitPointerLSib(AnnoContextParser::PointerLSibContext *ctx) = 0;

  virtual void enterPointerRSib(AnnoContextParser::PointerRSibContext *ctx) = 0;
  virtual void exitPointerRSib(AnnoContextParser::PointerRSibContext *ctx) = 0;

  virtual void enterPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext *ctx) = 0;
  virtual void exitPointerParentUntil(
      AnnoContextParser::PointerParentUntilContext *ctx) = 0;

  virtual void enterDynamic(AnnoContextParser::DynamicContext *ctx) = 0;
  virtual void exitDynamic(AnnoContextParser::DynamicContext *ctx) = 0;

  virtual void enterFixed(AnnoContextParser::FixedContext *ctx) = 0;
  virtual void exitFixed(AnnoContextParser::FixedContext *ctx) = 0;

  virtual void enterContext(AnnoContextParser::ContextContext *ctx) = 0;
  virtual void exitContext(AnnoContextParser::ContextContext *ctx) = 0;

  virtual void enterEntry_point(AnnoContextParser::Entry_pointContext *ctx) = 0;
  virtual void exitEntry_point(AnnoContextParser::Entry_pointContext *ctx) = 0;
};
