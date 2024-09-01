# we are not using this now
licenses(["notice"])

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "antlr4_cppruntimesrc",
    srcs = glob(["runtime/Cpp/**"]),
    visibility = ["//visibility:public"],
)

cmake(
    name = "antlr4_cpp_runtime",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_C_FLAGS": "-fPIC",
        "CMAKE_CXX_FLAGS": "-fPIC",
    },
    lib_source = "@github_antlr4//:antlr4_cppruntimesrc",
    out_include_dir = "include/antlr4-runtime",
    out_static_libs = ["libantlr4-runtime.a"],
    tags = ["requires-network"],
    visibility = ["//visibility:public"],
)
