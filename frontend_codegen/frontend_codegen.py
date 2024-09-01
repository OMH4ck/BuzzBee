#!python3
import fire
import os
import json
import re
import subprocess
from string import ascii_uppercase

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))


def check_labels_defined_in_grammar(grammar_file, spec_file):
    """Check that the labels in the annotations are defined in the g4 file."""
    specs = get_preprocessed_specs_from_file(spec_file)
    with open(grammar_file, "r") as f:
        grammar_lines = f.readlines()

    labeled_nodes = set()
    alt_rulenames = set()  # ensure uniq rulenames

    for i, line in enumerate(grammar_lines):
        labels = re.findall(" (\w+)=", line)
        line = line.strip()

        if labels:
            rulename_m = re.findall("# *(\w+)", line)
            if not rulename_m:
                if "tokenVocab" in labels:
                    continue
                raise Exception(
                    f"Line {i}: Labels {labels} defined but an alternative rulename not found."
                )
            rulename = rulename_m[0]

            if rulename in alt_rulenames:
                raise Exception(
                    f"Multiple definition found for rulename {rulename} in {grammar_file}"
                )
            alt_rulenames.add(rulename)

            if rulename[0] not in ascii_uppercase:
                # ANTLR4 doesn't distinguish lower/upper case prefixed alt names, so we enforce them to be upper case prefixed
                raise Exception(
                    f"Rulename `{rulename}` defined in {grammar_file} not starting with an uppercase letter."
                )

            for each in labels:
                labeled_node = f"{rulename}->{each}"
                if labeled_node in labeled_nodes:
                    raise Exception(
                        f"Multiple definition found for `{labeled_node}` in {grammar_file}"
                    )
                labeled_nodes.add(labeled_node)

    defined_nodes = set()
    for anno in specs["annotations"]:
        for each in anno.split(","):
            if each not in labeled_nodes:
                raise Exception(
                    f"{each} is defined in {spec_file} but not labeled in {grammar_file}"
                )
            defined_nodes.add(each)

    undefined_nodes = labeled_nodes - defined_nodes
    if undefined_nodes:
        print(
            f"Some nodes are labeled in {grammar_file} but do not have a defined annotation:"
        )
        for each in undefined_nodes:
            print(each)


def process_spec_file(spec_file, debug=False):
    """Returns: ( AnnotationCollector's code, sym_info, others)"""
    specs = get_preprocessed_specs_from_file(spec_file)

    grammar_name = os.path.basename(spec_file).split(".json")[0]
    gn = grammar_name

    header_src = f"class {gn}AnnotationListener : public {gn}BaseListener " + "{\n"
    header_src += " public:\n"

    rulename_label_annotation = dict()

    annotations = specs["annotations"]

    for markers in annotations:
        for marker in markers.split(
            ","
        ):  # allow multiple markers to share the same annotation
            rulename, label = marker.split("->")
            if rulename not in rulename_label_annotation:
                rulename_label_annotation[rulename] = {label: annotations[markers]}
            else:
                rulename_label_annotation[rulename][label] = annotations[markers]

    # sym_info, used for the guided mutation
    type_def_use_info_dict = {
    }

    all_ok_action_types_and_rulename_labels = []
    for rulename, v in rulename_label_annotation.items():
        header_src += (
            f"  virtual void enter{rulename}({gn}Parser::{rulename}Context *ctx /*ctx*/) override "
            + "{\n"
        )
        for label, anno in v.items():
            header_src += f"""    tagged_rules_[ctx->{label}] = {{ "{rulename}->{label}", R"({json.dumps(anno)})" }};\n"""
            print(f"{rulename}->{label}", json.dumps(anno))

            for option, action_content in anno.items():
                if option == "selector":
                    continue
                if action_content["action"] in [
                    "UseSymbol",
                    "InvalidateSymbol",
                    "DefineSymbol",
                ]:
                    args = action_content["args"]
                    if "type" in args:
                        if type(args["type"]) is list:
                            type_list = args["type"]
                        else:
                            type_list = args["custom_types"]
                    else:
                        type_list = None
                        all_ok_action_types_and_rulename_labels.append(
                            (action_content["action"], rulename, label)
                        )
                else:
                    continue

                if type_list:
                    for each_type in type_list:
                        # print(each_type)
                        each_type = to_canonical_(each_type)
                        if each_type not in type_def_use_info_dict:
                            type_def_use_info_dict[each_type] = {
                                "DefineSymbol": set(),
                                "UseSymbol": set(),
                                "InvalidateSymbol": set(),
                            }
                        type_def_use_info_dict[each_type][action_content["action"]].add(
                            f"{rulename}->{label}->{option}"
                        )
        header_src += "  }\n"

    for action_type, rulename, label in all_ok_action_types_and_rulename_labels:
        for each in type_def_use_info_dict:
            type_def_use_info_dict[each][action_type].add(f"{rulename}->{label}")

    # transform to list
    for k, v in type_def_use_info_dict.items():
        for a, vv in v.items():
            type_def_use_info_dict[k][a] = list(vv)

    header_src += "  absl::flat_hash_map<void *, std::pair<std::string, std::string>> tagged_rules_;\n};"

    syminfo = str(type_def_use_info_dict).replace("'", '"')
    others = specs["others"]

    header_src = header_src.replace("ParserParser", "Parser")

    return (
        header_src,
        syminfo,
        others,
        get_custom_handler_info(
            specs, os.path.dirname(spec_file) + "/custom_resolvers"
        ),
    )

