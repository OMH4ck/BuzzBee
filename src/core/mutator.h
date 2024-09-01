#ifndef SRC_MUTATOR_H_
#define SRC_MUTATOR_H_

#include "absl/container/flat_hash_map.h"
#include "absl/container/flat_hash_set.h"
#include "gtest/gtest_prod.h"
#include "ir.h"
#include "symbol_analysis.h"
#include "yaml-cpp/yaml.h"

namespace frontend {

inline uint64_t AsRule(uint64_t x) { return x << 2; }

inline uint64_t AsTerminal(uint64_t x) { return (x << 2) | 2; }

struct InsertableType {
  uint64_t location_type;
  uint64_t target_type;
  bool insert_before;
  std::string sep;
};

struct RemovableType {
  uint64_t target;
  absl::flat_hash_set<uint64_t> types_to_strip;
};

class Interface {
 public:
  virtual std::function<ir::IR_PTR(std::string)> GetParserFunc() = 0;

  virtual std::string GetSymInfo() = 0;

  virtual MUTATION_CANDIDATE_MAP_TYPE GetMutationCandidateMap() = 0;

  virtual std::vector<RemovableType> GetRemovableTypes() = 0;

  virtual uint64_t GetReplaceBoundaryType() = 0;

  virtual std::vector<InsertableType> GetInsertableTypes() = 0;

  virtual CUSTOM_TYPE_RESOLVER_MAP_TYPE GetCustomTypeResolverMap() = 0;

  virtual CUSTOM_ACTION_SELECTOR_MAP_TYPE GetCustomActionSelectorMap() = 0;

  virtual size_t GetNumOfRuleIRTypes() = 0;
  virtual size_t GetNumOfTerminalIRTypes() = 0;

  virtual std::string GetIRTypeNameFromGrammar(uint64_t ir_type) = 0;

  virtual std::string GetTokenSep() = 0;

  virtual absl::flat_hash_map<uint64_t, double> GetWeightMap() = 0;
};
}  // namespace frontend

namespace mutator {

constexpr uint64_t kAnyType = (uint64_t)-1;

class IRPool {
 public:
  IRPool() { bitgen_ = std::make_shared<absl::BitGen>(); };
  IRPool(std::shared_ptr<absl::BitGen> bitgen) : bitgen_(bitgen){};
  void AddIR(ir::IR_PTR ir);
  size_t GetPoolSize() const;
  ir::IR_PTR GetRandomIRFromPool();

  void SetMaxPoolSize(uint64_t size) { max_pool_size_ = size; }

  void Clear();

 private:
  std::shared_ptr<absl::BitGen> bitgen_;

  struct IRSourceUniqueHash {
    size_t operator()(const ir::IR_PTR tree) const {
      return std::hash<std::string>()(tree->ToSource());
    }
  };
  struct IRSourceUniqueComparator {
    bool operator()(const ir::IR_PTR tree1, const ir::IR_PTR tree2) const {
      return tree1->ToSource() == tree2->ToSource();
    }
  };

  absl::flat_hash_set<ir::IR_PTR, IRSourceUniqueHash, IRSourceUniqueComparator>
      pool_;
  std::vector<ir::IR_PTR> pool_vec_;  // support O(1) indexing into pool_
  uint64_t max_pool_size_ = 1000;
};

class Mutator {
 public:
  enum class MutationMode { kMode0 };

  struct CorpusCovInfo {
    absl::flat_hash_map<std::string, size_t> ir_type_count;
    absl::flat_hash_map<std::string, size_t> semantic_action_count;
    size_t total_testcases = 0;
    size_t syntax_correct_testcases = 0;
    size_t semantic_correct_testcases = 0;
  };

  Mutator() {
    bitgen_ = std::make_shared<absl::BitGen>();
    analyzer_ =
        std::make_shared<symbol_analysis::SymbolAnalyzer>(token_sep_, bitgen_);
  }

  void SetCustomActionSelectorMap(CUSTOM_ACTION_SELECTOR_MAP_TYPE map) {
    analyzer_->SetCustomActionSelectorMap(map);
    custom_action_selector_map_ = map;
  }
  void SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map) {
    analyzer_->SetCustomResolverMap(map);
    custom_resolver_map_set_ = true;
  }
  void SetMutationCandidateMap(MUTATION_CANDIDATE_MAP_TYPE map) {
    mutation_candidate_map_ = map;
  }
  bool IsCustomTypeResolverMapSet() const { return custom_resolver_map_set_; }

  // The interface for mutation.
  size_t Mutate(std::string testcase);

  void SetMutationMode(MutationMode mode);
  MutationMode GetMutationMode() const { return mode_; }

  void SaveSubtreesToPool(ir::IR_PTR ir);

  void NewAddSubtreesToPool(ir::IR_PTR ir);
  void AddSubtreesToPool(ir::IR_PTR ir);
  void GuidedMutationAddSubtreesToPool(ir::IR_PTR ir);

