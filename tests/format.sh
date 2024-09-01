#!/bin/bash

echo "[*] Starting to format the source code..."

full_file_path=$(pwd -P)
format_path_src=$(expr match $full_file_path "\(.*\)bazel-out")"src/"
format_path_tests=$(expr match $full_file_path "\(.*\)bazel-out")"tests/"
clang_format_config=$(expr match $full_file_path "\(.*\)bazel-out")".clang-format"

echo $clang_format_config

if [ -d $format_path_src ] && [ -d $format_path_tests ];
then

    echo "[*] Format path: $format_path_src"
    find $format_path_src -path "${format_path_src}frontends/*" -prune -o -name "*.cc" -print -o -iname "*.h" -print | xargs clang-format -style="file:${clang_format_config}" -i

    echo "[*] Format path: $format_path_tests"
    find $format_path_tests -iname "*.h" -print -o -iname "*.cc" -print | xargs clang-format -style="file:${clang_format_config}" -i
    
else
    echo "[x] Cannot find $format_path_src."
    echo "[x] Cannot find $format_path_tests."
    exit -1
fi