#ifndef SRC_IR_H_
#define SRC_IR_H_

#include <unistd.h>

#include <fstream>
#include <memory>
#include <stack>
#include <string>
#include <vector>

#include "absl/container/flat_hash_map.h"
#include "absl/strings/str_format.h"
#include "nlohmann/json.hpp"

namespace ir {

class IR;
class IRListener;

typedef std::shared_ptr<IR> IR_PTR;
typedef std::shared_ptr<IRListener> IRListener_PTR;

class IRListener {
 public:
  IRListener(){};
  virtual ~IRListener(){};
  virtual void EnterIR(IR_PTR ir) = 0;
  virtual void ExitIR(IR_PTR ir) = 0;

  void SetCurrentMaxID(uint64_t id) { current_max_id_ = id; }
  uint64_t GetCurrentMaxID() const { return current_max_id_; }
  void SetIDIR(uint64_t id, ir::IR_PTR ir) { id_ir_map_[id] = ir; }
  ir::IR_PTR GetIDIR(uint64_t id) const {
    if (id_ir_map_.contains(id)) return id_ir_map_.at(id);
    return nullptr;
  }

 private:
  uint64_t current_max_id_ = 0;
  absl::flat_hash_map<uint64_t, ir::IR_PTR> id_ir_map_;
};

class SubtreeCollector {
 public:
  static std::vector<IR_PTR> CollectSubtrees(IR_PTR tree_root);
};

class IRWalker {
 public:
  // Walk the IR in statement order (with IR->GetID() increasing)
  static void Walk(IR_PTR root_ir, IRListener_PTR listener);
  static void ConditionalWalk(IR_PTR root_ir, IRListener_PTR listener,
                              std::function<bool(ir::IR_PTR)> condition_func);
};

class IR {
 public:
  static IR_PTR NewIR() {
    static size_t id = 0;
    return std::make_shared<IR>(id++);
  }

  ~IR() {}

  IR(uint64_t id)
      : id_(id),
        ir_type_(0),
        max_id_in_the_tree_((uint64_t)-1),
        is_terminal_(false) {}

  IR_PTR DeepClone() const;

  // Shallow clone of only the ir itself
  IR_PTR Clone() const;

  uint64_t GetID() const { return id_; }
  uint64_t GetMaxIDInTheTree() const { return max_id_in_the_tree_; }
  void SetMaxIDInTheTree(uint64_t id) { max_id_in_the_tree_ = id; }
  void SetID(uint64_t id) { id_ = id; }

  uint64_t GetIRType() const { return ir_type_; }
  void SetIRType(uint64_t ir_type) { ir_type_ = ir_type; }

  bool IsTerminal() const { return is_terminal_; }
  void SetIsTerminal(bool is_terminal) { is_terminal_ = is_terminal; }

  IR_PTR GetLSib(size_t offset) const;
  IR_PTR GetRSib(size_t offset) const;

  // Get the string repr of the this IR (not including children.)
  const std::string GetNameEscaped() const;
  const std::string& GetName() const { return name_; }
  void SetName(std::string name) { name_ = name; }

  void SetAnnotationFromString(std::string annotation);
  void SetAnnotation(nlohmann::json annotation) { annotation_ = annotation; }
  void SetAnnotationLabel(std::string label) { annotation_label_ = label; }
  std::string GetAnnotationLabel() const { return annotation_label_; }
  nlohmann::json GetAnnotation() const { return annotation_; }

  std::vector<IR_PTR>& GetChildren() { return children_; }
  std::string ToSource(std::string token_sep = " ") const;

  // This will return the string of the root while marking this ir's position.
  std::string ToSourceAndHighlightPositionInRoot(
      std::string token_sep = " ") const;

  std::string ToLinearString() const;

  std::string ToDotTreeString() const;
  std::string ToDotTreeStringInner() const;

  std::weak_ptr<IR> GetParent() const;
  void SetParent(IR_PTR parent) { parent_ = parent; }

  void SetOrderID(uint64_t oid) { order_id_ = oid; }
  uint64_t GetOrderID() { return order_id_; }

 private:
  uint64_t id_;  // In the tree, each node should have a unique ID.
  uint64_t
      order_id_;  // The order in which the node should be evaluated. Set by performing Toposort.
  uint64_t ir_type_;
  uint64_t max_id_in_the_tree_;

  bool is_terminal_;

  std::string name_;  // for terminals, this is the source; for
                      // other types, this is the rule name

  std::vector<IR_PTR> children_;
  std::weak_ptr<IR> parent_;  // avoid cyclic ref

  nlohmann::json annotation_;
  std::string annotation_label_;

  std::string ToSourceAndHighlightSubtree(uint64_t subtree_id,
                                          std::string token_sep = " ") const;
};

};  // namespace ir

#endif  // SRC_IR_H_