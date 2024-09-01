#ifndef SRC_SUBTREE_COLLECTOR_H_
#define SRC_SUBTREE_COLLECTOR_H_

#include "absl/container/flat_hash_map.h"
#include "absl/container/flat_hash_set.h"
#include "ir.h"

#define MUTATION_CANDIDATE_MAP_TYPE \
  absl::flat_hash_map<uint64_t, std::vector<const char*>>

namespace subtree_collector {

std::vector<ir::IR_PTR> CollectSubtreesSafeToMutate(ir::IR_PTR tree_root);
std::vector<ir::IR_PTR> CollectTerminals(ir::IR_PTR tree_root);
std::vector<ir::IR_PTR> CollectNonTerminalsOfName(ir::IR_PTR tree_root,
                                                  std::string name);
std::vector<ir::IR_PTR> CollectNodesOfName(ir::IR_PTR tree_root,
                                           std::string name);

// To ensure this function behaves correctly, the grammar should be written in such a way that no loops exist, which would allow one `boundary` type to be nested within another `boundary` type.
std::vector<ir::IR_PTR> CollectNodesBelowBoundary(ir::IR_PTR root,
                                                  uint64_t boundary);
std::vector<ir::IR_PTR> CollectNonEmptyNodesBelowBoundary(ir::IR_PTR root,
                                                          uint64_t boundary);
std::vector<ir::IR_PTR> CollectNodesBelowAndIncludingBoundary(
    ir::IR_PTR root, uint64_t boundary);

std::vector<ir::IR_PTR> CollectNodesOfType(ir::IR_PTR tree_root,
                                           absl::flat_hash_set<uint64_t> types);
std::vector<ir::IR_PTR> CollectNodesOfType(ir::IR_PTR tree_root, uint64_t type);
std::vector<ir::IR_PTR> CollectSubtreesAsMutateSource(ir::IR_PTR tree_root);
std::vector<ir::IR_PTR> CollectSubtrees(ir::IR_PTR tree_root);

std::vector<ir::IR_PTR> CollectSubtreesContainingLabel(ir::IR_PTR root,
                                                       std::string label);

// The same as CollectSubtreesContainingLabel, but only collect nodes Below or Equal the boundary.
std::vector<ir::IR_PTR> CollectSubtreesContainingLabelBEBoundary(
    ir::IR_PTR root, std::string label, uint64_t boundary_type);

// Compared to `CollectSubtreesWithLabelInfo`, this will return RuleName->label instead of RuleName->label->option.
absl::flat_hash_map<ir::IR_PTR, absl::flat_hash_set<std::string>>
CollectSubtreesWithLabelInfoNoOptionBEBoundary(ir::IR_PTR root,
                                               uint64_t boundary);

}  // namespace subtree_collector

#endif