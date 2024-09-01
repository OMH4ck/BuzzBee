#include "src/core/symbol_analysis.h"

#include "absl/container/flat_hash_set.h"
#include "gtest/gtest.h"
#include "src/frontends/redis/redis_frontend/redis_frontend.h"

#define VEC_UNORDERED_EQ(vec1, vec2)                                          \
  {                                                                           \
    auto set1 = absl::flat_hash_set<decltype(vec1)::value_type>(vec1.begin(), \
                                                                vec1.end());  \
    auto set2 = absl::flat_hash_set<decltype(vec2)::value_type>(vec2.begin(), \
                                                                vec2.end());  \
    ASSERT_EQ(set1, set2);                                                    \
  }

TEST(SymbolAnalysis, AvailableLabelsAnalysis) {
  auto sym_info = nlohmann::json::parse(
      R"( { "?": { "DefineSymbol": [ "CopyRule1->elem2" ], "InvalidateSymbol": [], "UseSymbol": [ "CopyRule1->elem1" ] }, "geo_key": { "DefineSymbol": [ "GeoAddRule1->elem" ], "InvalidateSymbol": [], "UseSymbol": [ "GeoSearchStoreRule2->elem", "GeoSearchRule1->elem", "GeoRadiusRule1->elem", "GeoPosRule1->elem", "GeoDistRule1->elem", "GeoHashRule1->elem", "ExpireRule1->elem", "PExpireRule1->elem", "DumpRule1->elem" ] }, "geo_member": { "DefineSymbol": [ "GeoAddRuleMember1->elem" ], "InvalidateSymbol": [], "UseSymbol": [ "GeoSearchStoreRule3->elem", "GeoSearchRule2->elem", "GeoPosRule2->elem", "GeoPosRule3->elem", "GeoHashRule3->elem", "GeoDistRule2->elem", "GeoDistRule3->elem" ] }, "hash_key": { "DefineSymbol": [ "HSetRule1->elem", "HMSetRule1->elem", "HSetNXRule1->elem" ], "InvalidateSymbol": [ "DelRule1->elem", "DelRule2->elem", "HDelRule1->elem" ], "UseSymbol": [ "HExistsRule1->elem", "HGetRule1->elem", "HGetAllRule1->elem", "HIncrByRule1->elem", "HIncrByFloatRule1->elem", "HKeysRule1->elem", "HLenRule1->elem", "HMGetRule1->elem", "HRandFieldRule1->elem", "HScanRule1->elem", "HStrLenRule1->elem", "HValsRule1->elem", "ExpireRule1->elem", "PExpireRule1->elem", "DumpRule1->elem" ] }, "list_key": { "DefineSymbol": [ "RPushRule1->elem", "BlMoveRule2->elem", "BRPopLPushRule2->elem", "LMoveRule2->elem", "LPushRule1->elem", "RPopLPushRule2->elem" ], "InvalidateSymbol": [ "DelRule1->elem", "DelRule2->elem" ], "UseSymbol": [ "ExpireRule1->elem", "PExpireRule1->elem", "BlMoveRule1->elem", "BLMPopRule1->elem", "BLMPopRule2->elem", "BLPopRule1->elem", "BLPopRule2->elem", "BRPopRule1->elem", "BRPopRule2->elem", "BRPopLPushRule1->elem", "LIndexRule1->elem", "LInsertRule1->elem", "LLenRule1->elem", "LMoveRule1->elem", "LMPopRule1->elem", "LMPopRule2->elem", "LPopRule1->elem", "LPosRule1->elem", "LPushXRule1->elem", "LRangeRule1->elem", "LRemRule1->elem", "LSetRule1->elem", "LTrimRule1->elem", "RPopRule1->elem", "RPopLPushRule1->elem", "RPushXRule1->elem", "SortRule1->elem", "DumpRule1->elem" ] }, "sample_type": { "DefineSymbol": [ "SampleRule1->elem", "SampleRule2->elem2" ], "InvalidateSymbol": [ "SampleRule4->elem" ], "UseSymbol": [ "SampleRule3->elem" ] }, "set_key": { "DefineSymbol": [ "SAddRule1->elem", "SDiffStoreRule1->elem", "SInterStoreRule1->elem", "SMoveRule2->elem", "SUnionStoreRule0->elem" ], "InvalidateSymbol": [ "DelRule1->elem", "DelRule2->elem" ], "UseSymbol": [ "ExpireRule1->elem", "PExpireRule1->elem", "SCardRule1->elem", "SDiffRule1->elem", "SDiffRule2->elem", "SDiffStoreRule2->elem", "SDiffStoreRule3->elem", "SInterRule1->elem", "SInterRule2->elem", "SInterCardRule1->elem", "SInterCardRule2->elem", "SInterStoreRule2->elem", "SInterStoreRule3->elem", "SIsMemberRule1->elem", "SMembersRule1->elem", "SMIsMemberRule1->elem", "SMoveRule1->elem", "SPopRule1->elem", "SRandMemberRule1->elem", "SRemRule1->elem", "SScanRule1->elem", "SUnionRule1->elem", "SUnionRule2->elem", "SUnionStoreRule1->elem", "SUnionStoreRule2->elem", "SortRule1->elem", "DumpRule1->elem" ] }, "sorted_set_key": { "DefineSymbol": [ "ZAddRule->elem", "ZStoreRule1->dest", "ZInterStore3->dest", "ZRangeStore1->dest", "ZUnionStoreRule1->dest" ], "InvalidateSymbol": [ "DelRule1->elem", "DelRule2->elem" ], "UseSymbol": [ "ZCardRule->elem", "ZCountRule->elem", "ZDiffRule1->elem", "ZDiffRule2->elem", "ZStoreRule2->elem", "ZStoreRule3->elem", "ZIncrBy->elem", "ZInter1->elem", "ZInter2->elem", "ZInterCard1->elem", "ZInterCard2->elem", "ZInterStore1->elem", "ZInterStore2->elem", "ZLexCount->elem", "ZMPop1->elem", "ZMPop2->elem", "ZMScore->elem", "ZPopMax->elem", "ZPopMin->elem", "ZRandMember->elem", "ZRange->elem", "ZRangeByLex->elem", "ZRangeByScore->elem", "ZRangeStore2->elem", "ZRankRule->elem", "ZRemRule->elem", "ZRemRangeByLex->elem", "ZRemRangeByRank->elem", "ZRemRangeByScore->elem", "ZRevRange->elem", "ZRevRangeByLex->elem", "ZRevRangeByScore->elem", "ZRevRank->elemkey", "ZScanRule->elem", "ZScoreRule->elem", "ZUnionRule1->elem", "ZUnionRule2->elem", "ZUnionStoreRule2->elem", "ZUnionStoreRule3->elem", "BZMPopRule1->elem", "BZMPopRule2->elem", "BZPopMaxRule1->elem", "BZPopMaxRule2->elem", "BZPopMinRule1->elem", "BZPopMinRule2->elem", "ExpireRule1->elem", "PExpireRule1->elem", "SortRule1->elem", "DumpRule1->elem" ] }, "str_key": { "DefineSymbol": [ "BitopRule0->elem", "AppendRule1->elem", "SetRule1->elem", "MSetRule1->elem", "MSetRule2->elem", "MSetNxRule1->elem", "MSetNxRule2->elem", "PSetExRule1->elem", "SetExRule1->elem", "SetNxRule1->elem" ], "InvalidateSymbol": [ "DelRule1->elem", "DelRule2->elem", "GetDelRule1->elem" ], "UseSymbol": [ "BitPosRule1->elem", "BitopRule1->elem", "BitopRule2->elem", "BitfieldRule1->elem", "ExpireRule1->elem", "PExpireRule1->elem", "StrLenRule1->elem", "GetRangeRule1->elem", "DecrRule1->elem", "DecrByRule1->elem", "GetRule1->elem", "GetExRule1->elem", "GetSetRule1->elem", "IncrRule1->elem", "IncrByRule1->elem", "IncrByFloatRule1->elem", "LCSRule1->elem", "LCSRule2->elem", "MGetRule1->elem", "MGetRule2->elem", "SetRangeRule1->elem", "SubStrRule1->elem", "DumpRule1->elem" ] }, "stream_key": { "DefineSymbol": [ "XAddRule1->elem" ], "InvalidateSymbol": [ "XDelRule1->elem", "DelRule1->elem", "DelRule2->elem" ], "UseSymbol": [ "XAckRule1->elem1", "XAutoClaimRule1->elem", "XClaimRule1->elem", "XGroupCreateRule1->elem", "XGroupCreateconsumerRule1->elem1", "XGroupDelconsumerRule1->elem1", "XGroupDestroyRule1->elem", "XGroupSetidRule1->elem1", "XInfoConsumersRule1->elem1", "XInfoGroupsRule1->elem", "XInfoStreamRule1->elem", "XLenRule1->elem", "XPendingRule1->elem1", "XRangeRule1->elem", "XReadRule1->elem", "XReadRule2->elem", "XReadGroupRule1->elem", "XReadGroupRule2->elem", "XRevRangeRule1->elem", "XTrimRule1->elem", "ExpireRule1->elem", "PExpireRule1->elem", "DumpRule1->elem" ] }, "xgroup_consumername_of_key_?_group_?": { "DefineSymbol": [ "XGroupCreateconsumerRule1->elem3" ], "InvalidateSymbol": [ "XGroupDelconsumerRule1->elem3" ], "UseSymbol": [] }, "xgroup_groupname_of_key_?": { "DefineSymbol": [ "XGroupCreateRule2->elem" ], "InvalidateSymbol": [ "XGroupDestroyRule2->elem" ], "UseSymbol": [ "XAckRule1->elem2", "XGroupCreateconsumerRule1->elem2", "XGroupDelconsumerRule1->elem2", "XGroupSetidRule1->elem2", "XInfoConsumersRule1->elem2", "XPendingRule1->elem2" ] }, "zadd_member": { "DefineSymbol": [ "ZAddRule2->elem", "ZAddRule3->elem" ], "InvalidateSymbol": [], "UseSymbol": [ "ZRevRank->elemmember" ] } })");

  // test 1
  std::vector<std::string> available_labels =
      symbol_analysis::GetSupportingLabelsForSymbolType("zadd_member",
                                                        sym_info);

  std::vector<std::string> vec_expected = {
      "ZAddRule2->elem", "CopyRule1->elem2", "ZAddRule3->elem",
      "CopyRule1->elem1", "ZRevRank->elemmember"};

  VEC_UNORDERED_EQ(available_labels, vec_expected);

  // test 2
  available_labels =
      symbol_analysis::GetSupportingLabelsForSymbolType("some_key", sym_info);
  vec_expected = {"CopyRule1->elem2", "CopyRule1->elem1"};
  VEC_UNORDERED_EQ(available_labels, vec_expected);
}