def to_canonical_(anno: str):
    # '?' will not be used in the annotation so we just use it as a placeholder
    return re.sub(r"\{.*?\}", "?", anno).replace("NBANY", "?")


def can_anno_pattern_describe_(anno_pattern: str, real_anno: str):
    """Tests if the annotation pattern can describe real_anno.
    For example, anno_pattern="group_{@text}_1" can describe "group_abc_1"
    """
    return bool(re.compile(re.sub(r"\{.*?\}", ".*", anno_pattern)).fullmatch(real_anno))


def can_cannonical_anno_pattern_describe_(anno_pattern: str, real_anno: str):
    return bool(re.compile(anno_pattern.replace("?", ".*")).fullmatch(real_anno))


def annotation_equal_(anno1: str, anno2: str):
    """Returns if two annotations are symbolically equal to each other.
    This is used to construct the data dependency graph.

    Two annotations are considered symbolically equal if `{}` matches `{}`, and any other characters must match exactly.
    For example, "abc{.lsib(1)@text}" symbolically equals "abc{.rsib(1)@text}"
    """
    return to_canonical_(anno1) == to_canonical_(anno2)


def get_preprocessed_specs_from_file(spec_file):
    with open(spec_file, "r") as f:
        specs = json.load(f)
    annotations = specs["annotations"]
    for labels, actions in annotations.items():
        existing_ast_contexts = set()
        has_selector = False
        for idx, action_content in actions.items():
            if idx == "selector":
                has_selector = True
                continue
            # sanity check for dup ast_contexts
            if not has_selector:
                assert (
                    ",".join(action_content["ast_context"]) not in existing_ast_contexts
                )
            existing_ast_contexts.add(",".join(action_content["ast_context"]))

            action_args = action_content["args"]
            if "type" in action_args and type(action_args["type"]) is not list:
                if action_args["type"].startswith("##"):
                    if "custom_types" not in action_args:
                        raise Exception(
                            f"{action_args['type']} does not provide custom_types."
                        )
                    if type(action_args["custom_types"]) is not list:
                        specs["annotations"][labels][idx]["args"]["custom_types"] = [
                            action_args["custom_types"]
                        ]
                else:
                    specs["annotations"][labels][idx]["args"]["type"] = [
                        action_args["type"]
                    ]
            if "after" in action_args and type(action_args["after"]) is not list:
                specs["annotations"][labels][idx]["args"]["after"] = [
                    action_args["after"]
                ]
    return specs


def get_custom_handler_info(specs, handler_dir):
    """Roughly go over the annotation file and parse all values starting with ## as a custom handler."""

    def extract_all(json_obj):
        values = []

        def extract(obj):
            if isinstance(obj, dict):
                for key, value in obj.items():
                    values.append(key)
                    extract(value)
            elif isinstance(obj, list):
                for item in obj:
                    extract(item)
            else:
                values.append(obj)

        extract(json_obj)
        return values

    annotations = specs["annotations"]

    used_custom_handlers = [
        each[2:] for each in extract_all(annotations) if each.startswith("##")
    ]

    used_custom_handlers = set(used_custom_handlers)

    result = []
    for each in used_custom_handlers:
        handler_src_filename = os.path.join(handler_dir, f"{each}.cc")
        if not os.path.exists(handler_src_filename):
            raise Exception(
                f"The custom handler '{each}' is defined but the source {handler_src_filename} cannot be found."
            )
        with open(handler_src_filename, "r") as f:
            handler_src_content = f.read()

        handler_src_content = handler_src_content.replace(
            "GetDependencies", "GetDependencies_" + each
        )
        handler_src_content = handler_src_content.replace(
            "ResolveValues", "ResolveValues_" + each
        )
        handler_src_content = handler_src_content.replace("Select", "Select_" + each)
        result.append([each, handler_src_content])

    return result


