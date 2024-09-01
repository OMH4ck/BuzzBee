#include "ir.h"

#include <gsl/gsl>
#include <iostream>

#include "absl/strings/str_format.h"
#include "src/utils/libs/utils.h"

namespace ir {
// Get the string repr of this IR (including children).
std::string IR::ToSource(std::string token_sep) const {
  if (is_terminal_) return name_;
  std::string res;
  for (auto& each : children_) {
    if (res.size() && !res.ends_with(token_sep)) res += token_sep;
    res += each->ToSource(token_sep);
  }
  return res;
}

IR_PTR IR::GetLSib(size_t offset) const {
  auto parent = GetParent().lock();
  assert(parent);
  size_t this_offset = -1;
  auto& sibs = parent->GetChildren();
  for (size_t i = 0; i < sibs.size(); ++i) {
    if (sibs[i]->GetID() == this->GetID()) {
      this_offset = i;
      break;
    }
  }
  assert(this_offset >= offset);
  return sibs[this_offset - offset];
}
IR_PTR IR::GetRSib(size_t offset) const {
  auto parent = GetParent().lock();
  assert(parent);
  size_t this_offset = -1;
  auto& sibs = parent->GetChildren();
  for (size_t i = 0; i < sibs.size(); ++i) {
    if (sibs[i]->GetID() == this->GetID()) {
      this_offset = i;
      break;
    }
  }
  assert(this_offset + offset < sibs.size());
  return sibs[this_offset + offset];
}

std::string IR::ToSourceAndHighlightSubtree(uint64_t subtree_id,
                                            std::string token_sep) const {
  if (is_terminal_) return name_;
  std::string res;
  for (auto& each : children_) {
    if (res.size() && !res.ends_with(token_sep)) res += token_sep;
    if (subtree_id == each->GetID()) {
      res += ">>>";
    }
    res += each->ToSourceAndHighlightSubtree(subtree_id, token_sep);

    if (subtree_id == each->GetID()) {
      res += "<<<";
    }
  }
  return res;
}

std::string IR::ToSourceAndHighlightPositionInRoot(
    std::string token_sep) const {
  auto parent = GetParent().lock();
  if (parent == nullptr) {
    return ">>>" + ToSource(token_sep) + "<<<";
  }

  while (true) {
    auto tmp = parent->GetParent().lock();
    if (tmp != nullptr) {
      parent = tmp;
    } else {
      break;
    }
  }

  // now parent is the root
  return parent->ToSourceAndHighlightSubtree(GetID(), token_sep);
}

std::string IR::ToDotTreeString() const {
  return "graph {\n" + ToDotTreeStringInner() + "}\n";
}

std::string IR::ToDotTreeStringInner() const {
  std::string res;
  for (auto& each : children_) {
    res += each->ToDotTreeStringInner();
  }

  res += absl::StrFormat("ir%d ", id_);

  std::string edges;

  res += absl::StrFormat(
      "[label=\"id:%llu,ir_type:%llu\\n"
      "is_terminal:%d"
      "\\nname:%s,children:",
      id_, ir_type_, is_terminal_, GetNameEscaped());

  for (auto& each : children_) {
    res += std::to_string(each->GetID()) + ",";
    edges += absl::StrFormat("ir%d -- ir%d\n", id_, each->GetID());
  }
  res += "\"]";

  return res + "\n" + edges;
}

std::weak_ptr<IR> IR::GetParent() const { return parent_; }

std::string IR::ToLinearString() const {
  std::string res;

  for (auto& each : children_) {
    res += each->ToLinearString();
  }

  res += absl::StrFormat(
      "id:%llu,ir_type:%llu"
      ",is_terminal:%d"
      ",annotation:%s"
      ",name:%s,children:",
      id_, ir_type_, is_terminal_, annotation_.dump(), GetNameEscaped());

  for (auto& each : children_) {
    res += std::to_string(each->GetID()) + ",";
  }
  return res + "\n";
}

const std::string IR::GetNameEscaped() const {
  return utils::GetPrintableRepr(name_);
}

// `condition_func`'s return value decides whether to walk into the subtree
void IRWalker::ConditionalWalk(IR_PTR root_ir, IRListener_PTR listener,
                               std::function<bool(ir::IR_PTR)> condition_func) {
  if (!root_ir) return;
  listener->EnterIR(root_ir);

  if (condition_func(root_ir)) {
    for (auto& child : root_ir->GetChildren()) {
      ConditionalWalk(child, listener, condition_func);
    }
  }
  listener->ExitIR(root_ir);
}

void IRWalker::Walk(IR_PTR root_ir, IRListener_PTR listener) {
  Expects(root_ir);
  listener->SetIDIR(root_ir->GetID(), root_ir);
  listener->EnterIR(root_ir);
  listener->SetCurrentMaxID(root_ir->GetID());
  for (auto& child : root_ir->GetChildren()) {
    Walk(child, listener);
  }
  listener->ExitIR(root_ir);
  root_ir->SetMaxIDInTheTree(listener->GetCurrentMaxID());
}

void IR::SetAnnotationFromString(std::string annotation) {
  try {
    this->annotation_ = nlohmann::json::parse(annotation);
  } catch (nlohmann::json::parse_error& e) {
    std::cerr << e.what() << std::endl;
    assert(false && "Annotation json format error");
  }
}

IR_PTR IR::Clone() const {
  ir::IR_PTR res = NewIR();
  res->is_terminal_ = is_terminal_;
  res->ir_type_ = ir_type_;
  res->name_ = name_;
  res->id_ = id_;
  res->max_id_in_the_tree_ = max_id_in_the_tree_;
  res->annotation_ = annotation_;
  res->annotation_label_ = annotation_label_;
  return res;
}

// Clones the tree including all subtrees.
// The cloned tree's root's parent will remain unset.
IR_PTR IR::DeepClone() const {
  IR_PTR new_ir = Clone();
  // clone all children, fix their parent pointers.
  for (auto& each : children_) {
    ir::IR_PTR cloned_child = each->DeepClone();
    cloned_child->SetParent(new_ir);
    new_ir->children_.push_back(cloned_child);
  }
  return new_ir;
}

};  // namespace ir