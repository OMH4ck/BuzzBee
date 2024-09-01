#ifndef _SRC_UTILS_UTILS_H_
#define _SRC_UTILS_UTILS_H_

#include <chrono>
#include <random>

#include "absl/random/random.h"
#include "glog/logging.h"

#define MYLOG(severity, msg) \
  LOG(severity) << msg;      \
  google::FlushLogFiles(google::severity);

namespace utils {

template <typename T>
auto RandomChoice(const T &vector, std::shared_ptr<absl::BitGen> bitgen)
    -> decltype(vector.front()) {
  return vector.at(absl::Uniform<size_t>(*bitgen, 0, vector.size()));
}

// Randomly pick min(n, arrsize) elements and put them at the front.
template <typename T>
void MakeRandom(T &vec, size_t n, std::shared_ptr<absl::BitGen> bitgen) {
  size_t remain = vec.size();
  n = std::min(remain, n);
  auto l = vec.begin();
  while (n--) {
    auto r = l;
    std::advance(r, absl::Uniform<size_t>(*bitgen, 0, remain));
    std::swap(*l, *r);
    ++l;
    --remain;
  }
}

pid_t POpen2(const char *command, int *infp, int *outfp);

void Kill(pid_t pid);

template <typename Iter, typename RandomGenerator>
Iter SelectRandomly(Iter start, Iter end, RandomGenerator &g) {
  std::uniform_int_distribution<> dis(0, std::distance(start, end) - 1);
  std::advance(start, dis(g));
  return start;
}

std::string GetPrintableRepr(std::string str);

template <typename Iter>
Iter SelectRandomly(Iter start, Iter end) {
  static std::random_device rd;
  static std::mt19937 gen(rd());
  return SelectRandomly(start, end, gen);
}

std::string RTrim(const std::string &s);
std::string LTrim(const std::string &s);
std::string Trim(const std::string &s);

uint32_t GetRandomNumber(uint32_t start_inclusive, uint32_t end_inclusive);

std::streampos FileSize(const char *filename);

class Timer {
 public:
  Timer() : beg_(clock_::now()) {}
  void reset() { beg_ = clock_::now(); }
  double elapsed() const {
    return std::chrono::duration_cast<second_>(clock_::now() - beg_).count();
  }

 private:
  typedef std::chrono::high_resolution_clock clock_;
  typedef std::chrono::duration<double, std::ratio<1> > second_;
  std::chrono::time_point<clock_> beg_;
};

std::string SendCommandToOpenedTTYAndGetResponse(int master, const char *cmd,
                                                 const char *until_str,
                                                 bool &failed);
int OpenWithTTY(const char *command);

std::string ExecCmdAndGetOutput(const char *cmd);

std::string ReadUntil(int fd, std::string until_str, int timeout,
                      bool *reached_until_str);

};  // namespace utils

#endif  // _SRC_UTILS_UTILS_H_