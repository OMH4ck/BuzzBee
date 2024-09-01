#include "mutator.h"

#include <sys/stat.h>

#include <algorithm>
#include <gsl/gsl>
#include <queue>

#include "absl/strings/str_format.h"
#include "absl/strings/str_join.h"
#include "anno_context.h"
#include "dlfcn.h"
#include "src/utils/libs/utils.h"
#include "subtree_collector.h"
#include "symbol_analysis.h"

namespace mutator {
std::string Mutator::GetNextMutationSource() {
  std::string res = GetNextMutation()->ToSource(token_sep_);

  return res;
}

void Mutator::RegisterFrontend(std::string frontend_library_filename) {
  dlerror();  // clear existing errors
  void *handle =
      dlopen(frontend_library_filename.c_str(), RTLD_LAZY | RTLD_GLOBAL);
  if (!handle) {
    printf("Unable to dlopen %s, %s", frontend_library_filename.c_str(),
           dlerror());
    exit(1);
  }
  std::shared_ptr<frontend::Interface> *interface_ptr =
      (std::shared_ptr<frontend::Interface> *)dlsym(handle, "interface");
  if (!interface_ptr) {
    printf("Unable to find the interface symbol in %s",
           frontend_library_filename.c_str());
    exit(1);
  }
  SetFrontendInterface(*interface_ptr);
}

size_t Mutator::Mutate(std::string testcase) {
  size_t stage_size = 0;
  switch (mode_) {
    case MutationMode::kMode0:
      stage_size = MutateOneOnString(testcase, &Mutator::GuidedMutate);
      break;
    default:
      MYLOG(FATAL, "Unknown mutation mode");
  }
  return stage_size;
}

void Mutator::SaveSubtreesToPool(ir::IR_PTR ir) {
  GuidedMutationAddSubtreesToPool(ir);
  NewAddSubtreesToPool(ir);
}

void Mutator::SetMutationMode(MutationMode mode) { mode_ = mode; }

void Mutator::SetConfig(YAML::Node config) {
  assert(config["FRONTEND_PATH"].IsDefined() && "FRONTEND_PATH not defined");

  std::string so_path = config["FRONTEND_PATH"].as<std::string>();
  RegisterFrontend(so_path);

  assert(config["USE_SEMANTIC"].IsDefined() && "USE_SEMANTIC not defined");

  SetUseSemantic(config["USE_SEMANTIC"].as<bool>());

  assert(config["DROP_SEMANTIC_INVALID"].IsDefined() &&
         "DROP_SEMANTIC_INVALID should be defined");

  SetAbandonSemanticIncorrect(config["DROP_SEMANTIC_INVALID"].as<bool>());

  SetMutationMode(MutationMode::kMode0);

  assert(config["MUTATOR_INIT_CORPUS"].IsDefined());

  std::string corpus_dir = config["MUTATOR_INIT_CORPUS"].as<std::string>();

  // load corpus
  for (const auto &dir_entry :
       std::filesystem::recursive_directory_iterator(corpus_dir)) {
    if (dir_entry.is_regular_file()) {
      std::string filename = dir_entry.path().string();
      std::ifstream ifs(filename);
      std::string testcase((std::istreambuf_iterator<char>(ifs)),
                           (std::istreambuf_iterator<char>()));
      ir::IR_PTR ir = parser_func_(testcase);
      if (ir) {
        SaveSubtreesToPool(ir);
      } else {
        MYLOG(INFO,
              "Syntax error when parsing this file in the corpus: " << filename)
      }
    }
  }
}

void Mutator::SetFrontendInterface(
    std::shared_ptr<frontend::Interface> interface) {
  frontend_interface_ = interface;

  parser_func_ = interface->GetParserFunc();
  AddInsertableTypes(interface->GetInsertableTypes());
  AddRemovableTypes(interface->GetRemovableTypes());
  SetReplaceableTypeBoundary(interface->GetReplaceBoundaryType());
  SetCustomResolverMap(interface->GetCustomTypeResolverMap());
  SetCustomActionSelectorMap(interface->GetCustomActionSelectorMap());
  RegisterSymInfoForGuidedMutation(interface->GetSymInfo());
  SetTokenSeparator(interface->GetTokenSep());
  SetMutationCandidateMap(interface->GetMutationCandidateMap());
}

void Mutator::RegisterFrontendParserFunction(
    std::function<ir::IR_PTR(std::string)> parser_func) {
  parser_func_ = parser_func;
}

ir::IR_PTR Mutator::GetNextMutation() {
  Expects(stage_results_iter_ != stage_results_.end());
  ir::IR_PTR res = *stage_results_iter_;
  stage_results_iter_ = std::next(stage_results_iter_);
  return res;
}

void Mutator::NewAddSubtreesToPool(ir::IR_PTR root) {
  std::vector<ir::IR_PTR> subtrees =
      subtree_collector::CollectNodesBelowAndIncludingBoundary(
          root, replaceable_type_boundary_);

  for (ir::IR_PTR &each : subtrees) {
    InsertIRToPool(each);
  }
}

void Mutator::GuidedMutationAddSubtreesToPool(ir::IR_PTR ir) {
  auto subtrees =
      subtree_collector::CollectSubtreesWithLabelInfoNoOptionBEBoundary(
          ir, replaceable_type_boundary_);

  for (auto &[ir, labels] : subtrees) {
    for (auto &label : labels) {
      guided_mutation_pool_[ir->GetIRType()][label].AddIR(ir);
    }
  }
}

void Mutator::AddSubtreesToPool(ir::IR_PTR root) {
  std::vector<ir::IR_PTR> subtrees =
      subtree_collector::CollectSubtreesAsMutateSource(root);

  for (ir::IR_PTR &each : subtrees) {
    InsertIRToPool(each);
  }
}

void IRPool::AddIR(ir::IR_PTR ir) {
  if (pool_.contains(ir)) {
    return;
  }
  if (pool_vec_.size() >= max_pool_size_) {
    size_t idx_to_swap = absl::Uniform<size_t>(*bitgen_, 0, max_pool_size_);
    ir::IR_PTR removed = pool_vec_[idx_to_swap];
    pool_vec_[idx_to_swap] = ir;
    pool_.erase(removed);
    pool_.insert(ir);
  } else {
    pool_.insert(ir);
    pool_vec_.push_back(ir);
  }
}

size_t IRPool::GetPoolSize() const { return pool_.size(); }

ir::IR_PTR IRPool::GetRandomIRFromPool() {
  return utils::RandomChoice(pool_vec_, bitgen_);
}

void IRPool::Clear() {
  pool_.clear();
  pool_vec_.clear();
}

void Mutator::InsertIRToPool(ir::IR_PTR ir) {
  if (tree_pool_.contains(ir->GetIRType()) &&
      tree_pool_.at(ir->GetIRType()).contains(ir)) {
    return;
  }

  constexpr size_t max_num_per_type = 1000;

  if (tree_pool_idx_map_[ir->GetIRType()].size() >= max_num_per_type) {
    MYLOG(INFO, "hit pool limit")
    size_t idx_to_swap = absl::Uniform<size_t>(*bitgen_, 0, max_num_per_type);
    ir::IR_PTR removed = tree_pool_idx_map_[ir->GetIRType()][idx_to_swap];
    tree_pool_idx_map_[ir->GetIRType()][idx_to_swap] = ir;
    tree_pool_[ir->GetIRType()].erase(removed);
    tree_pool_[ir->GetIRType()].insert(ir);
  } else {
    tree_pool_idx_map_[ir->GetIRType()].push_back(ir);
    tree_pool_[ir->GetIRType()].insert(ir);
  }
}

void Mutator::RegisterSymInfoForGuidedMutation(std::string sym_info) {
  sym_info_ = nlohmann::json::parse(sym_info);
}

std::string ToHex(std::string str) {
  std::string res;
  for (auto &each : str) {
    res += absl::StrFormat("%02x", each);
  }
  return res;
}

size_t Mutator::MutateOneOnString(
    std::string testcase,
    std::vector<ir::IR_PTR> (Mutator::*mutation_func)(ir::IR_PTR)) {
  Expects(parser_func_);
  stage_results_.clear();

  ir::IR_PTR ir = parser_func_(testcase);
  if (!ir) {
    MYLOG(INFO, "Syntax error when parsing the following testcase:\n"
                    << testcase)
    return 0;
  }

  std::vector<ir::IR_PTR> mutated_results = ((this->*(mutation_func))(ir));

  for (ir::IR_PTR &each : mutated_results) {
    if (each->ToSource(token_sep_).size() > max_mutation_source_size_) {
      continue;
    }

    if (use_semantic_) {
      auto cloned = each->DeepClone();
      ir::IR_PTR fixed = FixUnresolvedErrors(each);
      if (fixed) {
        stage_results_.insert(fixed);
      } else {
        if (!abandon_semantic_incorrect_) {
          stage_results_.insert(cloned);
        }
      }
    } else {
      stage_results_.insert(each);
    }
  }
  stage_results_iter_ = stage_results_.begin();
  return stage_results_.size();
}

// Set `ir_type = mutator::kAnyType` for anytype.
void Mutator::SetWeight(uint64_t ir_type, double weight) {
  Expects(!irtype_with_weight_set_.contains(ir_type) && "dup weight set");

  irtype_with_weight_set_.insert(ir_type);
  irtype_with_weight_set_vec_.push_back(ir_type);
  weights_.push_back(weight);
  dist_ = std::discrete_distribution<size_t>(weights_.begin(), weights_.end());
}

// Choose an IR from pool that can replace `ir`. Returns nullptr when no
// candidate can be found.
ir::IR_PTR Mutator::RandomlyChooseIRToReplaceWithFromPool(ir::IR_PTR ir,
                                                          size_t size_limit) {
  if (!tree_pool_.contains(ir->GetIRType())) return nullptr;
  constexpr size_t num_of_trials =
      10;  // There might be more efficient ways to get a legit mutation, but
           // here we just try randomly.
  std::string before = ir->ToSource(token_sep_);
  for (size_t round = 0; round < num_of_trials; ++round) {
    // search in the tree pool for replacements
    ir::IR_PTR rand_ir = GetRandomIRByTypeFromPool(ir->GetIRType());
    Ensures(rand_ir);

    std::string after = rand_ir->ToSource(token_sep_);

    if (after.size() > before.size() && after.size() > size_limit) {
      // restrict mutation size
      continue;
    }

    if (before == after) {
      continue;  // avoid duplicates
    }

    return rand_ir;
  }
  return nullptr;
}

ir::IR_PTR Mutator::GetRandomIRByTypeFromPool(uint64_t ir_type) {
  if (!tree_pool_idx_map_.contains(ir_type)) return nullptr;
  return utils::RandomChoice(tree_pool_idx_map_.at(ir_type), bitgen_);
}

ir::IR_PTR Mutator::FixUnresolvedErrors(ir::IR_PTR replaced_new_root) {
  analyzer_->Analyze(replaced_new_root);
  if (!analyzer_->FixUnresolvedErrors()) return nullptr;

  // [Limitation] If the user specifies some imprecise annotations, the fixed
  // testcase could contain syntax errors.

  // For example, the following testcase contains a use error (foo) in the copy
  // command.
  /*
    zadd myzset nx gt ch incr 2 "two" 3 "three"
    copy foo newhash1{t}
  */
  // When we annotate `foo` with NBANY, it could fetch any symbol in the current
  // context. If we fetch "three", which is defined as a symbol. Then we will
  // get:
  /*
    zadd myzset nx gt ch incr 2 "two" 3 "three"
    copy "three" newhash1{t}
  */
  // Which is a syntax error, because copy takes two IDENTs.

  // To conclude, when the user writes the annotation in a way that the
  // UseSymbol could potentially use
  //   a symbol defined by a node of an imcompatible (AST/IR) type, the semantic
  //   fix could introduce a syntax error.
  // Here, if we say the IR type A and IR type B are compatible, it means that
  // all possible texts of A conform to
  //   the syntax of B, and vice versa.

  // A better way to check this is to ignore symbols defined by imcompatible
  // node types, but we don't have a
  //   good way to get the compatibility relationship between the AST nodes yet.
  //   So the (inefficient) workaround here is to parse the whole fixed testcase
  //   again and abandon the testcase if we discover a syntax error.
  // This workaround is inefficient, therefore we should try to annotate
  // precisely (by considering the IR type compatibility.)

  std::string after_fix = replaced_new_root->ToSource(token_sep_);

  ir::IR_PTR tmp_ir = parser_func_(after_fix);
  if (!tmp_ir) {
    // the semantic fix introduced a syntax error
    MYLOG(INFO,
          "Semantic fix introduced a syntax error, the testcase will be "
          "ignored, please check your annotation.")
    MYLOG(INFO, "Test containing an error after fix:")
    MYLOG(INFO, after_fix)
    return nullptr;
  }

  return replaced_new_root;
}

// Replaces the subtree `subtree` of tree `root` with `another` and returns the
// replaced tree's root. The original tree is not modified after this operation.
ir::IR_PTR Mutator::ReplaceSubtreeWithAnother(ir::IR_PTR root,
                                              ir::IR_PTR subtree,
                                              ir::IR_PTR another) const {
  ir::IR_PTR new_root = nullptr;
  if (subtree == root) {
    new_root = another->DeepClone();
  } else {
    ir::IR_PTR parent = subtree->GetParent().lock();
    // modify the tree, then clone it, the revert the tree back
    for (ir::IR_PTR &each : parent->GetChildren()) {
      if (each == subtree) {
        // 1. Locate parent->child pointer and change it
        each = another;
        // 2. Clone it
        new_root = root->DeepClone();
        // 3. Revert
        each = subtree;
        break;
      }
    }
  }
  // Reparse the replaced tree so that the annotations could be correctly reset.
  // Note that if after the replace, a syntax error is introduced somehow, it will return nullptr.
  return parser_func_(new_root->ToSource(token_sep_));
}

ir::IR_PTR Mutator::ReplaceSubtreeWithAnotherByString(
    ir::IR_PTR root, ir::IR_PTR subtree, const char *another_str) const {
  ir::IR_PTR fake_subtree = subtree->Clone();
  fake_subtree->GetChildren().clear();
  fake_subtree->SetName(another_str);
  fake_subtree->SetIsTerminal(true);
  return ReplaceSubtreeWithAnother(root, subtree, fake_subtree);
}

Mutator::ClassifiedTypeIRInfo Mutator::ClassifySubIRs(ir::IR_PTR root) const {
  std::vector<ir::IR_PTR> subtrees = subtree_collector::CollectSubtrees(root);
  ClassifiedTypeIRInfo result;
  for (ir::IR_PTR &subtree : subtrees) {
    uint64_t subtree_type = subtree->GetIRType();
    result.type_ir_map[subtree->GetIRType()].push_back(subtree);
    if (!this->irtype_with_weight_set_.contains(subtree_type)) {
      result.types_with_unset_probability.push_back(subtree_type);
    }
  }
  return result;
}

void Mutator::AddInsertableTypes(
    std::vector<frontend::InsertableType> insertable_types) {
  for (auto &each : insertable_types) {
    AddInsertableType(each);
  }
}

void Mutator::AddInsertableType(frontend::InsertableType insertable_type) {
  insertable_types_[insertable_type.location_type].push_back(insertable_type);
}

void Mutator::AddRemovableTypes(
    std::vector<frontend::RemovableType> removable_types) {
  for (auto &each : removable_types) {
    AddRemovableType(each);
  }
}

void Mutator::AddRemovableType(frontend::RemovableType removable_type) {
  AddRemovableType(removable_type.target, removable_type.types_to_strip);
}

void Mutator::AddRemovableType(uint64_t node_type,
                               absl::flat_hash_set<uint64_t> strip_node_types) {
  removable_types_[node_type] = strip_node_types;
}

void Mutator::SetReplaceableTypeBoundary(uint64_t boundary) {
  replaceable_type_boundary_ = boundary;
}

std::string GetSourceAndInsert(ir::IR_PTR root, ir::IR_PTR location,
                               ir::IR_PTR target, bool insert_before,
                               std::string insert_sep, std::string token_sep) {
  if (root->IsTerminal()) return root->GetName();
  std::string res;
  for (auto &each : root->GetChildren()) {
    if (each->GetID() == location->GetID()) {
      if (insert_before) {
        if (res.size() && !res.ends_with(token_sep)) res += token_sep;
        res += target->ToSource(token_sep);
        if (res.size() && !res.ends_with(insert_sep)) res += insert_sep;
        res += GetSourceAndInsert(each, location, target, insert_before,
                                  insert_sep, token_sep);
      } else {
        // insert after
        if (res.size() && !res.ends_with(token_sep)) res += token_sep;
        res += GetSourceAndInsert(each, location, target, insert_before,
                                  insert_sep, token_sep);
        if (res.size() && !res.ends_with(insert_sep)) res += insert_sep;
        res += target->ToSource(token_sep);
      }
    } else {
      if (res.size() && !res.ends_with(token_sep)) res += token_sep;
      res += GetSourceAndInsert(each, location, target, insert_before,
                                insert_sep, token_sep);
    }
  }
  return res;
}

std::vector<ir::IR_PTR> Mutator::ManyMutateInsert(ir::IR_PTR root) {
  std::vector<ir::IR_PTR> ret;

  // Get all the locations available for insertion
  std::vector<ir::IR_PTR> available_locations;
  for (auto &[loc, type_info] : insertable_types_) {
    auto nodes = subtree_collector::CollectNodesOfType(root, loc);
    available_locations.insert(available_locations.end(), nodes.begin(),
                               nodes.end());
  }

  if (available_locations.empty()) {
    // unable to find a location for insertion
    return {};
  }

  for (auto &chosen_location : available_locations) {
    ir::IR_PTR target = nullptr;
    frontend::InsertableType target_type_info;

    constexpr size_t num_of_trials = 10;
    for (size_t round = 0; round < num_of_trials; ++round) {
      target_type_info = utils::RandomChoice(
          insertable_types_[chosen_location->GetIRType()], bitgen_);

      target = GetRandomIRByTypeFromPool(target_type_info.target_type);
      if (!target) {
        continue;
      }
      break;
    }

    if (!target) continue;

    std::string new_testcase = GetSourceAndInsert(
        root, chosen_location, target, target_type_info.insert_before,
        target_type_info.sep, token_sep_);
    ir::IR_PTR res = parser_func_(new_testcase);
    if (res) {
      MYLOG(INFO, "Insert success, new IR:\n" << res->ToSource(token_sep_))
      ret.push_back(res);
    }
  }

  return ret;
}

ir::IR_PTR Mutator::DeleteNodeFromIR(ir::IR_PTR root, ir::IR_PTR chosen_node) {
  // returns a clone of root with chosen_node deleted
  auto &parent_children = chosen_node->GetParent().lock()->GetChildren();
  ir::IR_PTR res = nullptr;
  auto iter =
      std::find(parent_children.begin(), parent_children.end(), chosen_node);
  if (iter != parent_children.end()) {
    std::vector<ir::IR_PTR> removed;
    removed.push_back(*iter);
    iter = parent_children.erase(iter);

    while (iter != parent_children.end() &&
           removable_types_[chosen_node->GetIRType()].contains(
               (*iter)->GetIRType())) {
      removed.push_back(*iter);
      iter = parent_children.erase(iter);
    }
    res = root->DeepClone();
    for (auto each = removed.rbegin(); each != removed.rend(); ++each) {
      iter = parent_children.insert(iter, *each);
    }
  }
  if (res) {
    res = this->parser_func_(root->ToSource(token_sep_));
    if (!res) {
      MYLOG(INFO, "parsing error after DeleteNodeFromIR")
      return nullptr;
    }
    return res;
  } else {
    return nullptr;
  }
}

std::vector<ir::IR_PTR> Mutator::GuidedMutateReplaceMany(
    ir::IR_PTR root, size_t max_mutations_per_node) {
  std::vector<ir::IR_PTR> result;

  std::vector<ir::IR_PTR> replaceable_nodes =
      subtree_collector::CollectNonEmptyNodesBelowBoundary(
          root, replaceable_type_boundary_);

  for (auto &node_to_replace : replaceable_nodes) {
    uint64_t node_type = node_to_replace->GetIRType();
    if (!tree_pool_idx_map_.contains(node_type)) {
      continue;
    }

    auto &irs = tree_pool_idx_map_.at(node_type);

    if (use_semantic_) {
      do {
        auto symbols =
            analyzer_->GetSymbolsForUseAtIR(node_to_replace, std::nullopt);
        if (symbols.empty()) {
          break;
        }
        // randomly choose a symbol for use
        auto chosen_symbol = utils::RandomChoice(symbols, bitgen_);

        auto labels = symbol_analysis::GetSupportingLabelsForSymbolType(
            chosen_symbol->GetType(), sym_info_);

        ir::IR_PTR candidate = nullptr;

        // try to see if any IR from the pool can use this symbol
        if (guided_mutation_pool_.contains(node_to_replace->GetIRType())) {
          auto &label_irpool_map =
              guided_mutation_pool_.at(node_to_replace->GetIRType());
          for (auto &label : labels) {
            if (label_irpool_map.contains(label)) {
              auto potential_candidate =
                  label_irpool_map.at(label).GetRandomIRFromPool();
              if (potential_candidate->ToSource(token_sep_) !=
                  node_to_replace->ToSource(token_sep_)) {
                candidate = potential_candidate;
                break;
              }
            }
          }
        }

        if (candidate) {
          ir::IR_PTR new_root =
              ReplaceSubtreeWithAnother(root, node_to_replace, candidate);
          if (new_root) {
            result.push_back(new_root);
          }
        }

      } while (false);
    }

    utils::MakeRandom(irs, max_mutations_per_node, bitgen_);

    size_t n = std::min(max_mutations_per_node, irs.size());
    for (size_t idx = 0; idx < n; ++idx) {
      const ir::IR_PTR &candidate = irs[idx];
      if (candidate->ToSource(token_sep_) ==
          node_to_replace->ToSource(token_sep_)) {
        continue;
      }
      ir::IR_PTR new_root =
          ReplaceSubtreeWithAnother(root, node_to_replace, candidate);
      if (new_root) {
        result.push_back(new_root);
      }
    }
  }

  return result;
}

std::vector<ir::IR_PTR> Mutator::GuidedMutateInsertMany(
    ir::IR_PTR root, size_t max_mutations_per_node) {
  std::vector<ir::IR_PTR> result;

  if (use_semantic_) {
    // Get all the locations available for insertion
    std::vector<ir::IR_PTR> available_locations;
    for (auto &[loc, type_info] : insertable_types_) {
      auto nodes = subtree_collector::CollectNodesOfType(root, loc);
      if (nodes.size()) {
        available_locations.insert(available_locations.end(), nodes.begin(),
                                   nodes.end());
      }
    }

    if (available_locations.empty()) {
      // unable to find a location for insertion
      MYLOG(INFO, "Unable to find a location for insertion")
      return result;
    }

    for (auto &location : available_locations) {
      Ensures(insertable_types_.contains(location->GetIRType()));
      auto target_type_info = utils::RandomChoice(
          insertable_types_.at(location->GetIRType()), bitgen_);

      auto symbols = analyzer_->GetSymbolsForUseAtIR(
          location, std::nullopt, !target_type_info.insert_before);

      if (symbols.empty()) continue;

      std::vector<std::string> labels;

      // try to see if any IR from the pool can use any symbol
      for (auto &symbol : symbols) {
        auto labels_for_sym = symbol_analysis::GetSupportingLabelsForSymbolType(
            symbol->GetType(), sym_info_);

        MYLOG(INFO, "for symbol " << symbol->ToString() << " the labels are:\n"
                                  << absl::StrJoin(labels_for_sym, ","))

        if (labels_for_sym.size()) {
          labels.insert(labels.end(), labels_for_sym.begin(),
                        labels_for_sym.end());
        }
      }

      auto def_labels = symbol_analysis::GetLabelsForDefiningSymbol(sym_info_);
      if (def_labels.size()) {
        labels.insert(labels.end(), def_labels.begin(), def_labels.end());
      }

      if (labels.empty()) {
        continue;
      }

      // ignore the label options since they change based on the context
      for (auto &each : labels) {
        // Rulename->label->option  =>  Rulename->label
        each = each.substr(0, each.rfind('>') - 1);
      }

      absl::flat_hash_set<ir::IR_PTR> targets;

      if (guided_mutation_pool_.contains(target_type_info.target_type)) {
        auto &label_irpool_map =
            guided_mutation_pool_.at(target_type_info.target_type);

        // If the testcase already contains label1, we want to choose label1 with less probability.
        // Labels with more freq are assigned less weights.

        std::vector<double> label_weights(labels.size());
        auto label_freq_map = analyzer_->GetLabelFreqMap();

        for (size_t i = 0; i < labels.size(); ++i) {
          double init_w = 1;
          if (label_freq_map.contains(labels[i])) {
            init_w += label_freq_map.at(labels[i]);
          }
          label_weights[i] = 1 / init_w;
        }
        auto discrete_dist = std::discrete_distribution<size_t>(
            label_weights.begin(), label_weights.end());
        auto chosen_label = labels[discrete_dist(*bitgen_)];

        MYLOG(INFO, "Chosen random label: " << chosen_label)

        if (label_irpool_map.contains(chosen_label)) {
          ir::IR_PTR target =
              label_irpool_map.at(chosen_label).GetRandomIRFromPool();
          Expects(target);
          targets.insert(target);
          MYLOG(INFO, "Inserting one target that uses label: "
                          << chosen_label << "\n"
                          << target->ToSource(token_sep_))
        }
      }

      for (auto &target : targets) {
        std::string new_testcase = GetSourceAndInsert(
            root, location, target, target_type_info.insert_before,
            target_type_info.sep, token_sep_);
        ir::IR_PTR res = parser_func_(new_testcase);
        if (res) {
          result.push_back(res);
        }
      }
    }
  }

  auto res = ManyMutateInsert(root);

  result.insert(result.end(), res.begin(), res.end());

  return result;
}

std::vector<ir::IR_PTR> Mutator::GuidedMutateDeleteMany(
    ir::IR_PTR root, size_t max_mutations_per_node) {
  std::vector<ir::IR_PTR> result;

  std::vector<ir::IR_PTR> removable_nodes;
  for (auto &each : removable_types_) {
    std::vector<ir::IR_PTR> nodes =
        subtree_collector::CollectNodesOfType(root, each.first);
    removable_nodes.insert(removable_nodes.end(), nodes.begin(), nodes.end());
  }

  for (auto &node_to_remove : removable_nodes) {
    ir::IR_PTR new_root = DeleteNodeFromIR(root, node_to_remove);
    if (new_root) {
      result.push_back(new_root);
    }
  }

  return result;
}

std::vector<ir::IR_PTR> Mutator::GuidedMutate(ir::IR_PTR root) {
  std::vector<ir::IR_PTR> result;

  // For now, this ignores stage_max.
  constexpr size_t max_mutations_per_node = 10;

  if (use_semantic_) {
    analyzer_->Analyze(root);
  }

  // When use_semantic_ == false, this becomes a random replace mutation
  auto replace_results = GuidedMutateReplaceMany(root, max_mutations_per_node);

  std::vector<ir::IR_PTR> insert_results, delete_results;

  insert_results = GuidedMutateInsertMany(root, max_mutations_per_node);
  delete_results = GuidedMutateDeleteMany(root, max_mutations_per_node);

  result.reserve(replace_results.size() + insert_results.size() +
                 delete_results.size());
  result.insert(result.end(), replace_results.begin(), replace_results.end());
  result.insert(result.end(), insert_results.begin(), insert_results.end());
  result.insert(result.end(), delete_results.begin(), delete_results.end());

  return result;
}

void MutatorBuilder::SetMutationMode(Mutator::MutationMode mode) {
  mutator_.SetMutationMode(mode);
}

void MutatorBuilder::SetCustomResolverMap(CUSTOM_TYPE_RESOLVER_MAP_TYPE map) {
  mutator_.SetCustomResolverMap(map);
}

void MutatorBuilder::SetParserFunc(
    std::function<ir::IR_PTR(std::string)> parser_func) {
  mutator_.RegisterFrontendParserFunction(parser_func);
}

void MutatorBuilder::SetReplaceableTypeBoundary(
    size_t replaceable_type_boundary) {
  mutator_.SetReplaceableTypeBoundary(replaceable_type_boundary);
}

void MutatorBuilder::AddInsertableType(uint64_t location_type,
                                       uint64_t target_type, bool insert_before,
                                       std::string sep) {
  mutator_.AddInsertableType(
      frontend::InsertableType{location_type, target_type, insert_before, sep});
}

void MutatorBuilder::AddRemovableType(
    uint64_t node_type, absl::flat_hash_set<uint64_t> strip_node_types) {
  mutator_.AddRemovableType(node_type, strip_node_types);
}

void MutatorBuilder::SetSymInfoForGuidedMutation(std::string sym_info) {
  mutator_.RegisterSymInfoForGuidedMutation(sym_info);
}

void MutatorBuilder::SetWeight(uint64_t ir_type, double weight) {
  mutator_.SetWeight(ir_type, weight);
}

Mutator MutatorBuilder::Build() {
  assert(mutator_.GetFrontendParserFunction());

  switch (mutator_.GetMutationMode()) {
    case Mutator::MutationMode::kMode0: {
      assert(!mutator_.GetSymbolInfo().empty());
      assert(mutator_.IsCustomTypeResolverMapSet());
      assert(mutator_.GetInsertableType().size() > 0);
      assert(mutator_.GetRemovableType().size() > 0);
      assert(mutator_.GetReplaceableTypeBoundary() != UINT64_MAX);
      break;
    }

    default: {
      MYLOG(FATAL, "Unknown mutation mode")
    }
  }

  return std::move(mutator_);
}

}  // namespace mutator