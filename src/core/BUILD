load("@rules_cc//cc:defs.bzl", "cc_binary")

load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")

cc_library(
  name = "ir",
  srcs = [
    "ir.cc",
  ],
  hdrs = [
    "ir.h",
  ],
  copts = [
    "-g",
    "-std=c++2a",
  ],
  visibility = ["//visibility:public"],
  deps = [
    "//src/utils/libs:utils",
    "@com_google_absl//absl/strings:str_format",
    "@com_google_absl//absl/container:flat_hash_map",
    "@nlohmann_json//:json",
    "@github_microsoft_GSL//:gsl"
  ],
)

cc_library(
  name = "mutator",
  srcs = [
    "mutator.cc",
  ],
  hdrs = [
    "mutator.h",
  ],
  copts = [
    "-g",
    "-std=c++2a",
    #"-fsanitize=address"
  ],
  linkopts = ["-ldl"],
  linkstatic = 1,
  visibility = ["//visibility:public"],
  deps = [
    ":ir",
    ":symbol_analysis",
    "@com_google_absl//absl/container:flat_hash_map",
    "@com_google_absl//absl/container:flat_hash_set",
    "@com_google_googletest//:gtest_main",
    "@github_microsoft_GSL//:gsl",
    "@yaml_cpp//:yaml-cpp",
  ],
)

cc_library(
  name = "symbol_analysis",
  srcs = [
    "symbol_analysis.cc",
    "anno_context.cc",
  ],
  hdrs = [
    "symbol_analysis.h",
    "anno_context.h"
  ],
  copts = [
    "-g",
    "-std=c++2a",
  ],
  linkstatic = 1,
  visibility = ["//visibility:public"],
  deps = [
    ":ir",
    "@com_google_absl//absl/container:flat_hash_map",
    "@com_google_absl//absl/container:flat_hash_set",
    "@com_google_absl//absl/strings:str_format",
    ":subtree_collector",
    "//src/core/parsers/anno_context:anno_context_parser"
  ],
)

cc_library(
  name = "subtree_collector",
  srcs = [
    "subtree_collector.cc",
  ],
  hdrs = [
    "subtree_collector.h",
  ],
  copts = [
    "-g",
    "-std=c++2a",
    #"-fsanitize=address"
  ],
  #linkopts = ["-fsanitize=address"],
  linkstatic = 1,
  visibility = ["//visibility:public"],
  deps = [
    ":ir",
    "@com_google_absl//absl/container:flat_hash_map",
    "@com_google_absl//absl/container:flat_hash_set",
  ],
)

filegroup(
  name = "export_srcs",
  srcs = glob([
    "*",
  ]),
  visibility = ["//visibility:public"],
)

load("@com_github_bazelbuild_buildtools//buildifier:def.bzl", "buildifier")

buildifier(
  name = "buildifier",
)
