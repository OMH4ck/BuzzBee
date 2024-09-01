import os
import subprocess
import argparse


SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
REPO_ROOT = SCRIPT_PATH + "/../../../"
DOCKER_IMG_NAME = "redis_aflpp_img"
DOCKER_FILE = "redis_aflpp.dockerfile"

FUZZER_SPAWNER_REL_PATH = "scripts/fuzzer_runner/utils/fuzzer_spawner.py"


def run_cmd(cmd, check=True):
    subprocess.run(cmd, shell=True, check=check)


def check_paths(paths, check_dir=False):
    for each in paths:
        if not check_dir and not os.path.exists(each):
            raise Exception(f"Invalid path: {each}")
        if check_dir and not os.path.isdir(each):
            raise Exception(f"Invalid directory: {each}")


def build_image(redis_version):
    run_cmd(
        f"cd {SCRIPT_PATH} && docker build --build-arg REDIS_COMMIT={redis_version} -t {DOCKER_IMG_NAME} -f {DOCKER_FILE} ."
    )


def spawn_fuzzers(
    aflpp_custom_mutator_path,
    redis_frontend_path,
    container_name,
    num_of_fuzzers,
    no_ms,
):
    # make a copy of the mutator to avoid bus error, which will happen when the mutator gets overwritten outside of the container

    run_cmd(f"docker cp {aflpp_custom_mutator_path} {container_name}:/mutator.so")
    run_cmd(f"docker cp {redis_frontend_path} {container_name}:/frontend.so")
    cmd = f"""docker exec -it {container_name} python3 /repo_root/{FUZZER_SPAWNER_REL_PATH} -f /AFLplusplus/afl-fuzz -i /seed_dir -o /sync_dir -p "/repo/redis/src/redis-server /repo/redis/redis.conf" -n {num_of_fuzzers} -s fuzzing --extra="-t 1000" --env="ulimit -s unlimited; LD_PRELOAD=\\"/usr/lib/x86_64-linux-gnu/libstdc++.so.6\\" AFL_PRELOAD=\\"/repo/preeny/x86_64-linux-gnu/desock.so\\" AFL_DISABLE_TRIM=1 AFL_CUSTOM_MUTATOR_ONLY=1 AFL_CUSTOM_MUTATOR_LIBRARY=/mutator.so MUTATOR_CONFIG_PATH=/config.yml" {"--no_ms" if no_ms else ""}"""

    print("Running cmd to spawn fuzzers:")
    print(cmd)
    run_cmd(cmd)


def run_watch_remove(container_name, clear_db=True, clear_log=True):
    run_cmd(f"docker cp {SCRIPT_PATH}/clear_db.sh {container_name}:/")
    run_cmd(f"docker cp {SCRIPT_PATH}/clear_log.sh {container_name}:/")

    if clear_db:
        run_cmd(
            f"""docker exec -it {container_name} tmux new-session -d -s clear_db bash /clear_db.sh"""
        )

    if clear_log:
        run_cmd(
            f"""docker exec -it {container_name} tmux new-session -d -s clear_log bash /clear_log.sh"""
        )


def parse_args():
    # use argparse to parse the arguments instead of fire
    parser = argparse.ArgumentParser(
        description="Run Redis AFL++ fuzzers with the BuzzBee mutator"
    )
    parser.add_argument(
        "--redis_version",
        type=str,
        required=True,
        help="The version (commit) of Redis to fuzz",
    )
    parser.add_argument(
        "--num_of_fuzzers",
        type=int,
        required=True,
        help="The number of fuzzers to run",
    )
    parser.add_argument(
        "--sync_dir",
        type=str,
        required=True,
        help="The directory to store the fuzzer outputs",
    )
    parser.add_argument(
        "--seed_dir",
        type=str,
        required=True,
        help="The directory containing the seed inputs",
    )
    parser.add_argument(
        "--corpus_dir",
        type=str,
        required=True,
        help="The directory containing the corpus inputs",
    )
    parser.add_argument(
        "--aflpp_custom_mutator_path",
        type=str,
        required=True,
        help="The path to the AFL++ custom mutator (we need to build this manually)",
    )
    parser.add_argument(
        "--redis_frontend_path",
        type=str,
        required=True,
        help="The path to the Redis frontend (we need to build this manually)",
    )
    parser.add_argument(
        "--mutator_config",
        type=str,
        required=True,
        help="The path to the mutator config file",
    )
    parser.add_argument(
        "--container_name",
        type=str,
        required=True,
        help="The name of the Docker container to run the fuzzer",
    )
    parser.add_argument(
        "--no_ms",
        action="store_true",
        help="Whether to use the M/S mode of AFL++ for the fuzzers to collaborate",
    )
    parser.add_argument(
        "--cpuset",
        type=str,
        required=False,
        help="The CPU set to run the fuzzers on",
    )
    parser.add_argument(
        "--clear_db",
        action="store_true",
        help="Whether to clear the Redis database routinely when running the fuzzers.",
    )
    parser.add_argument(
        "--clear_log",
        action="store_true",
        help="Whether to clear the logs routinely when running the fuzzers.",
    )
    return parser.parse_args()


def run_redis_fuzzers():
    args = parse_args()
    check_paths(
        [
            args.sync_dir,
            args.seed_dir,
            args.corpus_dir,
        ],
        check_dir=True,
    )

    check_paths(
        [
            args.aflpp_custom_mutator_path,
            args.redis_frontend_path,
            args.mutator_config,
        ]
    )

    build_image(args.redis_version)
    img_name = DOCKER_IMG_NAME

    run_cmd(f"docker stop {args.container_name}", False)
    run_cmd(f"docker rm -f {args.container_name}", False)

    if args.cpuset is None:
        run_cmd(
            f"docker run --tmpfs /tmp -v /etc/localtime:/etc/localtime -v /etc/timezone:/etc/timezone:ro -v {REPO_ROOT}:/repo_root -v {args.sync_dir}:/sync_dir -v {args.seed_dir}:/seed_dir -v {args.corpus_dir}:/corpus_dir -it -d --name {args.container_name} {img_name} bash"
        )
    else:
        run_cmd(
            f"docker run --tmpfs /tmp --cpuset-cpus={args.cpuset} -v /etc/localtime:/etc/localtime -v /etc/timezone:/etc/timezone:ro -v {REPO_ROOT}:/repo_root -v {args.sync_dir}:/sync_dir -v {args.seed_dir}:/seed_dir -v {args.corpus_dir}:/corpus_dir -it -d --name {args.container_name} {img_name} bash"
        )

    run_cmd(f"docker cp {args.mutator_config} {args.container_name}:/config.yml")

    spawn_fuzzers(
        args.aflpp_custom_mutator_path,
        args.redis_frontend_path,
        args.container_name,
        args.num_of_fuzzers,
        args.no_ms,
    )

    run_watch_remove(
        args.container_name, clear_db=args.clear_db, clear_log=args.clear_log
    )


if __name__ == "__main__":
    run_redis_fuzzers()
