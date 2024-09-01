#ifndef SRC_ANNO_CONTEXT_H_
#define SRC_ANNO_CONTEXT_H_

#include <regex>

#include "symbol_analysis.h"

namespace anno_context {

class AnnoContext;
typedef std::shared_ptr<AnnoContext> AnnoContext_PTR;

class AnnoContext {
 public:
  enum class AnnoContextType {
    kPlainText,
    kIRID,
    kIRText,
    kIRTermNum,
    kIRNodeNum,
    kIRSymUseType,
    kIRSymDefType,
    kIRSymInvalType
  };
  AnnoContext() : target_ir_(nullptr) {}
  virtual ~AnnoContext() {}
  AnnoContext(ir::IR_PTR target_ir) : target_ir_(target_ir) {}
  ir::IR_PTR GetTargetIR() const { return target_ir_; }
  static symbol_analysis::Symbol_PTR GetSymbolAssociateWithIR(
      ir::IR_PTR ir,
      symbol_analysis::SymbolTable::Marker::MarkerType association_type,
      const std::vector<symbol_analysis::Scope_PTR>& scopes);
  virtual AnnoContextType GetType() const = 0;
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const = 0;

 protected:
  ir::IR_PTR target_ir_;  // the IR that this context is bound to.
};

class AnnoContextPlainText : public AnnoContext {
 public:
  AnnoContextPlainText(std::string text) : AnnoContext(), text_(text) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kPlainText;
  }

  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override {
    return text_;
  }

 private:
  std::string text_;
};

class AnnoContextID : public AnnoContext {
 public:
  AnnoContextID(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRID;
  }

  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;
};

class AnnoContextText : public AnnoContext {
 public:
  AnnoContextText(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRText;
  }
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override {
    return target_ir_->ToSource(token_sep);
  }
};

class AnnoContextTermNum : public AnnoContext {
 public:
  AnnoContextTermNum(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRTermNum;
  }

  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;
};

class AnnoContextNodeNum : public AnnoContext {
 public:
  AnnoContextNodeNum(ir::IR_PTR target_ir, std::string node_name)
      : AnnoContext(target_ir), node_name_(node_name) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRNodeNum;
  }
  const std::string& GetNodeName() const { return node_name_; }
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;

 private:
  std::string node_name_;  // name (type) of the non-terminal nodes to count
};

class AnnoContextNodeSymUseType : public AnnoContext {
 public:
  AnnoContextNodeSymUseType(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRSymUseType;
  }
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;

 private:
};

class AnnoContextNodeSymDefType : public AnnoContext {
 public:
  AnnoContextNodeSymDefType(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRSymDefType;
  }
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;

 private:
};

class AnnoContextNodeSymInvalType : public AnnoContext {
 public:
  AnnoContextNodeSymInvalType(ir::IR_PTR target_ir) : AnnoContext(target_ir) {}
  virtual AnnoContextType GetType() const override {
    return AnnoContextType::kIRSymInvalType;
  }
  virtual std::string Evaluate(
      const std::vector<symbol_analysis::Scope_PTR>& scopes,
      std::string token_sep = " ") const override;

 private:
};

class AnnoContextSequence {
 public:
  AnnoContextSequence(std::vector<AnnoContext_PTR> context_seq)
      : context_seq_(context_seq) {}
  AnnoContextSequence() {}
  std::string Evaluate(const std::vector<symbol_analysis::Scope_PTR>& scopes,
                       std::string token_sep = " ") const {
    std::string result;
    for (auto& each : context_seq_) {
      result += each->Evaluate(scopes, token_sep);
    }
    return result;
  }

  std::vector<AnnoContext_PTR>& GetContextSequence() { return context_seq_; }

 private:
  std::vector<AnnoContext_PTR> context_seq_;
};

class AnnoContextAnalyzer {
 public:
  static AnnoContextSequence AnalyzeSequence(ir::IR_PTR ir,
                                             std::string context_str);
};

}  // namespace anno_context

#endif  // SRC_ANNO_CONTEXT_H_