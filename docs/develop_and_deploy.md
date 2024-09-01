# Develop & Deploy

## Develop

We use bazel to manage the project. To smooth the process, we have included a devcontainer configuration. To use it, simply load the project with vscode's Dev Containers, and the dev environment will be automatically configured. For setting up your own dev environment, please refer to the devcontainer configuration.


### Run Tests

Run the following command from the repo root to run the tests. You need to generate the redis frontend first (mentioned below) to run redis-related tests.

```bash
bazel test //...
```

### Code Formatting

Code formatting is integrated into the bazel tests. To format the code without running other tests, run the following command from the repo root:

```bash
bazel test //tests:format_file
```

## Support a New Target

### Add Your Input Specs

To support a new target, we need to first add the input specs for it. This includes the tagged grammar file `<Grammar>.g4`, the annotation file `<Grammar>.json`, and optionally, the custom resolvers stored under `custom_resolvers`. For how to write the annotations and use the custom resolvers, please refer to [annotation.md](./annotation.md).

### Integrate with Frontend Codegen

Once we have the input specs for the target, we need to use the frontend code generator to generate the frontend for the target:

```bash
python3 frontend_codegen/frontend_codegen.py --grammar_file=/Path/<Garmmar>.g4 --annotation_file=/Path/<Grammar>.json --output_dir=src/frontends/<grammar>/
```

This will generate the frontend that handles test case parsing for your target under `src/frontends/<grammar>/`.

### Build

After frontend codegen, go to the root of the repo and build the whole source using bazel:

```bash
bazel build //...
```

Afterward, we need the following two files from the built artifacts:

- `bazel-bin/src/aflpp_custom_mutators/generic_mutator/libaflpp_mutator.so`: The AFL++ custom mutator that bridges BuzzBee with AFL++.
- `bazel-bin/src/frontends/<grammar>/<grammar>_frontend/lib{grammar}_frontend_dyn.so`: This will be the frontend library that BuzzBee will use for your target.

### Oneshot Build

As another option, when you have the input specs, you can skip the later steps by using a [script](../scripts/build_utils/oneshot.py) that builds everything in one go inside the devcontainer and copies the two required files to the host. To do this, ensure `docker` is available and then run the following command on your host: 

```bash
mkdir build
python3 ./scripts/build_utils/oneshot.py --grammar artifacts/input_specs/redis/Redis.g4 --annotation artifacts/input_specs/redis/Redis.json --output=./build
```

This will generate two files `aflpp_custom_mutator.so`  and `<grammar>_frontend.so` under `./build`.

## Deploy

To deploy BuzzBee, follow these general steps:

- Develop a harness capable of accessing the functionalities of your target DBMS. This will vary depending on the DBMS you are working with. An efficient harness will result in faster fuzzing speeds and improved fuzzing performance.
- Develop an AFL++ custom mutator (or your own harness driver!) and integrate it with BuzzBee's mutator to support your harness. Load the mutator config, and then use the `Mutate` function to mutate the test cases.
- Run AFL++ with the custom mutator (or your own harness driver) on your harness.

For demonstration purposes, we've included a setup for Redis:

- A preeny-based redis-server harness that can be fuzzed by AFL++. Please refer to [redis_aflpp.dockerfile](../scripts/fuzzer_runner/redis/redis_aflpp.dockerfile) for the setup.
- [aflpp_mutator.cc](../src/aflpp_custom_mutators/generic_mutator/aflpp_mutator.cc): The AFL++ custom mutator that integrates with BuzzBee's mutator.
- [redis.config](../artifacts/configs/redis/redis.config): One mutator config that can be used.

### Mutator Config

The mutator config is a YAML file that configures certain parameters of the mutator:

- MUTATOR_INIT_CORPUS: An initial corpus to load into the mutator. The corpus contains the initial mutation candidates. It is *not* the seed for fuzzing, which should be configured through `afl-fuzz`'s CLI argument.
- FRONTEND_PATH: Path to the frontend library.
- USE_SEMANTIC: Whether to perform semantics analysis and fix the semantic errors. When set to `false`, BuzzBee will not analyze the semantics of the test cases or try to fix the semantic errors, which can be beneficial for discovering parser bugs that do not require semantic correctness.
- DROP_SEMANTIC_INVALID: When set to `false`, BuzzBee will try to keep the semantic invalid test cases in the fuzzing queue.

## Example

We have included a complete setup that allows you to build and run fuzzers against redis-server in docker containers. Please go to the repo root and try it out:

```bash
# First, build the frontend and the custom mutator
mkdir build
python3 ./scripts/build_utils/oneshot.py --grammar ./artifacts/input_specs/redis/Redis.g4 --annotation ./artifacts/input_specs/redis/Redis.json --output=./build

# Second, run the fuzzers against redis-server
mkdir /tmp/sync_dir
python3 ./scripts/fuzzer_runner/redis/run_fuzzers.py --redis_version="7.0.7" --num_of_fuzzers=20 --sync_dir /tmp/sync_dir --seed_dir ./artifacts/seeds/redis --corpus_dir ./artifacts/corpuses/redis --aflpp_custom_mutator_path ./build/aflpp_custom_mutator.so --redis_frontend_path ./build/redis_frontend.so --mutator_config ./artifacts/configs/redis/redis.config --container_name "redis_fuzz"
```

This will spawn 20 fuzzers to fuzz redis-server v7.0.7 with the provided corpus and seed.