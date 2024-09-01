# Annotation

We can give nodes annotations to help maintain the semantics. After the annotation, BuzzBee will try to fix the test case when it discovers semantic errors.

## General Steps

Annotating a node can be done in two steps: tagging the node and annotating the tagged node.

### Tagging the Node

To start, we want to tag the node in the ANTLR4 grammar `<Grammar>.g4`. To tag one node, we should first label the node in the rule and then assign the rule an alternative name.

For example, let's say we want to annotate the semantics of the node `ACL_SP_CAT4` in the following grammar rule:

```
acl_sp_cat3: ACL_SP_CAT4;
```

We can do the following:

```
acl_sp_cat3: elem1=ACL_SP_CAT4 #Rule1;
```

This tags the node `ACL_SP_CAT4` with `Rule1->elem1`.

### Annotating the Tagged Node

Next, we can write the annotations in `<Grammar>.json` for the node we just tagged:
   
```json5
{
    "annotations": {
        // the annotation entries
        "Rule1->elem1": {
            // actions
        }
    }
}
```

## Annotation Entries

Each annotation entry has the following structure:

```json5
{
    "action_0": {
        "action": <ACTION>,
        "args": {
            <ARGS>
        },
        "ast_context": [] // deprecated
    }
    // ...
}
```

### Action

Action specifies the type of semantics. We currently support the following actions:

- `DefineSymbol`: The tagged node defines a symbol.
- `UseSymbol`: The tagged node uses a symbol.
- `InvalidateSymbol`: The tagged node invalidates a symbol.
- `CreateScope`: The tagged node creates a scope.
- `AlterOrder`: When the tagged node needs to be analyzed after a certain node, instead of following the original AST traversal order, we can use this action to specify the new order.

> Action was referred to as "operation" in the BuzzBee paper for illustration purposes.

### Args

Each action takes its argument(s), which will be explained down below.

**DefineSymbol**

DefineSymbol takes an arg `type`, specifying the type of the symbol to define. For example:

```json5
"args": {
    "type": "list_key"
}
```

**UseSymbol**

UseSymbol takes an arg `type`, specifying the type(s) of the symbol to use. This should be a type that will be defined by a DefineSymbol. For example:

```json5
"args": {
    "type": "list_key"
    // It can also be a list of strings:
    // "type" : ["list_key", "another_key"]
}
```

UseSymbol can also take an arg `type_block`, specifying a list of symbol types that cannot be used.


**InvalidateSymbol**

InvalidateSymbol takes an arg `type`, specifying the type(s) of the symbol to invalidate. This should be a type that will be defined by a DefineSymbol. For example:

```json5
"args": {
    "type": "list_key"
    // It can also be a list of strings:
    // "type" : ["list_key", "another_key"]
}
```

**CreateScope**

CreateScope creates a scope and takes an arg `scope_name`. A (global) scope must exist for every test case before we can perform any symbol analysis within it. Therefore, we need to write a CreateScope rule for at least one tagged node for our target grammar. This is usually a node in the entry point rule. For example:

```json5
"EntryPoint->elem": {
    "action_0": {
        "action": "CreateScope",
        "args": {
            "scope_name": "scope_{@id}" // We used CQL here, which will be explained later
        },
        // ...
    }
}
```

**AlterOrder**

BuzzBee, by default, analyzes the nodes by traversing the AST from top to bottom and left to right. When this appears unsuitable for modeling certain semantics, we can use AlterOrder to change the order in which BuzzBee analyzes certain nodes.

AlterOrder takes an arg `after`, specifying the *id* of the node we want the tagged node to be analyzed after. For example:

```json5
"args": {
    "after": "{.parent.rsib(1).child(0)@id}" // We used CQL here, which will be explained later
}
```

## CQL

Inside the annotation, we can use Context Query Language (CQL) to incorporate context information. The grammar for CQL is defined in [AnnoContext.g4](../src/core/parsers/anno_context/AnnoContext.g4).

Generally speaking, CQL consists of two parts: *navigators* and *properties*. 

Navigators allow us to move to another node in the parsed AST from the tagged node:

- `.parent`: Move to the parent node of the current node.
- `.child(n)`: Move to the n-th child of the current node.
- `.lsib(n)`: Move to the n-th left sibling of the current node.
- `.rsib(n)`: Move to the n-th right sibling of the current node.
- `.parentuntil(node_type)`: Move up in the AST until reaching a node of type `node_type`.

Properties allow us to retrieve a specific property of the node we have navigated to:

- `id`: The ID of the node. Each node has a unique ID.
- `text`: The text (source) of the node.
- ...

Inside the annotation, CQL should be written in the following format:

```
"other_text_{<navigator_0>...<navigator_n>@<property>}"
```

For example:

```
"{.parent.rsib(1).child(0)@id}"
```

This is the annotation shown earlier in AlterOrder, which means:

1. Move to the parent node (node_1) of the tagged node.
2. Move to the right sibling (node_2) of node_1.
3. Move to the first child (node_3) of node_2.
4. Retrieve the ID of node_3.

By using this in AlterOrder, BuzzBee will ensure that the tagged node is analyzed after node_3 during symbol analysis.

## Custom Resolvers

More complex semantics can be modeled using custom resolvers. Currently, the interface to a custom resolver is implemented through two C++ functions: `ResolveValues` and `GetDependencies`. The main function, `ResolveValues`, which takes the argument `ResolveContext ctx` and returns a vector of strings.

