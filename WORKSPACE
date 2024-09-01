load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

git_repository(
    name = "com_google_googletest",
    remote = "https://github.com/google/googletest",
    tag = "release-1.11.0",
)

git_repository(
    name = "com_google_absl",
    commit = "8c0b94e793a66495e0b1f34a5eb26bd7dc672db0",
    remote = "https://github.com/abseil/abseil-cpp.git",
    shallow_since = "1661966121 -0400",
)

git_repository(
    name = "nlohmann_json",
    commit = "4b2c8ce6bcfe7f39f2bb9e680c1e7a4d67c2dd48",
    remote = "https://github.com/nlohmann/json.git",
)

git_repository(
    name = "com_google_benchmark",
    commit = "0d98dba29d66e93259db7daa53a9327df767a415",
    remote = "https://github.com/google/benchmark.git",
    shallow_since = "1641842067 +0000",
)

git_repository(
    name = "com_github_gflags_gflags",
    remote = "https://github.com/gflags/gflags.git",
    tag = "v2.2.2",
)

git_repository(
    name = "glog",
    remote = "https://github.com/google/glog.git",
    tag = "v0.5.0",
)

git_repository(
    name = "bazel_clang_tidy",
    commit = "c2fe98cfec0430e78bff4169e9ca0a43123e4c99",
    remote = "https://github.com/erenon/bazel_clang_tidy.git",
)

"""
http_archive(
    name = "github_antlr4",
    build_file = "//third_party:antlr_cpp_runtime.BUILD",
    sha256 = "ebeaed23ecc67addbccdb97cf63bb3425267f4ff2f3660d90167e0c2305dcd8e",
    strip_prefix = "antlr4-4.11.1",
    urls = [
        "https://github.com/antlr/antlr4/archive/refs/tags/4.11.1.zip",
    ],
)
"""

http_archive(
    name = "github_antlr4",
    build_file = "//third_party:antlr_cpp_runtime.BUILD",
    sha256 = "03cf459efc10e2da70f5ab103cedadee06b89c0d21a46fb2c34869c109e42ce9",
    strip_prefix = "antlr4-0.0.1-alpha",
    urls = [
        "https://github.com/yype/antlr4/archive/refs/tags/v0.0.1-alpha.zip",
    ],
)

http_archive(
    name = "github_tree_sitter",
    build_file = "//third_party:tree_sitter.BUILD",
    sha256 = "5327b7115d60482f3241324c075a7430c1cb5f3a5826f48d171631a27e60c3aa",
    strip_prefix = "tree-sitter-0.20.6",
    urls = [
        "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.20.6.zip",
    ],
)

http_archive(
    name = "github_aflpp",
    build_file = "//third_party:aflpp.BUILD",
    sha256 = "d6994d6e216d583609c046568bea41d6a42415955f972cb3f053eaba87a45104",
    strip_prefix = "AFLplusplus-4.05c",
    urls = [
        "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/4.05c.zip",
    ],
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Hedron's Compile Commands Extractor for Bazel
# https://github.com/hedronvision/bazel-compile-commands-extractor
http_archive(
    name = "hedron_compile_commands",
    strip_prefix = "bazel-compile-commands-extractor-3dddf205a1f5cde20faf2444c1757abe0564ff4c",
    # Replace the commit hash in both places (below) with the latest, rather than using the stale one here.
    # Even better, set up Renovate and let it do the work for you (see "Suggestion: Updates" in the README).
    url = "https://github.com/hedronvision/bazel-compile-commands-extractor/archive/3dddf205a1f5cde20faf2444c1757abe0564ff4c.tar.gz",
    # When you first run this tool, it'll recommend a sha256 hash to put here with a message like: "DEBUG: Rule 'hedron_compile_commands' indicated that a canonical reproducible form can be obtained by modifying arguments sha256 = ..."
)

load("@hedron_compile_commands//:workspace_setup.bzl", "hedron_compile_commands_setup")

hedron_compile_commands_setup()


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_foreign_cc",
    sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
    strip_prefix = "rules_foreign_cc-0.9.0",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies()

######################
# buildifier related #

# buildifier is written in Go and hence needs rules_go to be built.
# See https://github.com/bazelbuild/rules_go for the up to date setup instructions.
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "d6b2513456fe2229811da7eb67a444be7785f5323c6708b38d851d2b51e54d83",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.30.0/rules_go-v0.30.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.30.0/rules_go-v0.30.0.zip",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies")

go_rules_dependencies()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains")

go_register_toolchains(version = "1.17.2")

http_archive(
    name = "bazel_gazelle",
    sha256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
    ],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

# If you use WORKSPACE.bazel, use the following line instead of the bare gazelle_dependencies():
# gazelle_dependencies(go_repository_default_config = "@//:WORKSPACE.bazel")
gazelle_dependencies()

http_archive(
    name = "com_google_protobuf",
    sha256 = "3bd7828aa5af4b13b99c191e8b1e884ebfa9ad371b0ce264605d347f135d2568",
    strip_prefix = "protobuf-3.19.4",
    urls = [
        "https://github.com/protocolbuffers/protobuf/archive/v3.19.4.tar.gz",
    ],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3",
    strip_prefix = "buildtools-4.2.2",
    urls = [
        "https://github.com/bazelbuild/buildtools/archive/refs/tags/4.2.2.tar.gz",
    ],
)

git_repository(
    name = "github_microsoft_GSL",
    build_file = "//third_party:gsl.BUILD",
    tag = "v4.0.0",
    remote="https://github.com/microsoft/GSL.git",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "aspect_bazel_lib",
    sha256 = "97fa63d95cc9af006c4c7b2123ddd2a91fb8d273012f17648e6423bae2c69470",
    strip_prefix = "bazel-lib-1.30.2",
    url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.30.2/bazel-lib-v1.30.2.tar.gz",
)

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

git_repository(
    name = "yaml_cpp",
    remote = "https://github.com/jbeder/yaml-cpp.git",
    tag = "yaml-cpp-0.7.0",
)