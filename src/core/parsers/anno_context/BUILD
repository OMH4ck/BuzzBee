cc_library(
  name = "anno_context_parser",
  srcs = glob(["generated_parser/*.cpp"]),
  hdrs = glob(["generated_parser/*.h"]),
  copts = [
    "-g",
    "-std=c++2a",
  ],
  linkopts = [
    "-lpthread",
  ],
  deps = [
    "@github_antlr4//:antlr4_cpp_runtime"
  ],
  visibility = ["//visibility:public"]
)