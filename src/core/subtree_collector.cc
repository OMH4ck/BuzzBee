#include "subtree_collector.h"

#include "src/utils/libs/utils.h"

namespace subtree_collector {

class SubtreeCollectorListenerWithFilter : public ir::IRListener {
 public:
  // `filter_func` receives an IR_PTR and should return true indicating NOT
  // including the ir. When `check_children` is true, for the tree to be included
  // in the final result, all children of the tree should not be filtered out.
  SubtreeCollectorListenerWithFilter(
      std::function<bool(ir::IR_PTR)> filter_func, bool check_children) {
    filter_func_ = filter_func;
    check_children_ = check_children;
  }
  SubtreeCollectorListenerWithFilter() = delete;
  virtual ~SubtreeCollectorListenerWithFilter() {}
  virtual void EnterIR(ir::IR_PTR ir) override {}
  virtual void ExitIR(ir::IR_PTR ir) override {
    if (!filter_func_(ir)) {
      if (check_children_) {
        // and all its children are not filtered_out
        bool ok = true;
        for (auto& each : ir->GetChildren()) {
          if (filtered_out_irs_.contains(each)) {
            ok = false;
            break;
          }
        }
        if (ok) {
          results_.push_back(ir);
          return;
        }
      } else {
        results_.push_back(ir);
        return;
      }
    }
    filtered_out_irs_.insert(ir);
  }

  // Returns all subtrees that doesn't contain filtered out subtrees
  std::vector<ir::IR_PTR> GetSubtrees() const { return results_; }

 private:
  std::vector<ir::IR_PTR> results_;
  std::function<bool(ir::IR_PTR)> filter_func_;
  absl::flat_hash_set<ir::IR_PTR> filtered_out_irs_;
  bool check_children_;
};

// Collects subtrees to mutate
std::vector<ir::IR_PTR> CollectSubtreesSafeToMutate(ir::IR_PTR tree_root) {
  auto filter = [](ir::IR_PTR ir) { return false; };
  auto walk_condition = [](ir::IR_PTR ir) { return true; };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, true);
  ir::IRWalker::ConditionalWalk(tree_root, listener, walk_condition);
  return listener->GetSubtrees();
}