def gen_frontend(
    Grammar_name,
    syminfo,
    candidate_map_info,
    others,
    custom_handler_info,
    frontend_cc_out,
    frontend_h_out,
):
    def wrap_rule(rulename):
        if rulename == "kAnyType":
            return "mutator::kAnyType"
        if rulename[0].upper() == rulename[0]:
            return f"AsTerminal({Grammar_name}Parser::{rulename})"
        else:
            rulename = rulename[0].upper() + rulename[1:]
            return f"AsRule({Grammar_name}Parser::Rule{rulename})"

    with open(SCRIPT_PATH + "/template_frontend.cc", "r") as f:
        cc_template = f.read()

    grammar_name = Grammar_name.lower()

    cc_template = cc_template.replace("##Grammar##", Grammar_name)
    cc_template = cc_template.replace("##grammar##", grammar_name)
    cc_template = cc_template.replace(
        "##ReturnRawSymInfoPlaceholder##", f'return R"( {syminfo} )";'
    )
    cc_template = cc_template.replace(
        "##ReplaceBoundary##", wrap_rule(others["replace_boundary_type"])
    )

    # weight map
    if "weight_map" in others:
        weight_map_content_list = []
        for rulename, weight in others["weight_map"].items():
            weight_map_content_list.append(f"{{ {wrap_rule(rulename)}, {weight}}}")
        cc_template = cc_template.replace(
            "##WeightMap##", f"{{ {','.join(weight_map_content_list)} }}"
        )
    else:
        cc_template = cc_template.replace("##WeightMap##", "{{mutator::kAnyType, 1}}")

    # insertable types
    insertable_types = others["insertable_types"]
    cc_template = cc_template.replace(
        "##NumInsertableTypes##", str(len(insertable_types))
    )
    insertable_types_str_arr = [
        f"InsertableType {{ {wrap_rule(each[0])}, {wrap_rule(each[1])}, {'true' if each[2] == 'before' else 'false'}, \"{repr(each[3])[1:-1]}\" }}"
        for each in insertable_types
    ]
    insertable_types_str = ",\n".join(insertable_types_str_arr)
    cc_template = cc_template.replace(
        "##InsertableTypesPlaceholder##", insertable_types_str
    )

    # removable types
    removable_types = others["removable_types"]
    cc_template = cc_template.replace(
        "##NumRemovableTypes##", str(len(removable_types))
    )
    removable_types_str_arr = [
        f"RemovableType {{ {wrap_rule(each[0])}, {{ {','.join([wrap_rule(each_strip) for each_strip in each[1]])} }} }}"
        for each in removable_types
    ]
    removable_types_str = ",\n".join(removable_types_str_arr)
    cc_template = cc_template.replace(
        "##RemovableTypesPlaceholder##", removable_types_str
    )

    # mutation candidate types
    mutation_candidate_map_arr = []
    for rule, candidates in candidate_map_info.items():
        candidates_joined_str = ",".join([f'"{each}"' for each in candidates])
        mutation_candidate_map_arr.append(
            "{" + f"{wrap_rule(rule)}, {{ {candidates_joined_str} }}" + "}"
        )
    cc_template = cc_template.replace(
        "##GetMutationCandidateMapPlaceHolder##", ",".join(mutation_candidate_map_arr)
    )

    # expose types
    expose_func_template = """
uint64_t Get##Rulename##Type() {
    return ##WrappedRulename##;
}
"""
    expose_types_str_arr = [
        expose_func_template.replace(
            "##Rulename##", each[0].upper() + each[1:]
        ).replace("##WrappedRulename##", wrap_rule(each))
        for each in others["expose_types"]
    ]
    expose_types_str = "\n".join(expose_types_str_arr)
    cc_template = cc_template.replace(
        "##ExposeRuleTypeAPIPlaceholder##", expose_types_str
    )

    # custom action selectors
    handlers_str = "\n\n".join(
        [each[1] for each in custom_handler_info if each[0].endswith("selector")]
    )
    cc_template = cc_template.replace(
        "##CustomActionSelectorPlaceholder##", handlers_str
    )

    handlers_map_str = ",\n".join(
        [
            f'{{ "{each[0]}", CustomActionSelectorCallback {{ GetDependencies_{each[0]}, Select_{each[0]} }} }}'
            for each in custom_handler_info
            if each[0].endswith("selector")
        ]
    )
    cc_template = cc_template.replace(
        "##CustomActionSelectorMapPlaceholder##", handlers_map_str
    )

    # custom handlers
    handlers_str = "\n\n".join(
        [each[1] for each in custom_handler_info if each[0].endswith("resolver")]
    )
    cc_template = cc_template.replace(
        "##CustomTypeResolversPlaceholder##", handlers_str
    )

    handlers_map_str = ",\n".join(
        [
            f'{{ "{each[0]}", CustomResolverCallbacks {{ GetDependencies_{each[0]}, ResolveValues_{each[0]} }} }}'
            for each in custom_handler_info
            if each[0].endswith("resolver")
        ]
    )
    cc_template = cc_template.replace(
        "##CustomTypeResolversMapPlaceholder##", handlers_map_str
    )

    # Move globals
    globals_str = ""
    split1 = cc_template.split("GLOBALS_START")[1:]
    split2 = [each.split("GLOBALS_END")[0] for each in split1]

    globals_str = "\n".join(split2)
    cc_template = cc_template.replace("##GLOBALS##", globals_str)

    # fix for when parser & lexer are split
    cc_template = cc_template.replace("ParserLexer", "Lexer").replace(
        "ParserParser", "Parser"
    )

    with open(frontend_cc_out, "w") as f:
        f.write(cc_template)
        print(f"Generated {frontend_cc_out}")

    # generate the frontend

    with open(SCRIPT_PATH + "/template_frontend.h", "r") as f:
        h_template = f.read()

    h_template = h_template.replace("##Grammar##", Grammar_name)
    h_template = h_template.replace("##grammar##", grammar_name)

    # expose type definitions
    expose_func_template = """
uint64_t Get##Rulename##Type();
"""
    expose_types_str_arr = [
        expose_func_template.replace("##Rulename##", each[0].upper() + each[1:])
        for each in others["expose_types"]
    ]
    expose_types_str = "\n".join(expose_types_str_arr)
    h_template = h_template.replace(
        "##ExposeRuleTypeAPIDeclPlaceholder##", expose_types_str
    )

    h_template = h_template.replace(
        "##TokenSepPlaceHolder##", '"' + others["token_sep"] + '"'
    )

    with open(frontend_h_out, "w") as f:
        f.write(h_template)
        print(f"Generated {frontend_h_out}")