TEST(SymbolAnalysis, TestCreateAndExitScope) {
  ir::IR_PTR root = redis_frontend::ParseSourceToIR("zadd foo 100 bar");
  ASSERT_TRUE(root);

  symbol_analysis::SymbolAnalyzer analyzer;
  analyzer.Analyze(root);

  analyzer.PrintScopes();

  ASSERT_EQ(analyzer.HasUnresolvedError(), false);
}

TEST(SymbolAnalysis, TestAlterOrder) {
  ir::IR_PTR root = redis_frontend::ParseSourceToIR(
      "geosearchstore a a fromlonlat 0 0 byradius 1 km");
  symbol_analysis::SymbolAnalyzer analyzer;
  analyzer.Analyze(root);
  ASSERT_EQ(analyzer.HasUnresolvedError(), true);

  root = redis_frontend::ParseSourceToIR(
      "geoadd a 13.361389 38.115556 palermo 15.087269 37.502669 catania\n"
      "geosearchstore a a fromlonlat 0 0 byradius 1 km");
  analyzer.Reset();
  analyzer.Analyze(root);
  ASSERT_EQ(analyzer.HasUnresolvedError(), false);

  root = redis_frontend::ParseSourceToIR("bitop not s s");
  analyzer.Reset();
  analyzer.Analyze(root);
  ASSERT_EQ(analyzer.HasUnresolvedError(), true);

  root = redis_frontend::ParseSourceToIR("set s foobar\nbitop not a s");
  analyzer.SetCustomResolverMap(redis_frontend::GetCustomTypeResolverMap());
  analyzer.Reset();
  analyzer.Analyze(root);
  ASSERT_EQ(analyzer.HasUnresolvedError(), false);
}