  size_t MutateOneOnString(
      std::string testcase,
      std::vector<ir::IR_PTR> (Mutator::*mutation_func)(ir::IR_PTR));

  std::string GetNextMutationSource();
  ir::IR_PTR GetNextMutation();
  void SetMaxMutationSourceSize(size_t size) {
    max_mutation_source_size_ = size;
  };
  void SetWeight(uint64_t ir_type, double weight);

  const std::vector<double>& GetWeights() const { return weights_; }

  void SetConfig(YAML::Node config);
  void RegisterFrontend(std::string frontend_library_filename);
  void SetFrontendInterface(std::shared_ptr<frontend::Interface> interface);
  std::shared_ptr<frontend::Interface> GetFrontendInterface() const {
    return frontend_interface_;
  }

  void RegisterFrontendParserFunction(
      std::function<ir::IR_PTR(std::string)> parser_func);

  const std::function<ir::IR_PTR(std::string)>& GetFrontendParserFunction()
      const {
    return parser_func_;
  }

  // If the parsed AST ignores certain characters (like spaces), specify a
  // token_sep so that ToSource can correctly join the tokens back together.
  void SetTokenSeparator(std::string token_sep = " ") {
    token_sep_ = token_sep;
    analyzer_->SetTokenSep(token_sep_);
  }

  std::shared_ptr<symbol_analysis::SymbolAnalyzer> GetAnalyzer() const {
    return analyzer_;
  }

  void AddRemovableTypes(std::vector<frontend::RemovableType> removable_types);
  void AddRemovableType(frontend::RemovableType removable_type);
  void AddRemovableType(uint64_t node_type,
                        absl::flat_hash_set<uint64_t> strip_node_types);

  const absl::flat_hash_map<uint64_t, absl::flat_hash_set<uint64_t>>&
  GetRemovableType() const {
    return removable_types_;
  }

  void SetAbandonSemanticIncorrect(bool flag) {
    abandon_semantic_incorrect_ = flag;
  }

  // Only replace nodes that are below `boundary`.
  void SetReplaceableTypeBoundary(uint64_t boundary);
  const uint64_t& GetReplaceableTypeBoundary() const {
    return replaceable_type_boundary_;
  }

  // A node of `target_type` can be inserted before (insert_before==true) or
  // after (insert_before==false) a node of type `location_type`.
  void AddInsertableTypes(
      std::vector<frontend::InsertableType> insertable_types);
  void AddInsertableType(frontend::InsertableType insertable_type);
  void AddInsertableType(uint64_t location_type, uint64_t target_type,
                         bool insert_before, std::string sep) {
    AddInsertableType(frontend::InsertableType{location_type, target_type,
                                               insert_before, sep});
  }
  const absl::flat_hash_map<uint64_t /*location_type*/,
                            std::vector<frontend::InsertableType>>&
  GetInsertableType() const {
    return insertable_types_;
  }

  void SetUseSemantic(bool use_semantic) { use_semantic_ = use_semantic; }

  std::vector<ir::IR_PTR> ManyMutateInsert(ir::IR_PTR root);

  void RegisterSymInfoForGuidedMutation(std::string sym_info);
  const nlohmann::json& GetSymbolInfo() const { return sym_info_; }

