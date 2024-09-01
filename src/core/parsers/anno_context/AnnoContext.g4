grammar AnnoContext;

node_property: '@id' # NodePropertyID
    | '@text' # NodePropertyText
    | '@sym_use_type' # NodePropertySymUseType
    | '@sym_def_type' # NodePropertySymDefType
    | '@sym_inval_type' # NodePropertySymInvalType
    | '@term_num' # NodePropertyTermNum
    | '@node_num' '(' nodetype=IDENT ')' # NodePropertyNodeNum
    ;

pointer: '.parent' # PointerParent
    | '.child' '(' idx=INTEGER ')' # PointerChild
    | '.lsib' '(' offset=INTEGER ')' # PointerLSib
    | '.rsib' '(' offset=INTEGER ')' # PointerRSib
    | '.parentuntil' '(' nodetype=IDENT ')' # PointerParentUntil
    ;

term: '{' pointer* node_property '}' # Dynamic
    | IDENT # Fixed;

context: term+;

entry_point: context EOF;

fragment
NonzeroDigit: [1-9];

fragment
Digit: [0-9];

INTEGER: (NonzeroDigit Digit*) | '0';

IDENT: [a-zA-Z_*][a-zA-Z0-9_*]*;