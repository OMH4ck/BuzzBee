"""Given a grammar file, a lexer file (optional), and an annotation file, generates the frontend and mutator.

E.g.,

mkdir build

# Without a lexer:
python3 ./scripts/build_utils/oneshot.py --grammar=input_specs/redis/antlr/Redis.g4 --annotation=input_specs/redis/antlr/Redis.json --output=./build

# With a lexer and a parser
python3 ./scripts/build_utils/oneshot.py --grammar=XXXParser.g4 --lexer=XXXLexer.g4 --annotation=XXXParser.json --output=./build
"""

import argparse
import os
import subprocess

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
REPO_ROOT = SCRIPT_PATH + "/../../"
IMG_NAME = "buzzbeebuild"
CONTAINER_NAME = f"{IMG_NAME}_container"


def run_cmd(cmd, check=True):
    print(cmd)
    subprocess.run(cmd, shell=True, check=check)


def parse_args():
    # Parse command line arguments instead of using fire
    parser = argparse.ArgumentParser(
        description="Generate frontend and mutator in one shot"
    )
    parser.add_argument(
        "--grammar", type=str, required=True, help="Path to the grammar file"
    )
    parser.add_argument(
        "--annotation", type=str, required=True, help="Path to the annotation file"
    )
    parser.add_argument(
        "--output", type=str, required=True, help="Path to the output directory"
    )
    parser.add_argument("--lexer", type=str, default="", help="Path to the lexer file")
    parser.add_argument(
        "--no-cache", action="store_true", help="Do not use the cache for the build"
    )
    return parser.parse_args()


def oneshot():
    args = parse_args()
    # init build container
    try:
        run_cmd(f"docker ps | grep {CONTAINER_NAME}", True)
        container_running = True
    except:
        container_running = False
    if args.no_cache or not container_running:
        run_cmd(
            f"cd {REPO_ROOT} && docker build -t {IMG_NAME} -f ./.devcontainer/Dockerfile ."
        )
        run_cmd(f"docker stop {CONTAINER_NAME}", check=False)
        run_cmd(f"docker rm -f {CONTAINER_NAME}", check=False)
        run_cmd(
            f"cd {REPO_ROOT} && docker run -v $(pwd):/repo -i -d --name {CONTAINER_NAME} {IMG_NAME}"
        )

    # copy files in
    grammar_basename = os.path.basename(args.grammar)
    run_cmd(f"docker cp {args.grammar} {CONTAINER_NAME}:/tmp/{grammar_basename}")
    annotation_basename = os.path.basename(args.annotation)
    run_cmd(f"docker cp {args.annotation} {CONTAINER_NAME}:/tmp/{annotation_basename}")

    custom_resolvers_path = f"{os.path.dirname(args.annotation)}/custom_resolvers"
    if os.path.exists(custom_resolvers_path):
        run_cmd(
            f"docker cp {custom_resolvers_path} {CONTAINER_NAME}:/tmp/custom_resolvers"
        )

    if args.lexer:
        lexer_basename = os.path.basename(args.lexer)
        run_cmd(f"docker cp {args.lexer} {CONTAINER_NAME}:/tmp/{lexer_basename}")

    # frontend gen
    target_name = grammar_basename.split(".")[0].lower()  # Grammar.g4 -> grammar
    frontend_src_out = f"./src/frontends/{target_name}"
    run_cmd(f"docker exec -it {CONTAINER_NAME} rm -rf {frontend_src_out}", False)
    run_cmd(
        f'docker exec -it {CONTAINER_NAME} zsh -c "cd /repo && mkdir -p {frontend_src_out}"'
    )
    if args.lexer:
        run_cmd(
            f'docker exec -it {CONTAINER_NAME} zsh -c "cd /repo && python3 ./frontend_codegen/frontend_codegen.py --grammar_file=/tmp/{grammar_basename} --lexer_file=/tmp/{lexer_basename} --annotation_file=/tmp/{annotation_basename} --output_dir={frontend_src_out}"'
        )
    else:
        run_cmd(
            f'docker exec -it {CONTAINER_NAME} zsh -c "cd /repo && python3 ./frontend_codegen/frontend_codegen.py --grammar_file=/tmp/{grammar_basename} --annotation_file=/tmp/{annotation_basename} --output_dir={frontend_src_out}"'
        )

    # build
    run_cmd(f'docker exec -it {CONTAINER_NAME} zsh -c "cd /repo && bazel build //..."')

    # copy files out
    custom_mutator_out = f"{args.output}/aflpp_custom_mutator.so"
    frontend_out = f"{args.output}/{target_name}_frontend.so"
    run_cmd(
        f"docker cp {CONTAINER_NAME}:/repo/bazel-bin/src/aflpp_custom_mutators/generic_mutator/libaflpp_mutator.so {custom_mutator_out}"
    )
    run_cmd(
        f"docker cp {CONTAINER_NAME}:/repo/bazel-bin/src/frontends/{target_name}/{target_name}_frontend/lib{target_name}_frontend_dyn.so {frontend_out}"
    )

    print("Done. Check the following files:")
    print(custom_mutator_out)
    print(frontend_out)


if __name__ == "__main__":
    oneshot()