 private:
  FRIEND_TEST(MutatorF, TestRedisGraphSemantic);
  FRIEND_TEST(MutatorF, TestStrKeyCustomResolver);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest1);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest2);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest3);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest4);
  FRIEND_TEST(MutatorF, DeleteTest);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest3_Variant);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest3_Variant2);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest_ContextDependent);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest_ContextDependent2);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest_ContextDependent3);
  FRIEND_TEST(MutatorF, ReplaceAndFixTest_Anytype);
  FRIEND_TEST(MutatorF, FixTest1);
  FRIEND_TEST(MutatorF, StrangeBugTest);

  bool use_semantic_ = true;

  std::string log_destination_ = "/tmp";

  size_t stage_max_ = 100;

  std::shared_ptr<frontend::Interface> frontend_interface_;

  absl::flat_hash_map<uint64_t, absl::flat_hash_set<uint64_t>>
      removable_types_;  // types to remove -> trailing node types to strip (if
                         // any)

  MUTATION_CANDIDATE_MAP_TYPE mutation_candidate_map_;

  CUSTOM_ACTION_SELECTOR_MAP_TYPE custom_action_selector_map_;
  bool custom_resolver_map_set_ = false;
  uint64_t replaceable_type_boundary_ = UINT64_MAX;

  absl::flat_hash_map<uint64_t /*location_type*/,
                      std::vector<frontend::InsertableType>>
      insertable_types_;

  struct ClassifiedTypeIRInfo {
    absl::flat_hash_map<uint64_t, std::vector<ir::IR_PTR>> type_ir_map;
    std::vector<uint64_t> types_with_unset_probability;
  };

  ir::IR_PTR RandomlyChooseIRToReplaceWithFromPool(ir::IR_PTR ir,
                                                   size_t size_limit);
  Mutator::ClassifiedTypeIRInfo ClassifySubIRs(ir::IR_PTR root) const;
  ir::IR_PTR ReplaceSubtreeWithAnother(ir::IR_PTR root, ir::IR_PTR subtree,
                                       ir::IR_PTR another) const;

  ir::IR_PTR ReplaceSubtreeWithAnotherByString(ir::IR_PTR root,
                                               ir::IR_PTR subtree,
                                               const char* another_str) const;

  ir::IR_PTR FixUnresolvedErrors(ir::IR_PTR replaced_new_root);

  void InsertIRToPool(ir::IR_PTR ir);

  ir::IR_PTR DeleteNodeFromIR(ir::IR_PTR root, ir::IR_PTR chosen_node);

  std::vector<ir::IR_PTR> GuidedMutate(ir::IR_PTR root);

  std::vector<ir::IR_PTR> GuidedMutateReplaceMany(
      ir::IR_PTR root, size_t max_mutations_per_node);

  std::vector<ir::IR_PTR> GuidedMutateInsertMany(ir::IR_PTR root,
                                                 size_t max_mutations_per_node);

  std::vector<ir::IR_PTR> GuidedMutateDeleteMany(ir::IR_PTR root,
                                                 size_t max_mutations_per_node);

  std::vector<ir::IR_PTR> GuidedMutateReplace(ir::IR_PTR root,
                                              size_t max_num_of_mutations);

  ir::IR_PTR GetRandomIRByTypeFromPool(uint64_t ir_type);

  struct IRSourceUniqueHash {
    size_t operator()(const ir::IR_PTR tree) const {
      return std::hash<std::string>()(tree->ToSource());
    }
  };
  struct IRSourceUniqueComparator {
    bool operator()(const ir::IR_PTR tree1, const ir::IR_PTR tree2) const {
      return tree1->ToSource() == tree2->ToSource();
    }
  };

  absl::flat_hash_set<ir::IR_PTR, IRSourceUniqueHash, IRSourceUniqueComparator>
      stage_results_;
  absl::flat_hash_set<ir::IR_PTR, IRSourceUniqueHash,
                      IRSourceUniqueComparator>::iterator stage_results_iter_;

  absl::flat_hash_map<uint64_t, std::vector<ir::IR_PTR>>
      tree_pool_idx_map_;  // support O(1) indexing into tree_pool_
  absl::flat_hash_map<uint64_t,
                      absl::flat_hash_set<ir::IR_PTR, IRSourceUniqueHash,
                                          IRSourceUniqueComparator>>
      tree_pool_;  // ir_type -> pool

  MutationMode mode_ = MutationMode::kMode0;
  std::shared_ptr<absl::BitGen> bitgen_;
  size_t max_mutation_source_size_ = 1000;
  std::string token_sep_ = " ";

  absl::flat_hash_set<uint64_t /* ir_type */>
      irtype_with_weight_set_;  // avoids dup and supports kAnyType
  std::vector<uint64_t> irtype_with_weight_set_vec_;  // idx -> irtype mapping
  std::vector<double> weights_;
  std::discrete_distribution<size_t> dist_;
  std::function<ir::IR_PTR(std::string)> parser_func_ =
      nullptr;  // The function should parse the testcase into an IR and return
                // nullptr upon error.

  bool abandon_semantic_incorrect_ =
      true;  // when use_semantic_ is true, abandon testcases that are unable to fix
  uint64_t ident_ir_type_;

  absl::flat_hash_map<uint64_t /*node_type*/,
                      absl::flat_hash_map<std::string /* label */, IRPool>>
      guided_mutation_pool_;

  nlohmann::json sym_info_;

  std::shared_ptr<symbol_analysis::SymbolAnalyzer> analyzer_;
};

class MutatorBuilder {
 public:
  MutatorBuilder() = default;
  void Reset() { mutator_ = Mutator(); }
  void SetMutationMode(Mutator::MutationMode mode);

  void SetFrontendInterface(std::shared_ptr<frontend::Interface> interface);

  void SetParserFunc(std::function<ir::IR_PTR(std::string)> parser_func);
  void SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map);
  void SetReplaceableTypeBoundary(uint64_t boundary);
  void AddInsertableType(uint64_t location_type, uint64_t target_type,
                         bool insert_before, std::string sep);
  void AddRemovableType(uint64_t node_type,
                        absl::flat_hash_set<uint64_t> strip_node_types);
  void SetSymInfoForGuidedMutation(std::string sym_info);
  void SetWeight(uint64_t ir_type, double weight);

  Mutator Build();

 private:
  Mutator mutator_;
};

}  // namespace mutator

#endif  // SRC_MUTATOR_H_