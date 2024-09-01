
#include <fstream>
#include <gsl/gsl>
#include <memory>
#include <string>

#include "absl/strings/str_format.h"
#include "absl/strings/str_replace.h"
#include "src/core/mutator.h"
#include "src/utils/libs/filesystem_wrapper.h"
#include "src/utils/libs/utils.h"

// afl-fuzz.h has to come after the above headers
#include "afl-fuzz.h"
#include "alloc-inl.h"
#include "yaml-cpp/yaml.h"

struct CustomMutatorState {
  afl_state_t *afl;
  std::string last_allocated_buf;
  mutator::Mutator mut;
};

extern "C" {

u8 afl_custom_queue_new_entry(CustomMutatorState *state,
                              const unsigned char *filename_new_queue,
                              const unsigned char *filename_orig_queue) {
  std::ifstream ifs((const char *)filename_new_queue);
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ir::IR_PTR ir = state->mut.GetFrontendParserFunction()(content);
  if (!ir) {
    MYLOG(WARNING, content << "\nSyntax error when parsing testcase in "
                              "afl_custom_queue_new_entry")
  } else {
    state->mut.SaveSubtreesToPool(ir);
  }

  return false;
}

void *afl_custom_init(afl_state_t *afl, unsigned int seed) {
  google::InitGoogleLogging("redis_mutator");
  google::EnableLogCleaner(1);

  char random_prefix[] = "/tmp/redis_mutator.XXXXXX";
  int fd = mkstemp(random_prefix);
  close(fd);
  unlink(random_prefix);  // glog will create a different log file based on this
                          // prefix
  google::SetLogDestination(google::INFO, random_prefix);

  CustomMutatorState *state = new CustomMutatorState{};
  state->afl = afl;

  if (char *config_path = getenv("MUTATOR_CONFIG_PATH")) {
    // TODO: Check if file exists and do some checks for necessary fields
    state->mut.SetConfig(YAML::LoadFile(config_path));
  } else {
    FATAL("MUTATOR_CONFIG_PATH not set");
  }

  OKF("Custom mutator log dst prefix: %s", random_prefix);
  return state;
}

void afl_custom_deinit(void *data) {
  delete (CustomMutatorState *)data;
  return;
}

unsigned int afl_custom_fuzz_count(CustomMutatorState *state,
                                   const unsigned char *buf, size_t buf_size) {
  mutator::Mutator &mut = state->mut;
  std::string testcase = std::string((const char *)buf, buf_size);

  auto res = mut.Mutate(testcase);

  return res;
}

size_t afl_custom_fuzz(CustomMutatorState *state, uint8_t *buf, size_t buf_size,
                       uint8_t **out_buf, uint8_t *add_buf, size_t add_buf_size,
                       size_t max_size) {
  mutator::Mutator &mut = state->mut;
  state->last_allocated_buf = mut.GetNextMutationSource();

  size_t mut_size = state->last_allocated_buf.size();
  *out_buf = (uint8_t *)state->last_allocated_buf.c_str();

  return mut_size;
}
}