TEST(SymbolAnalysis, TestCheckUseBeforeDefOK) {
  ir::IR_PTR root =
      redis_frontend::ParseSourceToIR("zadd foo 100 bar\nzdiff 1 foo");
  ASSERT_TRUE(root);

  symbol_analysis::SymbolAnalyzer analyzer;
  analyzer.Analyze(root);
  analyzer.PrintScopes();

  ASSERT_EQ(analyzer.HasUnresolvedError(), false);
}

TEST(SymbolAnalysis, TestCheckUseBeforeDefError) {
  ir::IR_PTR root =
      redis_frontend::ParseSourceToIR("zadd foo 100 bar\nzdiff 1 foo2");
  ASSERT_TRUE(root);

  symbol_analysis::SymbolAnalyzer analyzer;
  analyzer.Analyze(root);
  analyzer.PrintScopes();

  ASSERT_EQ(analyzer.GetNumberOfUnresolvedErrors(), 1);
  auto error = analyzer.PopOneUnresolvedErrorFromQueue();
  ASSERT_EQ(error.error_code,
            symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedUse);
}

TEST(SymbolAnalysis, TestCheckInvalidateBeforeDef) {
  ir::IR_PTR root =
      redis_frontend::ParseSourceToIR("del foo\nzadd foo 100 bar");
  ASSERT_TRUE(root);

  symbol_analysis::SymbolAnalyzer analyzer;
  analyzer.Analyze(root);
  analyzer.PrintScopes();

  ASSERT_EQ(analyzer.GetNumberOfUnresolvedErrors(), 1);
  auto error = analyzer.PopOneUnresolvedErrorFromQueue();
  ASSERT_EQ(error.error_code,
            symbol_analysis::UnresolvedError::ErrorCode::kUnresolvedInvalidate);

  root = redis_frontend::ParseSourceToIR("zadd foo 100 bar\ndel foo");
  ASSERT_TRUE(root);

  analyzer.Reset();
  analyzer.Analyze(root);
  analyzer.PrintScopes();

  ASSERT_EQ(analyzer.HasUnresolvedError(), false);
}

