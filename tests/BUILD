load("@rules_cc//cc:defs.bzl", "cc_test")

sh_test(
    name = "format_file",
    srcs = ["format.sh"],
    data = [
        "//src/core:export_srcs",
        "//:export_clang_format_config"
    ],
    local = True,
    tags = ["external"],
)

cc_test(
    name = "redis_ir_and_mutator_test",
    srcs = ["redis_ir_and_mutator_test.cc"],
    linkopts = [
        "-lutil",
        "-g",
        "-lpthread",
    ],
    linkstatic = True,
    deps = [
        "//src/core:mutator",
        "//src/frontends/redis/redis_frontend",
        "//src/core:symbol_analysis",
        "@com_google_googletest//:gtest_main",
    ],
)


cc_test(
    name = "anno_context_test",
    srcs = ["anno_context_test.cc"],
    linkopts = [
        "-lutil",
        #"-fsanitize=address",
        "-g",
        "-lpthread",
    ],
    linkstatic = True,
    deps = [
        "//src/core:symbol_analysis",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "symbol_analysis_test",
    srcs = ["symbol_analysis_test.cc"],
    linkopts = [
        "-lutil",
        "-g",
        "-lpthread",
        "-std=c++2a",
    ],
    linkstatic = True,
    deps = [
        "//src/frontends/redis/redis_frontend",
        "//src/core:symbol_analysis",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "subtree_collector_test",
    srcs = ["subtree_collector_test.cc"],
    linkopts = [
        "-lutil",
        #"-fsanitize=address",
        "-g",
        "-lpthread",
        "-std=c++2a",
    ],
    linkstatic = True,
    deps = [
        "//src/frontends/redis/redis_frontend",
        "//src/core:subtree_collector",
        "@com_google_googletest//:gtest_main",
    ],
)

