licenses(["notice"])

load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")

cc_library(
    name = "aflpp",
    srcs = glob([
        "include/*",
    ]),
    hdrs = [
        "include/afl-fuzz.h",
    ],
    includes = ["include"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "srcs",
    srcs = glob(["**/*"]),
    visibility = ["//visibility:public"],
)
