cc_library(
  name = "utils",
  srcs = ["utils.cc"],
  hdrs = [
    "filesystem_wrapper.h",
    "utils.h",
  ],
  linkopts = ["-lutil"],
  visibility = ["//visibility:public"],
  deps = [
    "@com_google_absl//absl/strings:str_format",
    "@com_google_absl//absl/random",
    "@glog",
  ],
)