#include "src/core/anno_context.h"

#include "absl/strings/str_format.h"
#include "gtest/gtest.h"
#include "src/core/symbol_analysis.h"

TEST(AnnoContextTest, TestAnnoContextLang) {
  // Tests whether the navigation and context info retrieval are correctly implemented.
  std::vector<ir::IR_PTR> arr;

  symbol_analysis::SymbolAnalyzer
      dummy_analyzer;  // not really used since the test does not test scope access yet

  for (size_t i = 0; i < 10; ++i) {
    auto new_ir = ir::IR::NewIR();
    new_ir->SetName(absl::StrFormat("node%d", i));
    arr.push_back(new_ir);
  }

  auto bind_parent_child = [](ir::IR_PTR parent, ir::IR_PTR child) {
    parent->GetChildren().push_back(child);
    child->SetParent(parent);
  };

  // construct an AST like this:
  /*
        0
      1     2
     3 4  5   6
         7 8 9 
    */
  arr[3]->SetIsTerminal(true);
  arr[4]->SetIsTerminal(true);
  arr[7]->SetIsTerminal(true);
  arr[8]->SetIsTerminal(true);
  arr[9]->SetIsTerminal(true);
  bind_parent_child(arr[0], arr[1]);
  bind_parent_child(arr[1], arr[3]);
  bind_parent_child(arr[1], arr[4]);
  bind_parent_child(arr[0], arr[2]);
  bind_parent_child(arr[2], arr[5]);
  bind_parent_child(arr[2], arr[6]);
  bind_parent_child(arr[5], arr[7]);
  bind_parent_child(arr[5], arr[8]);
  bind_parent_child(arr[6], arr[9]);

  auto seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[9], "{.parent@text}test");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "node9test");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[9], "{.parent.parent@text}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "node7 node8 node9");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[9], "{.parent.parent.parent@text}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()),
            "node3 node4 node7 node8 node9");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[9], "{.parent.parent.parent@id}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "0");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(arr[7],
                                                           "{.rsib(1)@id}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "8");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(arr[8],
                                                           "{.lsib(1)@id}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "7");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[7], "{.parent.rsib(1)@id}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "6");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[7], "{.parent.parent@term_num}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "3");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[7], "{.parent.parent@node_num(node9)}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "1");

  seq = anno_context::AnnoContextAnalyzer::AnalyzeSequence(
      arr[7], "{.parent.child(1)@id}");
  ASSERT_EQ(seq.Evaluate(dummy_analyzer.GetScopes()), "8");
}