For instance:

```cpp
std::vector<std::string> ResolveValues(ResolveContext ctx) {
  auto key = ctx.ir->GetParent().lock()->GetLSib(1);
  
  auto key_type = "hset_key_" + key->ToSource();
  return {
    key_type + "_numtype", 
    key_type + "_strtype"
  };
}
```

ResolveContext is defined in [symbol_analysis.h](../src/core/symbol_analysis.h), giving us the context.


Apart from this, a custom resolver must also include another function `std::vector<ir::IR_PTR> GetDependencies(ir::IR_PTR current_node)`. This function returns the nodes (IRs) on which the current node depends. This ensures that, during symbol analysis, BuzzBee analyzes all dependencies before analyzing the current node.


To use a custom resolver in the annotation, follow these steps:

1. Create a folder named `custom_resolvers` in the same directory as the files <Grammar.g4> and <Grammar.json>.
2. Create a C++ source file named `<your_custom_resolver_name>.cc` inside the `custom_resolvers` folder.
3. Write the functions `GetDependencies` and `ResolveValues` in the C++ source file.
4. In the annotation where you want to use custom resolvers, specify the name of the custom resolver and prefix it with `##`.
 * Currently, for `type` args, you need to provide an additional argument `custom_type` to inform BuzzBee of the possible values returned by the custom resolver, aiding dependency-guided mutation. For example, if a custom resolver can return strings `hset_key_numtype` and `hset_key_strtype`, you should specify `hset_key_?` in `custom_types`. The `?` acts as a wildcard.

Afterward, the vector of strings returned by the `ResolveValues` function will be plugged into the annotation. For example,

```json5
"HGetField->elem,HSetLenField->elem": {
    "0": {
        "action": "UseSymbol",
        "args": {
            "type": "##hget_field_type_resolver",
            "custom_types": [
                "hset_key_?"
            ]
        },
        "ast_context": []
    }
},
```

This example is taken from [Redis.json](../artifacts/input_specs/redis/Redis.json). It directs the semantics resolution rules to the custom resolver `hget_field_type_resolver` implemented in [custom_resolvers/hget_field_type_resolver.cc](../artifacts/input_specs/redis/custom_resolvers/hget_field_type_resolver.cc).

### Selectors

When there are multiple actions for a tagged node, custom resolvers can be used to select the appropriate action based on the context. For example,

```json5
"LiteralRule4->elem": {
    "selector": "##literal_string_selector",
    "def": {
        "action": "DefineSymbol",
        "args": {
            "type": "doc_key"
        },
        // ...
    },
    "use": {
        "action": "UseSymbol",
        "args": {
            "type": "doc_key"
        },
        // ...
    }
}
```

Next, we need to create a custom resolver source file `literal_string_selector.cc` and write a function `std::optional<std::string> Select(ResolveContext ctx)` in it. This function should return the name of the action to select based on ctx, or `std::nullopt` if no action should be selected. In the above example, we should return `"def"` or `"use"` or `std::nullopt` based on ctx.


# Other Configurations

In the current implementation, the annotation file is also used to configure some other parameters (which is not an ideal design, similar to many other parts of this prototype). Therefore, the actual annotation file has the following structure:

```json5
{
    "annotations": {
        // the annotation entries
    },
    "others": {
        // other configurations
    }
}
```

We list some of the configurations down below:

- `token_sep`: The token separator for the target grammar. This is usually a single space `" "`, but can be an empty string `""` for some grammars.
- `replace_boundary_type`: When performing replacement mutations, only nodes under nodes of this type (`replace_boundary_type`) will be replaced.
- `removable_types`: An array that defines the types of nodes that can be deleted during mutation. Each element in the array follows this format: `[ "<removable_type>", ["<to_strip_type0>", "<to_strip_type1>"] ]`, which means:
  - Nodes of type `<removable_type>` can be removed during mutation;
  - After removing nodes of type `<removable_type>`, also remove any subsequent nodes of types `<to_strip_type0>` or `<to_strip_type1>`.
- `insertable_types`: An array that defines the types of nodes that can be inserted during mutation. Each element in the array follows this format: `["<location_type>", "<target_type>", "<before_or_after>", "<sep>"]`, which means:
  - Nodes of type `<target_type>` can be inserted before or after (`<before_or_after>` can be "before" or "after") nodes of type `<location_type>`.
  - After insertion, use `<sep>` to join the inserted node with the test case.
  - `expose_types`: Lists certain node (IR) types that need to be referred to in the custom resolvers or tests. For example, by listing `"expose_type": ["prog"]`, a function `uint64_t GetProgType()` will be generated in the frontend, returning the IR type corresponding to the `prog` node. This function can then be used in custom resolvers or tests as needed.

# Examples

For more details, we provide the following examples related to Redis:
- [Redis.g4](../artifacts/input_specs/redis/Redis.g4): A tagged grammar file.
- [Redis.json](../artifacts/input_specs/redis/Redis.json): Some annotations for the tagged nodes and some other configurations.
- [custom_resolvers](../artifacts/input_specs/redis/custom_resolvers): Some custom resolvers used in the annotations.
- [tests](../tests): This directory includes tests that interact with the annotation system, which might help in understanding the internals.