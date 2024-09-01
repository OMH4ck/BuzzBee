#include "src/core/subtree_collector.h"

#include "absl/container/flat_hash_set.h"
#include "gtest/gtest.h"
#include "src/frontends/redis/redis_frontend/redis_frontend.h"
#include "src/utils/libs/utils.h"

TEST(SubtreeCollectorTest, TestCollectSubtreesContainingLabel) {
  ir::IR_PTR root = redis_frontend::ParseSourceToIR("copy src dst replace");
  auto subtrees = subtree_collector::CollectSubtreesContainingLabel(
      root, "CopyRule1->elem2->0");
  for (auto& each : subtrees) {
    ASSERT_TRUE(each->ToSource().find("dst") != std::string::npos);
  }
}