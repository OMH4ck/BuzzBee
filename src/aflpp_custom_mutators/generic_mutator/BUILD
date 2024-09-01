cc_binary(
  name = "aflpp_mutator",
  srcs = ["aflpp_mutator.cc"],
  copts = [
    "-g",
    "-std=c++2a",
  ],
  linkshared = True,
  linkstatic = 1,
  visibility = ["//visibility:public"],
  deps = [
    "//src/core:mutator",
    "@github_aflpp//:aflpp",
    "@github_microsoft_GSL//:gsl",
    "@yaml_cpp//:yaml-cpp",
  ],
)
