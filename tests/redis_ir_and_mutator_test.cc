#include "absl/container/flat_hash_set.h"
#include "gtest/gtest.h"
#include "src/core/mutator.h"
#include "src/core/subtree_collector.h"
#include "src/core/symbol_analysis.h"
#include "src/frontends/redis/redis_frontend/redis_frontend.h"

namespace mutator {
TEST(IRTest, TestRedisFrontend) {
  ir::IR_PTR root = redis_frontend::ParseSourceToIR("cf.add testa testb");
  ASSERT_TRUE(root);
}

TEST(IRTest, TestIRDeepClone) {
  ir::IR_PTR root =
      redis_frontend::ParseSourceToIR("cf.add testa testb\ncf.add test test");
  ASSERT_EQ(root->ToSource(), root->DeepClone()->ToSource());
}

TEST(IRTest, TestIRToLinearString) {
  ir::IR_PTR root =
      redis_frontend::ParseSourceToIR("cf.add testa testb\ncf.add test test");
  ASSERT_TRUE(root);
  std::cout << root->ToLinearString();
}

// Tests the basic replace and fix functionality.
TEST(MutatorF, ReplaceAndFixTest1) {
  std::string testcase =
      "zadd foo 100 bar\n"
      "zdiff 1 foo\n"
      "zdiff 2 foo\n"
      "zadd aaa 100 bbb\n"
      "zdiff 2 aaa";

  // We restrict the mutator to replace `zdiff 2 aaa` with the following testcase.
  // To preserve semantic correctness, `baba` should be fixed to use any names in [foo, aaa, othername].
  // We check if this is true in this test.
  std::string testcase2 =
      "zadd othername 100 othername2\n"
      "zdiff 2 baba\n";
  ir::IR_PTR root = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR root2 = redis_frontend::ParseSourceToIR(testcase2);
  mutator::Mutator mut;
  mut.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  std::vector<ir::IR_PTR> safe_to_mutate_irs =
      subtree_collector::CollectSubtreesSafeToMutate(root);
  std::vector<ir::IR_PTR> mutation_source =
      subtree_collector::CollectSubtreesAsMutateSource(root2);
  ir::IR_PTR replacement, to_mutate;
  // locate the `progs` that contains the two apis `zadd` and `zdiff`
  for (ir::IR_PTR &each : mutation_source) {
    if (each->GetName() == "progs") {
      auto src = each->ToSource();
      if (src.find("zadd") != std::string::npos &&
          src.find("zdiff") != std::string::npos) {
        replacement = each;
        break;
      }
    }
  }
  ASSERT_TRUE(replacement && "Unable to locate the node");

  // locate `zdiff 2 aaa`
  for (ir::IR_PTR &each : safe_to_mutate_irs) {
    if (each->GetIRType() == replacement->GetIRType()) {
      std::string src = each->ToSource();
      if (src.find("zadd") == std::string::npos) {
        to_mutate = each;
      }
    }
  }
  // try to mutate without fixing

  ir::IR_PTR new_mutation_nofix =
      mut.ReplaceSubtreeWithAnother(root, to_mutate, replacement);
  ASSERT_TRUE(new_mutation_nofix && "syntax mutation must succeed");

  symbol_analysis::SymbolAnalyzer analyzer;

  analyzer.Analyze(new_mutation_nofix);

  ASSERT_EQ(analyzer.GetNumberOfUnresolvedErrors(), 1);
  auto err = analyzer.PopOneUnresolvedErrorFromQueue();
  ASSERT_EQ(err.error_code,
            symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedUse);

  auto get_symbol_types_from_annotation_func =
      [](ir::IR_PTR ir) -> std::vector<std::string> {
    ResolveContext ctx =
        ResolveContext{std::nullopt, ir, std::nullopt, std::nullopt, nullptr};
    nlohmann::json action = symbol_analysis::GetAction(
        ctx, redis_frontend::GetCustomActionSelectorMap());
    return action["args"]["type"];
  };

  std::vector<std::string> required_symtypes =
      get_symbol_types_from_annotation_func(err.error_ir);

  auto required_symtypes_set = absl::flat_hash_set<std::string>(
      required_symtypes.begin(), required_symtypes.end());

  absl::flat_hash_set<std::string> available_syms;

  std::vector<symbol_analysis::Symbol_PTR> syms =
      analyzer.GetSymbolsForUseAtIR(err.error_ir, required_symtypes_set);
  for (auto &sym : syms) available_syms.insert(sym->GetName());

  // Test if GetSymbolsForUseInRange returns expected results
  ASSERT_EQ(available_syms,
            absl::flat_hash_set<std::string>({"foo", "aaa", "othername"}));

  // Test replace and fix
  ir::IR_PTR replaced_new_root =
      mut.ReplaceSubtreeWithAnother(root, to_mutate, replacement);
  ir::IR_PTR new_mutation = mut.FixUnresolvedErrors(replaced_new_root);

  analyzer.Reset();
  analyzer.Analyze(new_mutation);

  // Check that the mutation result is semantically correct
  ASSERT_EQ(analyzer.HasUnresolvedError(), false);
}

// This test tests the fixer's ability to fix both InvalidateSymbol and
// UseSymbol correctly.
TEST(MutatorF, ReplaceAndFixTest2) {
  std::string testcase =
      "zadd foo 100 bar\n"
      "zdiff 1 foo\n"
      "zdiff 2 foo\n"
      "zadd aaa 100 bbb\n"
      "zdiff 2 aaa";

  // In this test, we restrict the mutator to mutate `zdiff 2 aaa` with the
  // following testcase. `bbb` should be fixed with one of (foo, aaa), and
  // `baba` should be fixed with the other.
  std::string testcase2 =
      "del bbb\n"
      "zdiff 3 baba\n";
  ir::IR_PTR root = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR root2 = redis_frontend::ParseSourceToIR(testcase2);
  mutator::Mutator mut;
  mut.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  std::vector<ir::IR_PTR> safe_to_mutate_irs =
      subtree_collector::CollectSubtreesSafeToMutate(root);
  std::vector<ir::IR_PTR> mutation_source =
      subtree_collector::CollectSubtreesAsMutateSource(root2);
  ir::IR_PTR replacement, to_mutate;
  // locate the node `progs` that contains the two apis `del` and `zdiff`
  for (ir::IR_PTR &each : mutation_source) {
    if (each->GetName() == "progs") {
      std::string src = each->ToSource();
      if (src.find("del") != std::string::npos &&
          src.find("zdiff") != std::string::npos) {
        replacement = each;
        break;
      }
    }
  }
  ASSERT_TRUE(replacement && "Unable to locate the node");

  // locate `zdiff 2 aaa`
  for (ir::IR_PTR &each : safe_to_mutate_irs) {
    if (each->GetIRType() == replacement->GetIRType()) {
      std::string src = each->ToSource();
      if (src.find("zadd") == std::string::npos) {
        to_mutate = each;
      }
    }
  }
  // try to mutate without fixing, check we get two semantic errors

  ir::IR_PTR new_mutation_nofix =
      mut.ReplaceSubtreeWithAnother(root, to_mutate, replacement);
  ASSERT_TRUE(new_mutation_nofix && "syntax mutation must succeed");

  symbol_analysis::SymbolAnalyzer analyzer;

  analyzer.Analyze(new_mutation_nofix);

  ASSERT_EQ(analyzer.GetNumberOfUnresolvedErrors(), 2);

  ASSERT_EQ(analyzer.PopOneUnresolvedErrorFromQueue().error_code,
            symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedInvalidate);

  ASSERT_EQ(analyzer.PopOneUnresolvedErrorFromQueue().error_code,
            symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedUse);

  // try to mutate and fix, verify the result doesn't contain any error
  ir::IR_PTR replaced_new_root =
      mut.ReplaceSubtreeWithAnother(root, to_mutate, replacement);
  ir::IR_PTR new_mutation = mut.FixUnresolvedErrors(replaced_new_root);

  analyzer.Reset();
  analyzer.Analyze(new_mutation);
  ASSERT_EQ(analyzer.HasUnresolvedError(), false);

  MYLOG(INFO, "new mutation in ReplaceAndFixTest: \n"
                  << new_mutation->ToSource());

  std::string new_mut_src = new_mutation->ToSource();
  ASSERT_TRUE((new_mut_src.find("del foo") != std::string::npos &&
               new_mut_src.find("zdiff 3 aaa") != std::string::npos) ||
              (new_mut_src.find("del aaa") != std::string::npos &&
               new_mut_src.find("zdiff 3 foo") != std::string::npos));
}

// Test the fix of invalidation of a symbol which is used later in the program.
TEST(MutatorF, ReplaceAndFixTest3) {
  // Note that this testcase is not semantically correct by itself.
  std::string testcase =
      "psetex _int 9223372036854770000 258959916075\n"
      "set mykey 446\n"
      "del _int mykey\n"
      "get mykey";

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";
  std::string another_str = "info";

  // Mutating `subtree` to `another` will make _int unavailable in the program.
  // Therefore, the 3rd command `del _int mykey`'s first arg `_int` becomes a
  // semantic error. After fixing it to the only available symbol in the
  // program, which is `mykey`, the 2nd arg's use of `mykey` becomes another
  // semantic error, since mykey is now invalidated by the fixed first argument.
  // Thus, there is no way to perform this mutation while preserving semantic
  // correctness.
  // This test tests whether the above is true.

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (ir::IR_PTR &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  // no way to mutate while preserving semantic correctness
  ASSERT_TRUE(res == nullptr);

  /*
  * Logs extracted during test to help verify:
  * [...mutator.cc:133] Trying to fix _int
  * [...mutator.cc:170] Fixing `_int` with `mykey` (available names are `mykey`)
  * [...mutator.cc:234] [fixed]
  * [...mutator.cc:133] Trying to fix mykey
  * [...mutator.cc:238] [unable to fix]
  * [...mutator.cc:243] Unable to find available sym in range [47, 48]
  */
}

TEST(MutatorF, ReplaceAndFixTest3_Variant) {
  std::string testcase =
      "psetex _int 9223372036854770000 258959916075\n"
      "set mykey 446\n"
      "del _int mykey\n"
      "get mykey";

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";

  // The two args in `del` can now be fixed, however the final `get` is not fixable.
  std::string another_str = "set newly_defined_symbol hello";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (auto &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  // no way to mutate while preserving semantic correctness
  ASSERT_TRUE(res == nullptr);

  /*
  *  Logs extracted during test:
  *   mutator.cc:133] Trying to fix _int
  *   mutator.cc:170] Fixing `_int` with `newly_defined_symbol` (available names are `mykey,newly_defined_symbol`) 
  *   mutator.cc:234] [fixed] mutator.cc:133] Trying to fix mykey 
  *   mutator.cc:238] [unable to fix] mutator.cc:243] Unable to find available sym in range [56, 57]
  */
}

// Another variant of ReplaceAndFixTest3
TEST(MutatorF, ReplaceAndFixTest3_Variant2) {
  std::string testcase =
      "set somesymbol hello\n"
      "psetex _int 9223372036854770000 258959916075\n"
      "set mykey 446\n"
      "del _int mykey\n"
      "get mykey";

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";

  // The two args in `del` can now be fixed, and the final `get` is also
  // fixable, since we now have 3 symbols (somesymbol, newly_defined_symbol, mykey).
  std::string another_str = "set newly_defined_symbol hello";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (auto &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  ASSERT_TRUE(res);
  MYLOG(INFO, "After fix:\n" << res->ToSource());

  /*
  * Logs extracted during test:
  *  mutator.cc:133] Trying to fix _int
  *  mutator.cc:170] Fixing `_int` with `somesymbol` (available names are `somesymbol,newly_defined_symbol,mykey`) 
  *  mutator.cc:234] [fixed]
  *  mutator.cc:133] Trying to fix mykey
  *  mutator.cc:170] Fixing `mykey` with `newly_defined_symbol` (available names are `newly_defined_symbol`) 
  *  mutator.cc:234] [fixed]
  *  ir_and_mutator_test.cc:403] After fix:
  *  set somesymbol hello
  *  set newly_defined_symbol hello
  *  set mykey 446
  *  del somesymbol mykey
  *  get newly_defined_symbol
  *
  *  --------------
  *  Another type of fix:
  *
  *  mutator.cc:133] Trying to fix _int
  *  mutator.cc:170] Fixing `_int` with `mykey` (available names are `newly_defined_symbol,mykey,somesymbol`)
  *  mutator.cc:234] [fixed]
  *  mutator.cc:133] Trying to fix mykey
  *  mutator.cc:170] Fixing `mykey` with `somesymbol` (available names are `newly_defined_symbol,somesymbol`)
  *  mutator.cc:234] [fixed]
  *  mutator.cc:133] Trying to fix mykey
  *  mutator.cc:170] Fixing `mykey` with `newly_defined_symbol` (available names are `newly_defined_symbol`)
  *  mutator.cc:234] [fixed]
  *  ir_and_mutator_test.cc:402] After fix:
  *  set somesymbol hello    
  *  set newly_defined_symbol hello    
  *  set mykey 446    
  *  del mykey somesymbol 
  *  get newly_defined_symbol
  */
}

TEST(MutatorF, ReplaceAndFixTest_ContextDependent) {
  std::string testcase =
      "xadd mystream * message hello\n"
      "xgroup create mystream mygroup 0\n"
      "psetex _int 9223372036854770000 258959916075";

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";

  std::string another_str = "xgroup destroy mystream to_fix";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (auto &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  ASSERT_TRUE(res);
  MYLOG(INFO, "After fix:\n" << res->ToSource());
}

TEST(MutatorF, ReplaceAndFixTest_ContextDependent2) {
  std::string testcase =
      "xadd mystream1 * message hello\n"
      "xadd mystream2 * message hello\n"
      "xgroup create mystream1 mygroup1 0\n"
      "xgroup create mystream2 mygroup2 0\n"
      "psetex _int 9223372036854770000 258959916075\n"
      "xgroup destroy mystream1 mygroup1";  // correct

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";

  std::string another_str = "del mystream1";
  // after mut, mystream1 would be invalidated
  // after fixing mystream1 (to mystream2), mygroup1 will be made an error, which should be fixed to mygroup2

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (auto &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  ASSERT_TRUE(res);
  MYLOG(INFO, "After fix:\n" << res->ToSource());
}

TEST(MutatorF, ReplaceAndFixTest_ContextDependent3) {
  std::string testcase =
      "xadd mystream1 * message hello\n"
      "xadd mystream2 * message hello\n"
      "xgroup create mystream1 mygroup1 0\n"
      "xgroup create mystream2 mygroup2 0\n"
      "xgroup createconsumer mystream2 mygroup2 Lee\n"
      "xgroup createconsumer mystream1 mygroup1 Hua\n"
      "psetex _int 9223372036854770000 258959916075\n"
      "xgroup delconsumer mystream2 mygroup2 Lee\n"
      "xgroup destroy mystream1 mygroup1";  // correct

  std::string subtree_str = "psetex _int 9223372036854770000 258959916075";

  std::string another_str = "del mystream2";
  // after mut, mystream1 would be invalidated
  // after fixing mystream1 (to mystream2), mygroup1 will be made an error, which should be fixed to mygroup2

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (ir::IR_PTR &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (ir::IR_PTR &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  ASSERT_TRUE(res);
  MYLOG(INFO, "After fix:\n" << res->ToSource());
}

TEST(MutatorF, TestMultiExec) {
  auto testcase =
      "multi\n"
      "sadd mylist bar\n"
      "exec";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  symbol_analysis::SymbolAnalyzer a;
  a.Analyze(testcase_ir);
  ASSERT_EQ(a.HasUnresolvedError(), false);

  testcase =
      "sadd mylist bar\n"
      "exec";
  testcase_ir = redis_frontend::ParseSourceToIR(testcase);

  a.Analyze(testcase_ir);
  ASSERT_EQ(a.HasUnresolvedError(), true);

  testcase =
      "multi\n"
      "sadd mylist bar\n"
      "exec\nexec";
  testcase_ir = redis_frontend::ParseSourceToIR(testcase);

  a.Analyze(testcase_ir);
  ASSERT_EQ(a.HasUnresolvedError(), true);
}

TEST(MutatorF, DeleteTest) {
  std::string testcase =
      "zadd myzset{t} 1 one -484 two 3 three\n"
      "zrangestore z2{t} myzset{t} 1 2 byscore\n"
      "zmpop 2 myzset{t} myzset{t} max count 1\n"
      "zcard myzset{t}\n"
      "zcount z2{t} 839891476 71109495624\n";

  std::string subtree_str = "zrangestore z2{t} myzset{t} 1 2 byscore";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR subtree_ir = redis_frontend::ParseSourceToIR(subtree_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);

  ir::IR_PTR to_delete;

  for (ir::IR_PTR &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_delete = each;
      break;
    }
  }
  ASSERT_TRUE(to_delete && "Unable to locate to_delete");

  mutator::Mutator mutator;
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);
  mutator.AddRemovableType(redis_frontend::GetProgType(),
                           {redis_frontend::GetNEWLINEType()});

  ir::IR_PTR after = mutator.DeleteNodeFromIR(testcase_ir, to_delete);

  MYLOG(INFO, "After delete:")
  MYLOG(INFO, after->ToSource())
}

TEST(MutatorF, FixTest1) {
  std::string testcase =
      "setex burx 10000 x\n"
      "copy mykey{t} mynewkey{t} db notanumber";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);

  mutator::Mutator mutator;
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(testcase_ir);

  ASSERT_TRUE(res);
  MYLOG(INFO, "After fix:\n" << res->ToSource());

  std::string testcase2 =
      "xadd destkey{t}   123 message \"Hello,\"\n"
      "slowlog get -1\n"
      "xgroup setid mystream mygroup 0\n"
      "shutdown\n"
      "get foo";
  ir::IR_PTR testcase2_ir = redis_frontend::ParseSourceToIR(testcase2);
  res = mutator.FixUnresolvedErrors(testcase2_ir);

  // unable to fix, but can analyze without aborting
  ASSERT_FALSE(res);

  std::string testcase3 =
      "bitop or target{t} mykey target{t} mykey target{t}\n"
      "set mykey 0.37641803099607024\n"
      "copy zset_6{t} newx{t}\n"
      "del mykey\n"
      "set mykey 0.37641803099607024\n"
      "get mykey\n";
  ir::IR_PTR testcase3_ir = redis_frontend::ParseSourceToIR(testcase3);
  res = mutator.FixUnresolvedErrors(testcase3_ir);

  std::string testcase4 =
      "sadd key "
      "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx104\n"
      "del nnc\n"  // this del will invalidate `key`, which should invalidate `newzset2{t}`
      "setex x -505 test\n"
      "copy key newzset2{t}\n"
      "get x\n";
  ir::IR_PTR testcase4_ir = redis_frontend::ParseSourceToIR(testcase4);
  res = mutator.FixUnresolvedErrors(testcase4_ir);

  auto testcase5 =
      "append _string 899\n"
      "pfadd _string a c\n"
      "lcs _string _string   minmatchlen 4\n"
      "copy _string mynewkey{t} db notanumber\n"
      "info cpu default\n"
      "del key_y\n"
      "info cpu default\n"
      "copy mynewkey{t} mynewkey{t}  replace\n"
      "get _string\n";
  ir::IR_PTR testcase5_ir = redis_frontend::ParseSourceToIR(testcase5);
  res = mutator.FixUnresolvedErrors(testcase5_ir);

  auto testcase6 =
      "xadd mystream   * message -56\n"
      "xgroup create mystream gg 0\n"
      "del mystream\n"
      "copy mystream newset1{t}\n"
      "xinfo stream mystream full";

  ir::IR_PTR testcase6_ir = redis_frontend::ParseSourceToIR(testcase6);
  ir::IR_PTR fixed = mutator.FixUnresolvedErrors(testcase6_ir);
  ASSERT_FALSE(fixed);
}

TEST(MutatorF, ReplaceAndFixTest4) {
  std::string testcase =
      "xadd mystream   * message -56\n"
      "xgroup create mystream gg 0\n"
      "xgroup create mystream o 0\n"  // -> "del mystream"
      "copy mystream newset1{t}\n"
      "xinfo stream mystream full";

  std::string subtree_str = "xgroup create mystream o 0";
  std::string another_str = "del mystream";

  ir::IR_PTR testcase_ir = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR another_ir = redis_frontend::ParseSourceToIR(another_str);

  std::vector<ir::IR_PTR> testcase_irs =
      subtree_collector::CollectSubtreesSafeToMutate(testcase_ir);
  std::vector<ir::IR_PTR> another_irs =
      subtree_collector::CollectSubtreesSafeToMutate(another_ir);

  ir::IR_PTR to_mut, another;

  for (ir::IR_PTR &each : testcase_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(subtree_str) != std::string::npos) {
      to_mut = each;
      break;
    }
  }
  ASSERT_TRUE(to_mut && "Unable to locate to_mut");

  for (auto &each : another_irs) {
    if (each->GetName() == "prog" &&
        each->ToSource().find(another_str) != std::string::npos) {
      another = each;
      break;
    }
  }
  ASSERT_TRUE(another && "Unable to locate");

  mutator::Mutator mutator;
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);

  ir::IR_PTR replaced_new_root =
      mutator.ReplaceSubtreeWithAnother(testcase_ir, to_mut, another);
  ir::IR_PTR res = mutator.FixUnresolvedErrors(replaced_new_root);

  // no way to mutate while preserving semantic correctness
  ASSERT_TRUE(res == nullptr);
}

TEST(MutatorF, TestStrKeyCustomResolver) {
  std::string testcase =
      "set a \"123\"\n"
      "set b \"absdfalksdjfasdf\"\n"
      "incr key\n"
      "incrby key 5\n"
      "incrbyfloat key 5.0\n"
      "decr key\n"
      "decrby key 5\n"
      "getrange key 0 3\n"
      "lcs key1 key2 len\n"
      "setrange key1 5 \"test\"\n"
      "substr key1 1 2";
  ir::IR_PTR root = redis_frontend::ParseSourceToIR(testcase);
  ASSERT_TRUE(root);
  mutator::Mutator mutator;
  mutator.RegisterFrontendParserFunction(redis_frontend::ParseSourceToIR);
  mutator.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  auto fixed = mutator.FixUnresolvedErrors(root);
  ASSERT_TRUE(fixed);
  ASSERT_TRUE(fixed->ToSource().find("incr a") != std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("incrby a 5") != std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("incrbyfloat a 5") != std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("decr b") == std::string::npos);

  testcase =
      "hset a a_field 123\n"
      "hset b b_field 456\n"
      "hset a a_field2 \"sdfasdf\"\n"
      "hget a b_field\n"
      "hincrby a f 123\n"
      "hincrbyfloat a f 123\n"
      "hmget b x x\n"
      "hsetnx gvybisqn eqjeoqrr moozvrzw";
  ;
  root = redis_frontend::ParseSourceToIR(testcase);
  ASSERT_TRUE(root);
  fixed = mutator.FixUnresolvedErrors(root);
  ASSERT_TRUE(fixed);
  ASSERT_TRUE(fixed->ToSource().find("hget a a_field") != std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("hincrby a a_field 123") !=
              std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("hincrbyfloat a a_field 123") !=
              std::string::npos);
  ASSERT_TRUE(fixed->ToSource().find("hmget b b_field b_field") !=
              std::string::npos);

  testcase =
      "set mykey hello\n"
      "del mykey\n"
      "set mykey 0\n"
      "get mykey";
  root = redis_frontend::ParseSourceToIR(testcase);
  ASSERT_TRUE(root);
  fixed = mutator.FixUnresolvedErrors(root);
  ASSERT_TRUE(fixed);
}

TEST(MutatorTest, TestMutationMode0) {
  std::string testcase =
      "zadd foo 100 bar\nzdiff 1 foo\nzdiff 2 foo\nzadd aaa 100 bbb\nzdiff 2 "
      "aaa";
  std::string testcase2 = "zdiff 2 foo\n";
  ir::IR_PTR root = redis_frontend::ParseSourceToIR(testcase);
  ir::IR_PTR root2 = redis_frontend::ParseSourceToIR(testcase2);
  ASSERT_TRUE(root);
  ASSERT_TRUE(root2);
  mutator::Mutator mutator;
  mutator.SetMutationMode(Mutator::MutationMode::kMode0);
  mutator.SetFrontendInterface(redis_frontend::interface);

  absl::flat_hash_set<std::string> virtual_corpus;
  virtual_corpus.insert(testcase);

  symbol_analysis::SymbolAnalyzer analyzer;

  mutator.NewAddSubtreesToPool(root2);
  constexpr size_t target_mut_size = 10;
  size_t iter_done = 0;
  while (virtual_corpus.size() < target_mut_size) {
    size_t count = mutator.Mutate(testcase);

    if (!count) break;

    for (size_t i = 0; i < count; ++i) {
      ir::IR_PTR new_mutation = mutator.GetNextMutation();

      // make sure that the new testcase is semantic correct
      analyzer.Reset();
      analyzer.Analyze(new_mutation);
      if (analyzer.HasUnresolvedError()) {
        std::cout << new_mutation->ToLinearString();
        analyzer.PrintScopes();
        ASSERT_TRUE(false && "Unexpected");
      }

      if (virtual_corpus.insert(new_mutation->ToSource()).second) {
        mutator.NewAddSubtreesToPool(new_mutation);
      }
    }
    ++iter_done;
  }

  std::cout << "iter done: " << iter_done
            << ", final corpus size: " << virtual_corpus.size() << std::endl;
}

}  // namespace mutator