def gen_bazel_build(grammar_name, output_dir):
    with open(SCRIPT_PATH + "/template_bazel_BUILD", "r") as f:
        BUILD_template = f.read().replace("##grammar##", grammar_name.lower())
    with open(output_dir + "/BUILD", "w") as f:
        f.write(BUILD_template)


def codegen(grammar_file, output_dir, annotation_file, lexer_file=""):
    grammar_name = os.path.basename(grammar_file).split(".g4")[0].lower()
    output_dir = output_dir + "/" + grammar_name + "_frontend"
    print(output_dir)
    subprocess.run(f"mkdir -p {output_dir}", shell=True, check=False)
    print("Building parsers using ANTLR4...")
    antlr4_build_parser(grammar_file, lexer_file, output_dir)
    print("Generating frontend...")
    process_annotation(grammar_file, lexer_file, annotation_file, output_dir)
    print("Generating Bazel BUILD file...")
    gen_bazel_build(grammar_name, output_dir)


def antlr4_build_parser(grammar_file, lexer_file, output_dir):
    cmd = f'(! java -Xmx500M -cp "/usr/local/lib/antlr-4.11.1-complete.jar:/usr/local/lib/" org.antlr.v4.Tool -Dlanguage=Cpp -o {output_dir} {grammar_file} {lexer_file} -Xexact-output-dir | grep "error")'
    print(cmd)
    ret = subprocess.run(cmd, shell=True, check=True, stderr=subprocess.PIPE).stderr
    if b"error" in ret:
        raise Exception(f"Failed to generate antlr4 parser:\n{ret}")


def process_annotation(grammar_file, lexer_file, spec_file, output_dir):
    """Performs some sanity checks and generates the source `AnnotationCollector.h`.

    The JSON annotations for each labeled node are transformed into strings first.
    The frontend should later parse it back to JSON.
    This is to avoid dependency issues when building the ANTLR4 generated files.
    """
    assert os.path.exists(grammar_file)
    assert os.path.exists(spec_file)

    grammar_name = os.path.basename(grammar_file).split(".g4")[0]
    spec_name = os.path.basename(spec_file)

    annotation_collector_header_out = (
        output_dir + f"/{grammar_name}AnnotationCollector.h"
    )
    frontend_cc_out = output_dir + f"/{grammar_name.lower()}_frontend.cc"
    frontend_h_out = output_dir + f"/{grammar_name.lower()}_frontend.h"

    if spec_name != f"{grammar_name}.json":
        print(
            f"Warning: Spec filename not coherent with the grammar filename: '{grammar_name}.json' != '{spec_name}'"
        )

    check_labels_defined_in_grammar(grammar_file, spec_file)

    header_src, syminfo, others, custom_handler_info = process_spec_file(spec_file)

    candidate_map_info = {}

    with open(annotation_collector_header_out, "w") as f:
        f.write(header_src)
        print(f"Generated {annotation_collector_header_out}")

    gen_frontend(
        grammar_name,
        syminfo,
        candidate_map_info,
        others,
        custom_handler_info,
        frontend_cc_out,
        frontend_h_out,
    )


if __name__ == "__main__":
    fire.Fire(codegen)