// Collects terminal nodes in the subtree
std::vector<ir::IR_PTR> CollectTerminals(ir::IR_PTR tree_root) {
  auto filter = [](ir::IR_PTR ir) { return !ir->IsTerminal(); };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectSubtreesAsMutateSource(ir::IR_PTR tree_root) {
  auto filter = [](ir::IR_PTR ir) { return false; };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, true);
  auto walk_condition = [](ir::IR_PTR ir) { return true; };
  ir::IRWalker::ConditionalWalk(tree_root, listener, walk_condition);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectNonTerminalsOfName(ir::IR_PTR tree_root,
                                                  std::string name) {
  auto filter = [name](ir::IR_PTR ir) {
    return ir->IsTerminal() || (ir->GetName() != name);
  };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectNodesBelowAndIncludingBoundary(
    ir::IR_PTR root, uint64_t boundary) {
  auto filter = [boundary](ir::IR_PTR ir) {
    for (auto& child : ir->GetChildren()) {
      if (child->GetIRType() == boundary) {
        return true;  // filter out parent
      }
    }
    return false;
  };  // when type is boundary, filter it out
  auto listener = std::make_shared<SubtreeCollectorListenerWithFilter>(
      filter, true /* when any child is filtered out, filter the parent out */);
  ir::IRWalker::Walk(root, listener);
  std::vector<ir::IR_PTR> res = listener->GetSubtrees();

  return res;
}

std::vector<ir::IR_PTR> CollectNonEmptyNodesBelowBoundary(ir::IR_PTR root,
                                                          uint64_t boundary) {
  auto filter = [boundary](ir::IR_PTR ir) {
    return (ir->GetIRType() == boundary);
  };  // when type is boundary, filter it out
  auto listener = std::make_shared<SubtreeCollectorListenerWithFilter>(
      filter, true /* when any child is filtered out, filter the parent out */);
  ir::IRWalker::Walk(root, listener);
  std::vector<ir::IR_PTR> res = listener->GetSubtrees();

  std::vector<ir::IR_PTR> non_empty_res;

  /* sanity check, can be removed later */
  for (auto& each : res) {
    if (each->GetIRType() == boundary) {
      assert("Invalid");
    }
    if (each->ToSource().size()) {
      non_empty_res.push_back(each);
    }
  }
  return non_empty_res;
}

std::vector<ir::IR_PTR> CollectNodesBelowBoundary(ir::IR_PTR root,
                                                  uint64_t boundary) {
  auto filter = [boundary](ir::IR_PTR ir) {
    return (ir->GetIRType() == boundary);
  };  // when type is boundary, filter it out
  auto listener = std::make_shared<SubtreeCollectorListenerWithFilter>(
      filter, true /* when any child is filtered out, filter the parent out */);
  ir::IRWalker::Walk(root, listener);
  std::vector<ir::IR_PTR> res = listener->GetSubtrees();

  /* sanity check, can be removed later */
  for (auto& each : res) {
    if (each->GetIRType() == boundary) {
      assert("Invalid");
    }
  }
  return res;
}

std::vector<ir::IR_PTR> CollectNodesOfType(
    ir::IR_PTR tree_root, absl::flat_hash_set<uint64_t> types) {
  auto filter = [types](ir::IR_PTR ir) {
    return (!types.contains(ir->GetIRType()));
  };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectNodesOfType(ir::IR_PTR tree_root,
                                           uint64_t type) {
  auto filter = [type](ir::IR_PTR ir) { return (ir->GetIRType() != type); };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectNodesOfName(ir::IR_PTR tree_root,
                                           std::string name) {
  auto filter = [name](ir::IR_PTR ir) { return (ir->GetName() != name); };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectSubtrees(ir::IR_PTR tree_root) {
  auto filter = [](ir::IR_PTR ir) { return false; };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(tree_root, listener);
  return listener->GetSubtrees();
}

absl::flat_hash_map<ir::IR_PTR, absl::flat_hash_set<std::string>>
CollectSubtreesWithLabelInfoNoOptionBEBoundary(ir::IR_PTR root,
                                               uint64_t boundary) {
  // returns IR->vec[labels this IR contains] within the boundary
  absl::flat_hash_set<ir::IR_PTR> irs_out_of_bound;
  absl::flat_hash_map<ir::IR_PTR, absl::flat_hash_set<std::string>> result;
  auto filter = [&](ir::IR_PTR ir) {
    for (auto& each : ir->GetChildren()) {
      if (each->GetIRType() == boundary || irs_out_of_bound.contains(each)) {
        // ir is out_of_bound
        irs_out_of_bound.insert(ir);
        return true;
      }
    }
    std::string ir_label = ir->GetAnnotationLabel();
    if (ir_label.size()) {
      result[ir].insert(ir_label);
    }
    for (auto& each : ir->GetChildren()) {
      if (result.contains(each)) {
        result[ir].insert(result.at(each).begin(), result.at(each).end());
      }
    }
    return false;
  };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(root, listener);
  return result;
}

std::vector<ir::IR_PTR> CollectSubtreesContainingLabel(ir::IR_PTR root,
                                                       std::string label) {
  absl::flat_hash_set<ir::IR_PTR> irs_containing_label;
  auto filter = [&](ir::IR_PTR ir) {
    bool include = false;
    std::string ir_label = ir->GetAnnotationLabel();
    if (label == ir_label) {
      include = true;
    }
    for (auto& child : ir->GetChildren()) {
      if (irs_containing_label.contains(child)) {
        // if any child contains the label, include the parent
        include = true;
        break;
      }
    }
    if (include) {
      irs_containing_label.insert(ir);
      return false;
    } else {
      return true;
    }
  };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(root, listener);
  return listener->GetSubtrees();
}

std::vector<ir::IR_PTR> CollectSubtreesContainingLabelBEBoundary(
    ir::IR_PTR root, std::string label, uint64_t boundary_type) {
  absl::flat_hash_set<ir::IR_PTR> irs_containing_label;
  absl::flat_hash_set<ir::IR_PTR> irs_out_of_bound;

  auto filter = [&](ir::IR_PTR ir) {
    bool include = false;
    std::string ir_label = ir->GetAnnotationLabel();
    if (label == ir_label) {
      include = true;
    }
    for (auto& child : ir->GetChildren()) {
      if (irs_containing_label.contains(child)) {
        // if any child contains the label, include the parent
        include = true;
        break;
      }
    }
    for (auto& child : ir->GetChildren()) {
      if (child->GetIRType() == boundary_type ||
          irs_out_of_bound.contains(child)) {
        // means ir is out_of_bound
        include = false;
        irs_out_of_bound.insert(ir);
        break;
      }
    }

    if (include) {
      irs_containing_label.insert(ir);
      return false;
    } else {
      return true;
    }
  };
  auto listener =
      std::make_shared<SubtreeCollectorListenerWithFilter>(filter, false);
  ir::IRWalker::Walk(root, listener);
  return listener->GetSubtrees();
}

}  // namespace subtree_collector