TEST(SymbolAnalysis, TestDependencyGraph) {
  symbol_analysis::DependencyGraph g;
  std::vector<ir::IR_PTR> arr;
  for (size_t i = 0; i < 10; ++i) {
    ir::IR_PTR new_ir = ir::IR::NewIR();
    //new_ir->SetName(absl::StrFormat("node%d", i));
    arr.push_back(new_ir);
  }
  g.AddEdge(arr[0], arr[1]);
  g.AddEdge(arr[1], arr[2]);
  g.AddEdge(arr[4], arr[3]);
  g.AddEdge(arr[3], arr[2]);
  g.AddEdge(arr[2], arr[5]);
  g.AddEdge(arr[5], arr[6]);
  g.AddEdge(arr[6], arr[7]);
  g.AddEdge(arr[9], arr[7]);
  g.AddEdge(arr[7], arr[8]);
  g.FinalizeGraph();

  ASSERT_EQ(arr[8]->GetOrderID(), 0);
  ASSERT_EQ(arr[7]->GetOrderID(), 1);
  ASSERT_TRUE(arr[9]->GetOrderID() > arr[7]->GetOrderID());
  ASSERT_TRUE(arr[6]->GetOrderID() > arr[7]->GetOrderID());
  ASSERT_TRUE(arr[5]->GetOrderID() > arr[6]->GetOrderID());
  ASSERT_TRUE(arr[2]->GetOrderID() > arr[5]->GetOrderID());
  ASSERT_TRUE(arr[0]->GetOrderID() > arr[1]->GetOrderID());
  ASSERT_TRUE(arr[1]->GetOrderID() > arr[2]->GetOrderID());
  ASSERT_TRUE(arr[3]->GetOrderID() > arr[2]->GetOrderID());
  ASSERT_TRUE(arr[4]->GetOrderID() > arr[3]->GetOrderID());

  std::vector<ir::IR_PTR> res = g.GetAllDescendentsOfVertex(arr[8]);

  absl::flat_hash_set<ir::IR_PTR> res_set(res.begin(), res.end());
  absl::flat_hash_set<ir::IR_PTR> expected;
  for (size_t i = 0; i < 10; ++i) {
    if (i == 8) continue;
    expected.insert(arr[i]);
  }
  ASSERT_EQ(res_set, expected);

  res = g.GetAllDescendentsOfVertex(arr[2]);
  absl::flat_hash_set<ir::IR_PTR> res_set2(res.begin(), res.end());
  ASSERT_EQ(res_set2,
            absl::flat_hash_set<ir::IR_PTR>({arr[0], arr[1], arr[3], arr[4]}));
}
