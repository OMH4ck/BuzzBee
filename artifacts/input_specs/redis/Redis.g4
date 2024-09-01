grammar Redis;

// ACL CAT [categoryname]
acl_sp_cat: acl_sp_cat0;
acl_sp_cat1: ACL_SP_CAT2;
ACL_SP_CAT2: 'acl';
acl_sp_cat3: ACL_SP_CAT4;
ACL_SP_CAT4: 'cat';
acl_sp_cat7: categoryname;
acl_sp_cat6: acl_sp_cat7;
acl_sp_cat5: acl_sp_cat6 | ;
acl_sp_cat0: acl_sp_cat1 acl_sp_cat3 acl_sp_cat5;

// ACL DELUSER username [username ...]
acl_sp_deluser: acl_sp_deluser0;
acl_sp_deluser1: ACL_SP_CAT2;
acl_sp_deluser2: ACL_SP_DELUSER3;
ACL_SP_DELUSER3: 'deluser';
acl_sp_deluser4: username;
acl_sp_deluser7: username;
acl_sp_deluser6: acl_sp_deluser7;
acl_sp_deluser5: acl_sp_deluser6 | acl_sp_deluser5 acl_sp_deluser6 | ;
acl_sp_deluser0: acl_sp_deluser1 acl_sp_deluser2 acl_sp_deluser4 acl_sp_deluser5;

// ACL DRYRUN username command_arg
acl_sp_dryrun: acl_sp_dryrun0;
acl_sp_dryrun1: ACL_SP_CAT2;
acl_sp_dryrun2: ACL_SP_DRYRUN3;
ACL_SP_DRYRUN3: 'dryrun';
acl_sp_dryrun4: username;
acl_sp_dryrun5: command_arg;
acl_sp_dryrun0: acl_sp_dryrun1 acl_sp_dryrun2 acl_sp_dryrun4 acl_sp_dryrun5;

// ACL GENPASS [bits]
acl_sp_genpass: acl_sp_genpass0;
acl_sp_genpass1: ACL_SP_CAT2;
acl_sp_genpass2: ACL_SP_GENPASS3;
ACL_SP_GENPASS3: 'genpass';
acl_sp_genpass6: bits;
acl_sp_genpass5: acl_sp_genpass6;
acl_sp_genpass4: acl_sp_genpass5 | ;
acl_sp_genpass0: acl_sp_genpass1 acl_sp_genpass2 acl_sp_genpass4;

// ACL GETUSER username
acl_sp_getuser: acl_sp_getuser0;
acl_sp_getuser1: ACL_SP_CAT2;
acl_sp_getuser2: ACL_SP_GETUSER3;
ACL_SP_GETUSER3: 'getuser';
acl_sp_getuser4: username;
acl_sp_getuser0: acl_sp_getuser1 acl_sp_getuser2 acl_sp_getuser4;

// ACL LIST
acl_sp_list: acl_sp_list0;
acl_sp_list1: ACL_SP_CAT2;
acl_sp_list2: ACL_SP_LIST3;
ACL_SP_LIST3: 'list';
acl_sp_list0: acl_sp_list1 acl_sp_list2;

// ACL LOAD
acl_sp_load: acl_sp_load0;
acl_sp_load1: ACL_SP_CAT2;
acl_sp_load2: ACL_SP_LOAD3;
ACL_SP_LOAD3: 'load';
acl_sp_load0: acl_sp_load1 acl_sp_load2;

// ACL LOG [count | RESET]
acl_sp_log: acl_sp_log0;
acl_sp_log1: ACL_SP_CAT2;
acl_sp_log2: ACL_SP_LOG3;
ACL_SP_LOG3: 'log';
acl_sp_log7: count;
acl_sp_log8: ACL_SP_LOG9;
ACL_SP_LOG9: 'reset';
acl_sp_log6: acl_sp_log7 | acl_sp_log8;
acl_sp_log5: acl_sp_log6;
acl_sp_log4: acl_sp_log5 | ;
acl_sp_log0: acl_sp_log1 acl_sp_log2 acl_sp_log4;

// ACL SAVE
acl_sp_save: acl_sp_save0;
acl_sp_save1: ACL_SP_CAT2;
acl_sp_save2: ACL_SP_SAVE3;
ACL_SP_SAVE3: 'save';
acl_sp_save0: acl_sp_save1 acl_sp_save2;

// ACL SETUSER username [rule [rule ...]]
// acl_sp_setuser: acl_sp_setuser0;
// todo: {'rule'}
/*
acl_sp_setuser1: ACL_SP_CAT2;
acl_sp_setuser2: ACL_SP_SETUSER3;
ACL_SP_SETUSER3: 'setuser';
acl_sp_setuser4: username;
acl_sp_setuser7: acl_sp_setuser8;
acl_sp_setuser8: 'rule.TODO';
acl_sp_setuser11: acl_sp_setuser12;
acl_sp_setuser12: 'rule.TODO';
acl_sp_setuser10: acl_sp_setuser11;
acl_sp_setuser9: acl_sp_setuser10 | acl_sp_setuser9 acl_sp_setuser10 | ;
acl_sp_setuser6: acl_sp_setuser7 acl_sp_setuser9;
acl_sp_setuser5: acl_sp_setuser6 | ;
acl_sp_setuser0: acl_sp_setuser1 acl_sp_setuser2 acl_sp_setuser4 acl_sp_setuser5;

*/
// ACL USERS
acl_sp_users: acl_sp_users0;
acl_sp_users1: ACL_SP_CAT2;
acl_sp_users2: ACL_SP_USERS3;
ACL_SP_USERS3: 'users';
acl_sp_users0: acl_sp_users1 acl_sp_users2;

// ACL WHOAMI
acl_sp_whoami: acl_sp_whoami0;
acl_sp_whoami1: ACL_SP_CAT2;
acl_sp_whoami2: ACL_SP_WHOAMI3;
ACL_SP_WHOAMI3: 'whoami';
acl_sp_whoami0: acl_sp_whoami1 acl_sp_whoami2;

// APPEND key value
append: append0;
append1: APPEND2;
APPEND2: 'append';
append3: elem=key #AppendRule1;
append4: value;
append0: append1 append3 append4;

// ASKING
asking: asking0;
asking1: ASKING2;
ASKING2: 'asking';
asking0: asking1;

// AUTH [username] password
auth: auth0;
auth1: AUTH2;
AUTH2: 'auth';
auth5: username;
auth4: auth5;
auth3: auth4 | ;
auth6: password;
auth0: auth1 auth3 auth6;

// BF.ADD key item
bf_dot_add: bf_dot_add0;
bf_dot_add1: BF_DOT_ADD2;
BF_DOT_ADD2: 'bf.add';
bf_dot_add3: key;
bf_dot_add4: item;
bf_dot_add0: bf_dot_add1 bf_dot_add3 bf_dot_add4;

// BF.EXISTS key item
bf_dot_exists: bf_dot_exists0;
bf_dot_exists1: BF_DOT_EXISTS2;
BF_DOT_EXISTS2: 'bf.exists';
bf_dot_exists3: key;
bf_dot_exists4: item;
bf_dot_exists0: bf_dot_exists1 bf_dot_exists3 bf_dot_exists4;

// BF.INFO key [CAPACITY | SIZE | FILTERS | ITEMS | EXPANSION]
bf_dot_info: bf_dot_info0;
bf_dot_info1: BF_DOT_INFO2;
BF_DOT_INFO2: 'bf.info';
bf_dot_info3: key;
bf_dot_info10: BF_DOT_INFO11;
BF_DOT_INFO11: 'capacity';
bf_dot_info12: BF_DOT_INFO13;
BF_DOT_INFO13: 'size';
bf_dot_info9: bf_dot_info10 | bf_dot_info12;
bf_dot_info14: BF_DOT_INFO15;
BF_DOT_INFO15: 'filters';
bf_dot_info8: bf_dot_info9 | bf_dot_info14;
bf_dot_info16: BF_DOT_INFO17;
BF_DOT_INFO17: 'items';
bf_dot_info7: bf_dot_info8 | bf_dot_info16;
bf_dot_info18: BF_DOT_INFO19;
BF_DOT_INFO19: 'expansion';
bf_dot_info6: bf_dot_info7 | bf_dot_info18;
bf_dot_info5: bf_dot_info6;
bf_dot_info4: bf_dot_info5 | ;
bf_dot_info0: bf_dot_info1 bf_dot_info3 bf_dot_info4;

// BF.INSERT key [CAPACITY capacity] [ERROR error]   [EXPANSION expansion] [NOCREATE] [NONSCALING] ITEMS item [item   ...]
// bf_dot_insert: bf_dot_insert0;
// todo: {'error', 'expansion'}
/*
bf_dot_insert1: BF_DOT_INSERT2;
BF_DOT_INSERT2: 'bf.insert';
bf_dot_insert3: key;
bf_dot_insert6: BF_DOT_INFO11;
bf_dot_insert7: capacity;
bf_dot_insert5: bf_dot_insert6 bf_dot_insert7;
bf_dot_insert4: bf_dot_insert5 | ;
bf_dot_insert10: BF_DOT_INSERT11;
BF_DOT_INSERT11: 'error';
bf_dot_insert12: bf_dot_insert13;
bf_dot_insert13: 'error.TODO';
bf_dot_insert9: bf_dot_insert10 bf_dot_insert12;
bf_dot_insert8: bf_dot_insert9 | ;
bf_dot_insert16: BF_DOT_INFO19;
bf_dot_insert17: bf_dot_insert18;
bf_dot_insert18: 'expansion.TODO';
bf_dot_insert15: bf_dot_insert16 bf_dot_insert17;
bf_dot_insert14: bf_dot_insert15 | ;
bf_dot_insert21: BF_DOT_INSERT22;
BF_DOT_INSERT22: 'nocreate';
bf_dot_insert20: bf_dot_insert21;
bf_dot_insert19: bf_dot_insert20 | ;
bf_dot_insert25: BF_DOT_INSERT26;
BF_DOT_INSERT26: 'nonscaling';
bf_dot_insert24: bf_dot_insert25;
bf_dot_insert23: bf_dot_insert24 | ;
bf_dot_insert27: BF_DOT_INFO17;
bf_dot_insert28: item;
bf_dot_insert31: item;
bf_dot_insert30: bf_dot_insert31;
bf_dot_insert29: bf_dot_insert30 | bf_dot_insert29 bf_dot_insert30 | ;
bf_dot_insert0: bf_dot_insert1 bf_dot_insert3 bf_dot_insert4 bf_dot_insert8 bf_dot_insert14 bf_dot_insert19 bf_dot_insert23 bf_dot_insert27 bf_dot_insert28 bf_dot_insert29;

*/
// BF.LOADCHUNK key iterator data
// bf_dot_loadchunk: bf_dot_loadchunk0;
// todo: {'iterator', 'data'}
/*
bf_dot_loadchunk1: BF_DOT_LOADCHUNK2;
BF_DOT_LOADCHUNK2: 'bf.loadchunk';
bf_dot_loadchunk3: key;
bf_dot_loadchunk4: bf_dot_loadchunk5;
bf_dot_loadchunk5: 'iterator.TODO';
bf_dot_loadchunk6: bf_dot_loadchunk7;
bf_dot_loadchunk7: 'data.TODO';
bf_dot_loadchunk0: bf_dot_loadchunk1 bf_dot_loadchunk3 bf_dot_loadchunk4 bf_dot_loadchunk6;

*/
// BF.MADD key item [item ...]
bf_dot_madd: bf_dot_madd0;
bf_dot_madd1: BF_DOT_MADD2;
BF_DOT_MADD2: 'bf.madd';
bf_dot_madd3: key;
bf_dot_madd4: item;
bf_dot_madd7: item;
bf_dot_madd6: bf_dot_madd7;
bf_dot_madd5: bf_dot_madd6 | bf_dot_madd5 bf_dot_madd6 | ;
bf_dot_madd0: bf_dot_madd1 bf_dot_madd3 bf_dot_madd4 bf_dot_madd5;

// BF.MEXISTS key item [item ...]
bf_dot_mexists: bf_dot_mexists0;
bf_dot_mexists1: BF_DOT_MEXISTS2;
BF_DOT_MEXISTS2: 'bf.mexists';
bf_dot_mexists3: key;
bf_dot_mexists4: item;
bf_dot_mexists7: item;
bf_dot_mexists6: bf_dot_mexists7;
bf_dot_mexists5: bf_dot_mexists6 | bf_dot_mexists5 bf_dot_mexists6 | ;
bf_dot_mexists0: bf_dot_mexists1 bf_dot_mexists3 bf_dot_mexists4 bf_dot_mexists5;

// BF.RESERVE key error_rate capacity [EXPANSION expansion]   [NONSCALING]
// bf_dot_reserve: bf_dot_reserve0;
// todo: {'expansion'}
/*
bf_dot_reserve1: BF_DOT_RESERVE2;
BF_DOT_RESERVE2: 'bf.reserve';
bf_dot_reserve3: key;
bf_dot_reserve4: error_rate;
bf_dot_reserve5: capacity;
bf_dot_reserve8: BF_DOT_INFO19;
bf_dot_reserve9: bf_dot_reserve10;
bf_dot_reserve10: 'expansion.TODO';
bf_dot_reserve7: bf_dot_reserve8 bf_dot_reserve9;
bf_dot_reserve6: bf_dot_reserve7 | ;
bf_dot_reserve13: BF_DOT_RESERVE14;
BF_DOT_RESERVE14: 'nonscaling';
bf_dot_reserve12: bf_dot_reserve13;
bf_dot_reserve11: bf_dot_reserve12 | ;
bf_dot_reserve0: bf_dot_reserve1 bf_dot_reserve3 bf_dot_reserve4 bf_dot_reserve5 bf_dot_reserve6 bf_dot_reserve11;

*/
// BF.SCANDUMP key iterator
// bf_dot_scandump: bf_dot_scandump0;
// todo: {'iterator'}
/*
bf_dot_scandump1: BF_DOT_SCANDUMP2;
BF_DOT_SCANDUMP2: 'bf.scandump';
bf_dot_scandump3: key;
bf_dot_scandump4: bf_dot_scandump5;
bf_dot_scandump5: 'iterator.TODO';
bf_dot_scandump0: bf_dot_scandump1 bf_dot_scandump3 bf_dot_scandump4;

*/
// BGREWRITEAOF
bgrewriteaof: bgrewriteaof0;
bgrewriteaof1: BGREWRITEAOF2;
BGREWRITEAOF2: 'bgrewriteaof';
bgrewriteaof0: bgrewriteaof1;

// BGSAVE [SCHEDULE]
bgsave: bgsave0;
bgsave1: BGSAVE2;
BGSAVE2: 'bgsave';
bgsave5: BGSAVE6;
BGSAVE6: 'schedule';
bgsave4: bgsave5;
bgsave3: bgsave4 | ;
bgsave0: bgsave1 bgsave3;

// BITCOUNT key [start end [BYTE | BIT]]
bitcount: bitcount0;
bitcount1: BITCOUNT2;
BITCOUNT2: 'bitcount';
bitcount3: key;
bitcount6: start;
bitcount7: end;
bitcount11: BITCOUNT12;
BITCOUNT12: 'byte';
bitcount13: BITCOUNT14;
BITCOUNT14: 'bit';
bitcount10: bitcount11 | bitcount13;
bitcount9: bitcount10;
bitcount8: bitcount9 | ;
bitcount5: bitcount6 bitcount7 bitcount8;
bitcount4: bitcount5 | ;
bitcount0: bitcount1 bitcount3 bitcount4;

// BITFIELD key < <GET encoding offset> | [OVERFLOW <WRAP | SAT | FAIL>]   < <SET encoding offset value> | <INCRBY encoding offset increment> >   [<GET encoding offset> | [OVERFLOW <WRAP | SAT | FAIL>]   < <SET encoding offset value> | <INCRBY encoding offset increment>>   ...]>
bitfield: bitfield0;
bitfield1: BITFIELD2;
BITFIELD2: 'bitfield';
bitfield3: elem=key #BitfieldRule1;
bitfield9: BITFIELD10;
BITFIELD10: 'get';
bitfield11: encoding;
bitfield12: offset;
bitfield8: bitfield9 bitfield11 bitfield12;
bitfield7: bitfield8;
bitfield15: BITFIELD16;
BITFIELD16: 'overflow';
bitfield21: BITFIELD22;
BITFIELD22: 'wrap';
bitfield23: BITFIELD24;
BITFIELD24: 'sat';
bitfield20: bitfield21 | bitfield23;
bitfield25: BITFIELD26;
BITFIELD26: 'fail';
bitfield19: bitfield20 | bitfield25;
bitfield18: bitfield19;
bitfield17: bitfield18;
bitfield14: bitfield15 bitfield17;
bitfield13: bitfield14 | ;
bitfield6: bitfield7 | bitfield13;
bitfield32: BITFIELD33;
BITFIELD33: 'set';
bitfield34: encoding;
bitfield35: offset;
bitfield36: value;
bitfield31: bitfield32 bitfield34 bitfield35 bitfield36;
bitfield30: bitfield31;
bitfield39: BITFIELD40;
BITFIELD40: 'incrby';
bitfield41: encoding;
bitfield42: offset;
bitfield43: increment;
bitfield38: bitfield39 bitfield41 bitfield42 bitfield43;
bitfield37: bitfield38;
bitfield29: bitfield30 | bitfield37;
bitfield28: bitfield29;
bitfield27: bitfield28;
bitfield49: BITFIELD10;
bitfield50: encoding;
bitfield51: offset;
bitfield48: bitfield49 bitfield50 bitfield51;
bitfield47: bitfield48;
bitfield54: BITFIELD16;
bitfield59: BITFIELD22;
bitfield60: BITFIELD24;
bitfield58: bitfield59 | bitfield60;
bitfield61: BITFIELD26;
bitfield57: bitfield58 | bitfield61;
bitfield56: bitfield57;
bitfield55: bitfield56;
bitfield53: bitfield54 bitfield55;
bitfield52: bitfield53 | ;
bitfield46: bitfield47 | bitfield52;
bitfield67: BITFIELD33;
bitfield68: encoding;
bitfield69: offset;
bitfield70: value;
bitfield66: bitfield67 bitfield68 bitfield69 bitfield70;
bitfield65: bitfield66;
bitfield73: BITFIELD40;
bitfield74: encoding;
bitfield75: offset;
bitfield76: increment;
bitfield72: bitfield73 bitfield74 bitfield75 bitfield76;
bitfield71: bitfield72;
bitfield64: bitfield65 | bitfield71;
bitfield63: bitfield64;
bitfield62: bitfield63;
bitfield45: bitfield46 bitfield62;
bitfield44: bitfield45 | bitfield44 bitfield45 | ;
bitfield5: bitfield6 bitfield27 bitfield44;
bitfield4: bitfield5;
bitfield0: bitfield1 bitfield3 bitfield4;

// BITFIELD_RO key GET encoding offset [GET encoding offset ...]
bitfield_ro: bitfield_ro0;
bitfield_ro1: BITFIELD_RO2;
BITFIELD_RO2: 'bitfield_ro';
bitfield_ro3: key;
bitfield_ro4: BITFIELD10;
bitfield_ro5: encoding;
bitfield_ro6: offset;
bitfield_ro9: BITFIELD10;
bitfield_ro10: encoding;
bitfield_ro11: offset;
bitfield_ro8: bitfield_ro9 bitfield_ro10 bitfield_ro11;
bitfield_ro7: bitfield_ro8 | bitfield_ro7 bitfield_ro8 | ;
bitfield_ro0: bitfield_ro1 bitfield_ro3 bitfield_ro4 bitfield_ro5 bitfield_ro6 bitfield_ro7;

// BITOP operation destkey key [key ...]
bitop: bitop0;
bitop1: BITOP2;
BITOP2: 'bitop';
bitop3: operation;
bitop4: elem=destkey #BitopRule0;
bitop5: elem=key #BitopRule1;
bitop8: elem=key #BitopRule2;
bitop7: bitop8;
bitop6: bitop7 | bitop6 bitop7 | ;
bitop0: bitop1 bitop3 bitop4 bitop5 bitop6;

// BITPOS key bit [start [end [BYTE | BIT]]]
bitpos: bitpos0;
bitpos1: BITPOS2;
BITPOS2: 'bitpos';
bitpos3: elem=key #BitPosRule1;
bitpos4: bit;
bitpos7: start;
bitpos10: end;
bitpos14: BITCOUNT12;
bitpos15: BITCOUNT14;
bitpos13: bitpos14 | bitpos15;
bitpos12: bitpos13;
bitpos11: bitpos12 | ;
bitpos9: bitpos10 bitpos11;
bitpos8: bitpos9 | ;
bitpos6: bitpos7 bitpos8;
bitpos5: bitpos6 | ;
bitpos0: bitpos1 bitpos3 bitpos4 bitpos5;

// BLMOVE source destination <LEFT | RIGHT> <LEFT | RIGHT> timeout
blmove: blmove0;
blmove1: BLMOVE2;
BLMOVE2: 'blmove';
blmove3: elem=source #BlMoveRule1;
blmove4: elem=destination #BlMoveRule2;
blmove8: BLMOVE9;
BLMOVE9: 'left';
blmove10: BLMOVE11;
BLMOVE11: 'right';
blmove7: blmove8 | blmove10;
blmove6: blmove7;
blmove5: blmove6;
blmove15: BLMOVE9;
blmove16: BLMOVE11;
blmove14: blmove15 | blmove16;
blmove13: blmove14;
blmove12: blmove13;
blmove17: timeout;
blmove0: blmove1 blmove3 blmove4 blmove5 blmove12 blmove17;

// BLMPOP timeout numkeys key [key ...] <LEFT | RIGHT> [COUNT count]
blmpop: blmpop0;
blmpop1: BLMPOP2;
BLMPOP2: 'blmpop';
blmpop3: timeout;
blmpop4: numkeys;
blmpop5: elem=key #BLMPopRule1;
blmpop8: elem=key #BLMPopRule2;
blmpop7: blmpop8;
blmpop6: blmpop7 | blmpop6 blmpop7 | ;
blmpop12: BLMOVE9;
blmpop13: BLMOVE11;
blmpop11: blmpop12 | blmpop13;
blmpop10: blmpop11;
blmpop9: blmpop10;
blmpop16: BLMPOP17;
BLMPOP17: 'count';
blmpop18: count;
blmpop15: blmpop16 blmpop18;
blmpop14: blmpop15 | ;
blmpop0: blmpop1 blmpop3 blmpop4 blmpop5 blmpop6 blmpop9 blmpop14;

// BLPOP key [key ...] timeout
blpop: blpop0;
blpop1: BLPOP2;
BLPOP2: 'blpop';
blpop3: elem=key #BLPopRule1;
blpop6: elem=key #BLPopRule2;
blpop5: blpop6;
blpop4: blpop5 | blpop4 blpop5 | ;
blpop7: timeout;
blpop0: blpop1 blpop3 blpop4 blpop7;

// BRPOP key [key ...] timeout
brpop: brpop0;
brpop1: BRPOP2;
BRPOP2: 'brpop';
brpop3: elem=key #BRPopRule1;
brpop6: elem=key #BRPopRule2;
brpop5: brpop6;
brpop4: brpop5 | brpop4 brpop5 | ;
brpop7: timeout;
brpop0: brpop1 brpop3 brpop4 brpop7;

// BRPOPLPUSH source destination timeout
brpoplpush: brpoplpush0;
brpoplpush1: BRPOPLPUSH2;
BRPOPLPUSH2: 'brpoplpush';
brpoplpush3: elem=source #BRPopLPushRule1;
brpoplpush4: elem=destination #BRPopLPushRule2;
brpoplpush5: timeout;
brpoplpush0: brpoplpush1 brpoplpush3 brpoplpush4 brpoplpush5;

// BZMPOP timeout numkeys key [key ...] <MIN | MAX> [COUNT count]
bzmpop: bzmpop0;
bzmpop1: BZMPOP2;
BZMPOP2: 'bzmpop';
bzmpop3: timeout;
bzmpop4: numkeys;
bzmpop5: elem=key #BZMPopRule1;
bzmpop8: elem=key #BZMPopRule2;
bzmpop7: bzmpop8;
bzmpop6: bzmpop7 | bzmpop6 bzmpop7 | ;
bzmpop12: BZMPOP13;
BZMPOP13: 'min';
bzmpop14: BZMPOP15;
BZMPOP15: 'max';
bzmpop11: bzmpop12 | bzmpop14;
bzmpop10: bzmpop11;
bzmpop9: bzmpop10;
bzmpop18: BLMPOP17;
bzmpop19: count;
bzmpop17: bzmpop18 bzmpop19;
bzmpop16: bzmpop17 | ;
bzmpop0: bzmpop1 bzmpop3 bzmpop4 bzmpop5 bzmpop6 bzmpop9 bzmpop16;

// BZPOPMAX key [key ...] timeout
bzpopmax: bzpopmax0;
bzpopmax1: BZPOPMAX2;
BZPOPMAX2: 'bzpopmax';
bzpopmax3: elem=key #BZPopMaxRule1;
bzpopmax6: elem=key #BZPopMaxRule2;
bzpopmax5: bzpopmax6;
bzpopmax4: bzpopmax5 | bzpopmax4 bzpopmax5 | ;
bzpopmax7: timeout;
bzpopmax0: bzpopmax1 bzpopmax3 bzpopmax4 bzpopmax7;

// BZPOPMIN key [key ...] timeout
bzpopmin: bzpopmin0;
bzpopmin1: BZPOPMIN2;
BZPOPMIN2: 'bzpopmin';
bzpopmin3: elem=key #BZPopMinRule1;
bzpopmin6: elem=key #BZPopMinRule2;
bzpopmin5: bzpopmin6;
bzpopmin4: bzpopmin5 | bzpopmin4 bzpopmin5 | ;
bzpopmin7: timeout;
bzpopmin0: bzpopmin1 bzpopmin3 bzpopmin4 bzpopmin7;

// CF.ADD key item
cf_dot_add: cf_dot_add0;
cf_dot_add1: CF_DOT_ADD2;
CF_DOT_ADD2: 'cf.add';
cf_dot_add3: key;
cf_dot_add4: item;
cf_dot_add0: cf_dot_add1 cf_dot_add3 cf_dot_add4;

// CF.ADDNX key item
cf_dot_addnx: cf_dot_addnx0;
cf_dot_addnx1: CF_DOT_ADDNX2;
CF_DOT_ADDNX2: 'cf.addnx';
cf_dot_addnx3: key;
cf_dot_addnx4: item;
cf_dot_addnx0: cf_dot_addnx1 cf_dot_addnx3 cf_dot_addnx4;

// CF.COUNT key item
cf_dot_count: cf_dot_count0;
cf_dot_count1: CF_DOT_COUNT2;
CF_DOT_COUNT2: 'cf.count';
cf_dot_count3: key;
cf_dot_count4: item;
cf_dot_count0: cf_dot_count1 cf_dot_count3 cf_dot_count4;

// CF.DEL key item
cf_dot_del: cf_dot_del0;
cf_dot_del1: CF_DOT_DEL2;
CF_DOT_DEL2: 'cf.del';
cf_dot_del3: key;
cf_dot_del4: item;
cf_dot_del0: cf_dot_del1 cf_dot_del3 cf_dot_del4;

// CF.EXISTS key item
cf_dot_exists: cf_dot_exists0;
cf_dot_exists1: CF_DOT_EXISTS2;
CF_DOT_EXISTS2: 'cf.exists';
cf_dot_exists3: key;
cf_dot_exists4: item;
cf_dot_exists0: cf_dot_exists1 cf_dot_exists3 cf_dot_exists4;

// CF.INFO key
cf_dot_info: cf_dot_info0;
cf_dot_info1: CF_DOT_INFO2;
CF_DOT_INFO2: 'cf.info';
cf_dot_info3: key;
cf_dot_info0: cf_dot_info1 cf_dot_info3;

// CF.INSERT key [CAPACITY capacity] [NOCREATE] ITEMS item [item ...]
cf_dot_insert: cf_dot_insert0;
cf_dot_insert1: CF_DOT_INSERT2;
CF_DOT_INSERT2: 'cf.insert';
cf_dot_insert3: key;
cf_dot_insert6: BF_DOT_INFO11;
cf_dot_insert7: capacity;
cf_dot_insert5: cf_dot_insert6 cf_dot_insert7;
cf_dot_insert4: cf_dot_insert5 | ;
cf_dot_insert10: CF_DOT_INSERT11;
CF_DOT_INSERT11: 'nocreate';
cf_dot_insert9: cf_dot_insert10;
cf_dot_insert8: cf_dot_insert9 | ;
cf_dot_insert12: BF_DOT_INFO17;
cf_dot_insert13: item;
cf_dot_insert16: item;
cf_dot_insert15: cf_dot_insert16;
cf_dot_insert14: cf_dot_insert15 | cf_dot_insert14 cf_dot_insert15 | ;
cf_dot_insert0: cf_dot_insert1 cf_dot_insert3 cf_dot_insert4 cf_dot_insert8 cf_dot_insert12 cf_dot_insert13 cf_dot_insert14;

// CF.INSERTNX key [CAPACITY capacity] [NOCREATE] ITEMS item [item ...]
cf_dot_insertnx: cf_dot_insertnx0;
cf_dot_insertnx1: CF_DOT_INSERTNX2;
CF_DOT_INSERTNX2: 'cf.insertnx';
cf_dot_insertnx3: key;
cf_dot_insertnx6: BF_DOT_INFO11;
cf_dot_insertnx7: capacity;
cf_dot_insertnx5: cf_dot_insertnx6 cf_dot_insertnx7;
cf_dot_insertnx4: cf_dot_insertnx5 | ;
cf_dot_insertnx10: CF_DOT_INSERT11;
cf_dot_insertnx9: cf_dot_insertnx10;
cf_dot_insertnx8: cf_dot_insertnx9 | ;
cf_dot_insertnx11: BF_DOT_INFO17;
cf_dot_insertnx12: item;
cf_dot_insertnx15: item;
cf_dot_insertnx14: cf_dot_insertnx15;
cf_dot_insertnx13: cf_dot_insertnx14 | cf_dot_insertnx13 cf_dot_insertnx14 | ;
cf_dot_insertnx0: cf_dot_insertnx1 cf_dot_insertnx3 cf_dot_insertnx4 cf_dot_insertnx8 cf_dot_insertnx11 cf_dot_insertnx12 cf_dot_insertnx13;

// CF.LOADCHUNK key iterator data
// cf_dot_loadchunk: cf_dot_loadchunk0;
// todo: {'iterator', 'data'}
/*
cf_dot_loadchunk1: CF_DOT_LOADCHUNK2;
CF_DOT_LOADCHUNK2: 'cf.loadchunk';
cf_dot_loadchunk3: key;
cf_dot_loadchunk4: cf_dot_loadchunk5;
cf_dot_loadchunk5: 'iterator.TODO';
cf_dot_loadchunk6: cf_dot_loadchunk7;
cf_dot_loadchunk7: 'data.TODO';
cf_dot_loadchunk0: cf_dot_loadchunk1 cf_dot_loadchunk3 cf_dot_loadchunk4 cf_dot_loadchunk6;

*/
// CF.MEXISTS key item [item ...]
cf_dot_mexists: cf_dot_mexists0;
cf_dot_mexists1: CF_DOT_MEXISTS2;
CF_DOT_MEXISTS2: 'cf.mexists';
cf_dot_mexists3: key;
cf_dot_mexists4: item;
cf_dot_mexists7: item;
cf_dot_mexists6: cf_dot_mexists7;
cf_dot_mexists5: cf_dot_mexists6 | cf_dot_mexists5 cf_dot_mexists6 | ;
cf_dot_mexists0: cf_dot_mexists1 cf_dot_mexists3 cf_dot_mexists4 cf_dot_mexists5;

// CF.RESERVE key capacity [BUCKETSIZE bucketsize]   [MAXITERATIONS maxiterations] [EXPANSION expansion]
// cf_dot_reserve: cf_dot_reserve0;
// todo: {'expansion'}
/*
cf_dot_reserve1: CF_DOT_RESERVE2;
CF_DOT_RESERVE2: 'cf.reserve';
cf_dot_reserve3: key;
cf_dot_reserve4: capacity;
cf_dot_reserve7: CF_DOT_RESERVE8;
CF_DOT_RESERVE8: 'bucketsize';
cf_dot_reserve9: bucketsize;
cf_dot_reserve6: cf_dot_reserve7 cf_dot_reserve9;
cf_dot_reserve5: cf_dot_reserve6 | ;
cf_dot_reserve12: CF_DOT_RESERVE13;
CF_DOT_RESERVE13: 'maxiterations';
cf_dot_reserve14: maxiterations;
cf_dot_reserve11: cf_dot_reserve12 cf_dot_reserve14;
cf_dot_reserve10: cf_dot_reserve11 | ;
cf_dot_reserve17: BF_DOT_INFO19;
cf_dot_reserve18: cf_dot_reserve19;
cf_dot_reserve19: 'expansion.TODO';
cf_dot_reserve16: cf_dot_reserve17 cf_dot_reserve18;
cf_dot_reserve15: cf_dot_reserve16 | ;
cf_dot_reserve0: cf_dot_reserve1 cf_dot_reserve3 cf_dot_reserve4 cf_dot_reserve5 cf_dot_reserve10 cf_dot_reserve15;

*/
// CF.SCANDUMP key iterator
// cf_dot_scandump: cf_dot_scandump0;
// todo: {'iterator'}
/*
cf_dot_scandump1: CF_DOT_SCANDUMP2;
CF_DOT_SCANDUMP2: 'cf.scandump';
cf_dot_scandump3: key;
cf_dot_scandump4: cf_dot_scandump5;
cf_dot_scandump5: 'iterator.TODO';
cf_dot_scandump0: cf_dot_scandump1 cf_dot_scandump3 cf_dot_scandump4;

*/
// CLIENT CACHING <YES | NO>
client_sp_caching: client_sp_caching0;
client_sp_caching1: CLIENT_SP_CACHING2;
CLIENT_SP_CACHING2: 'client';
client_sp_caching3: CLIENT_SP_CACHING4;
CLIENT_SP_CACHING4: 'caching';
client_sp_caching8: CLIENT_SP_CACHING9;
CLIENT_SP_CACHING9: 'yes';
client_sp_caching10: CLIENT_SP_CACHING11;
CLIENT_SP_CACHING11: 'no';
client_sp_caching7: client_sp_caching8 | client_sp_caching10;
client_sp_caching6: client_sp_caching7;
client_sp_caching5: client_sp_caching6;
client_sp_caching0: client_sp_caching1 client_sp_caching3 client_sp_caching5;

// CLIENT GETNAME
client_sp_getname: client_sp_getname0;
client_sp_getname1: CLIENT_SP_CACHING2;
client_sp_getname2: CLIENT_SP_GETNAME3;
CLIENT_SP_GETNAME3: 'getname';
client_sp_getname0: client_sp_getname1 client_sp_getname2;

// CLIENT GETREDIR
client_sp_getredir: client_sp_getredir0;
client_sp_getredir1: CLIENT_SP_CACHING2;
client_sp_getredir2: CLIENT_SP_GETREDIR3;
CLIENT_SP_GETREDIR3: 'getredir';
client_sp_getredir0: client_sp_getredir1 client_sp_getredir2;

// CLIENT ID
client_sp_id: client_sp_id0;
client_sp_id1: CLIENT_SP_CACHING2;
client_sp_id2: CLIENT_SP_ID3;
CLIENT_SP_ID3: 'id';
client_sp_id0: client_sp_id1 client_sp_id2;

// CLIENT INFO
client_sp_info: client_sp_info0;
client_sp_info1: CLIENT_SP_CACHING2;
client_sp_info2: CLIENT_SP_INFO3;
CLIENT_SP_INFO3: 'info';
client_sp_info0: client_sp_info1 client_sp_info2;

// CLIENT KILL <ip_port | <[ID client_id] | [TYPE <NORMAL | MASTER |   SLAVE | REPLICA | PUBSUB>] | [USER username] | [ADDR ip_port] |   [LADDR ip_port] | [SKIPME yes/no] [[ID client_id] | [TYPE <NORMAL   | MASTER | SLAVE | REPLICA | PUBSUB>] | [USER username] |   [ADDR ip_port] | [LADDR ip_port] | [SKIPME yes/no] ...]>>
// client_sp_kill: client_sp_kill0;
// Unable to process

// CLIENT LIST [TYPE <NORMAL | MASTER | REPLICA | PUBSUB>]   [ID client_id [client_id ...]]
// client_sp_list: client_sp_list0;
// todo: {'client_id'}
/*
client_sp_list1: CLIENT_SP_CACHING2;
client_sp_list2: ACL_SP_LIST3;
client_sp_list5: CLIENT_SP_LIST6;
CLIENT_SP_LIST6: 'type';
client_sp_list12: CLIENT_SP_LIST13;
CLIENT_SP_LIST13: 'normal';
client_sp_list14: CLIENT_SP_LIST15;
CLIENT_SP_LIST15: 'master';
client_sp_list11: client_sp_list12 | client_sp_list14;
client_sp_list16: CLIENT_SP_LIST17;
CLIENT_SP_LIST17: 'replica';
client_sp_list10: client_sp_list11 | client_sp_list16;
client_sp_list18: CLIENT_SP_LIST19;
CLIENT_SP_LIST19: 'pubsub';
client_sp_list9: client_sp_list10 | client_sp_list18;
client_sp_list8: client_sp_list9;
client_sp_list7: client_sp_list8;
client_sp_list4: client_sp_list5 client_sp_list7;
client_sp_list3: client_sp_list4 | ;
client_sp_list22: CLIENT_SP_ID3;
client_sp_list23: client_sp_list24;
client_sp_list24: 'client_id.TODO';
client_sp_list27: client_sp_list28;
client_sp_list28: 'client_id.TODO';
client_sp_list26: client_sp_list27;
client_sp_list25: client_sp_list26 | client_sp_list25 client_sp_list26 | ;
client_sp_list21: client_sp_list22 client_sp_list23 client_sp_list25;
client_sp_list20: client_sp_list21 | ;
client_sp_list0: client_sp_list1 client_sp_list2 client_sp_list3 client_sp_list20;

*/
// CLIENT NO-EVICT <ON | OFF>
client_sp_no_evict: client_sp_no_evict0;
client_sp_no_evict1: CLIENT_SP_CACHING2;
client_sp_no_evict2: CLIENT_SP_NO_EVICT3;
CLIENT_SP_NO_EVICT3: 'no-evict';
client_sp_no_evict7: CLIENT_SP_NO_EVICT8;
CLIENT_SP_NO_EVICT8: 'on';
client_sp_no_evict9: CLIENT_SP_NO_EVICT10;
CLIENT_SP_NO_EVICT10: 'off';
client_sp_no_evict6: client_sp_no_evict7 | client_sp_no_evict9;
client_sp_no_evict5: client_sp_no_evict6;
client_sp_no_evict4: client_sp_no_evict5;
client_sp_no_evict0: client_sp_no_evict1 client_sp_no_evict2 client_sp_no_evict4;

// CLIENT PAUSE timeout [WRITE | ALL]
client_sp_pause: client_sp_pause0;
client_sp_pause1: CLIENT_SP_CACHING2;
client_sp_pause2: CLIENT_SP_PAUSE3;
CLIENT_SP_PAUSE3: 'pause';
client_sp_pause4: timeout;
client_sp_pause8: CLIENT_SP_PAUSE9;
CLIENT_SP_PAUSE9: 'write';
client_sp_pause10: CLIENT_SP_PAUSE11;
CLIENT_SP_PAUSE11: 'all';
client_sp_pause7: client_sp_pause8 | client_sp_pause10;
client_sp_pause6: client_sp_pause7;
client_sp_pause5: client_sp_pause6 | ;
client_sp_pause0: client_sp_pause1 client_sp_pause2 client_sp_pause4 client_sp_pause5;

// CLIENT REPLY <ON | OFF | SKIP>
client_sp_reply: client_sp_reply0;
client_sp_reply1: CLIENT_SP_CACHING2;
client_sp_reply2: CLIENT_SP_REPLY3;
CLIENT_SP_REPLY3: 'reply';
client_sp_reply8: CLIENT_SP_NO_EVICT8;
client_sp_reply9: CLIENT_SP_NO_EVICT10;
client_sp_reply7: client_sp_reply8 | client_sp_reply9;
client_sp_reply10: CLIENT_SP_REPLY11;
CLIENT_SP_REPLY11: 'skip';
client_sp_reply6: client_sp_reply7 | client_sp_reply10;
client_sp_reply5: client_sp_reply6;
client_sp_reply4: client_sp_reply5;
client_sp_reply0: client_sp_reply1 client_sp_reply2 client_sp_reply4;

// CLIENT SETNAME connection-name
// client_sp_setname: client_sp_setname0;
// todo: {'connection-name'}
/*
client_sp_setname1: CLIENT_SP_CACHING2;
client_sp_setname2: CLIENT_SP_SETNAME3;
CLIENT_SP_SETNAME3: 'setname';
client_sp_setname4: client_sp_setname5;
client_sp_setname5: 'connection-name.TODO';
client_sp_setname0: client_sp_setname1 client_sp_setname2 client_sp_setname4;

*/
// CLIENT TRACKING <ON | OFF> [REDIRECT client_id] [PREFIX prefix   [PREFIX prefix ...]] [BCAST] [OPTIN] [OPTOUT] [NOLOOP]
// client_sp_tracking: client_sp_tracking0;
// todo: {'client_id', 'prefix'}
/*
client_sp_tracking1: CLIENT_SP_CACHING2;
client_sp_tracking2: CLIENT_SP_TRACKING3;
CLIENT_SP_TRACKING3: 'tracking';
client_sp_tracking7: CLIENT_SP_NO_EVICT8;
client_sp_tracking8: CLIENT_SP_NO_EVICT10;
client_sp_tracking6: client_sp_tracking7 | client_sp_tracking8;
client_sp_tracking5: client_sp_tracking6;
client_sp_tracking4: client_sp_tracking5;
client_sp_tracking11: CLIENT_SP_TRACKING12;
CLIENT_SP_TRACKING12: 'redirect';
client_sp_tracking13: client_sp_tracking14;
client_sp_tracking14: 'client_id.TODO';
client_sp_tracking10: client_sp_tracking11 client_sp_tracking13;
client_sp_tracking9: client_sp_tracking10 | ;
client_sp_tracking17: CLIENT_SP_TRACKING18;
CLIENT_SP_TRACKING18: 'prefix';
client_sp_tracking19: client_sp_tracking20;
client_sp_tracking20: 'prefix.TODO';
client_sp_tracking23: CLIENT_SP_TRACKING18;
client_sp_tracking24: client_sp_tracking25;
client_sp_tracking25: 'prefix.TODO';
client_sp_tracking22: client_sp_tracking23 client_sp_tracking24;
client_sp_tracking21: client_sp_tracking22 | client_sp_tracking21 client_sp_tracking22 | ;
client_sp_tracking16: client_sp_tracking17 client_sp_tracking19 client_sp_tracking21;
client_sp_tracking15: client_sp_tracking16 | ;
client_sp_tracking28: CLIENT_SP_TRACKING29;
CLIENT_SP_TRACKING29: 'bcast';
client_sp_tracking27: client_sp_tracking28;
client_sp_tracking26: client_sp_tracking27 | ;
client_sp_tracking32: CLIENT_SP_TRACKING33;
CLIENT_SP_TRACKING33: 'optin';
client_sp_tracking31: client_sp_tracking32;
client_sp_tracking30: client_sp_tracking31 | ;
client_sp_tracking36: CLIENT_SP_TRACKING37;
CLIENT_SP_TRACKING37: 'optout';
client_sp_tracking35: client_sp_tracking36;
client_sp_tracking34: client_sp_tracking35 | ;
client_sp_tracking40: CLIENT_SP_TRACKING41;
CLIENT_SP_TRACKING41: 'noloop';
client_sp_tracking39: client_sp_tracking40;
client_sp_tracking38: client_sp_tracking39 | ;
client_sp_tracking0: client_sp_tracking1 client_sp_tracking2 client_sp_tracking4 client_sp_tracking9 client_sp_tracking15 client_sp_tracking26 client_sp_tracking30 client_sp_tracking34 client_sp_tracking38;

*/
// CLIENT TRACKINGINFO
client_sp_trackinginfo: client_sp_trackinginfo0;
client_sp_trackinginfo1: CLIENT_SP_CACHING2;
client_sp_trackinginfo2: CLIENT_SP_TRACKINGINFO3;
CLIENT_SP_TRACKINGINFO3: 'trackinginfo';
client_sp_trackinginfo0: client_sp_trackinginfo1 client_sp_trackinginfo2;

// CLIENT UNBLOCK client_id [TIMEOUT | ERROR]
// client_sp_unblock: client_sp_unblock0;
// todo: {'client_id'}
/*
client_sp_unblock1: CLIENT_SP_CACHING2;
client_sp_unblock2: CLIENT_SP_UNBLOCK3;
CLIENT_SP_UNBLOCK3: 'unblock';
client_sp_unblock4: client_sp_unblock5;
client_sp_unblock5: 'client_id.TODO';
client_sp_unblock9: CLIENT_SP_UNBLOCK10;
CLIENT_SP_UNBLOCK10: 'timeout';
client_sp_unblock11: CLIENT_SP_UNBLOCK12;
CLIENT_SP_UNBLOCK12: 'error';
client_sp_unblock8: client_sp_unblock9 | client_sp_unblock11;
client_sp_unblock7: client_sp_unblock8;
client_sp_unblock6: client_sp_unblock7 | ;
client_sp_unblock0: client_sp_unblock1 client_sp_unblock2 client_sp_unblock4 client_sp_unblock6;

*/
// CLIENT UNPAUSE
client_sp_unpause: client_sp_unpause0;
client_sp_unpause1: CLIENT_SP_CACHING2;
client_sp_unpause2: CLIENT_SP_UNPAUSE3;
CLIENT_SP_UNPAUSE3: 'unpause';
client_sp_unpause0: client_sp_unpause1 client_sp_unpause2;

// CLUSTER ADDSLOTS slot [slot ...]
// cluster_sp_addslots: cluster_sp_addslots0;
// todo: {'slot'}
/*
cluster_sp_addslots1: CLUSTER_SP_ADDSLOTS2;
CLUSTER_SP_ADDSLOTS2: 'cluster';
cluster_sp_addslots3: CLUSTER_SP_ADDSLOTS4;
CLUSTER_SP_ADDSLOTS4: 'addslots';
cluster_sp_addslots5: cluster_sp_addslots6;
cluster_sp_addslots6: 'slot.TODO';
cluster_sp_addslots9: cluster_sp_addslots10;
cluster_sp_addslots10: 'slot.TODO';
cluster_sp_addslots8: cluster_sp_addslots9;
cluster_sp_addslots7: cluster_sp_addslots8 | cluster_sp_addslots7 cluster_sp_addslots8 | ;
cluster_sp_addslots0: cluster_sp_addslots1 cluster_sp_addslots3 cluster_sp_addslots5 cluster_sp_addslots7;

*/
// CLUSTER ADDSLOTSRANGE start_slot end_slot [start-slot end_slot ...]
// cluster_sp_addslotsrange: cluster_sp_addslotsrange0;
// todo: {'start_slot', 'end_slot', 'start-slot'}
/*
cluster_sp_addslotsrange1: CLUSTER_SP_ADDSLOTSRANGE2;
CLUSTER_SP_ADDSLOTSRANGE2: 'cluster';
cluster_sp_addslotsrange3: CLUSTER_SP_ADDSLOTSRANGE4;
CLUSTER_SP_ADDSLOTSRANGE4: 'addslotsrange';
cluster_sp_addslotsrange5: cluster_sp_addslotsrange6;
cluster_sp_addslotsrange6: 'start_slot.TODO';
cluster_sp_addslotsrange7: cluster_sp_addslotsrange8;
cluster_sp_addslotsrange8: 'end_slot.TODO';
cluster_sp_addslotsrange11: cluster_sp_addslotsrange12;
cluster_sp_addslotsrange12: 'start-slot.TODO';
cluster_sp_addslotsrange13: cluster_sp_addslotsrange14;
cluster_sp_addslotsrange14: 'end_slot.TODO';
cluster_sp_addslotsrange10: cluster_sp_addslotsrange11 cluster_sp_addslotsrange13;
cluster_sp_addslotsrange9: cluster_sp_addslotsrange10 | cluster_sp_addslotsrange9 cluster_sp_addslotsrange10 | ;
cluster_sp_addslotsrange0: cluster_sp_addslotsrange1 cluster_sp_addslotsrange3 cluster_sp_addslotsrange5 cluster_sp_addslotsrange7 cluster_sp_addslotsrange9;

*/
// CLUSTER BUMPEPOCH
cluster_sp_bumpepoch: cluster_sp_bumpepoch0;
cluster_sp_bumpepoch1: CLUSTER_SP_BUMPEPOCH2;
CLUSTER_SP_BUMPEPOCH2: 'cluster';
cluster_sp_bumpepoch3: CLUSTER_SP_BUMPEPOCH4;
CLUSTER_SP_BUMPEPOCH4: 'bumpepoch';
cluster_sp_bumpepoch0: cluster_sp_bumpepoch1 cluster_sp_bumpepoch3;

// CLUSTER COUNT-FAILURE-REPORTS node_id
// cluster_sp_count_failure_reports: cluster_sp_count_failure_reports0;
// todo: {'node_id'}
/*
cluster_sp_count_failure_reports1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_count_failure_reports2: CLUSTER_SP_COUNT_FAILURE_REPORTS3;
CLUSTER_SP_COUNT_FAILURE_REPORTS3: 'count-failure-reports';
cluster_sp_count_failure_reports4: cluster_sp_count_failure_reports5;
cluster_sp_count_failure_reports5: 'node_id.TODO';
cluster_sp_count_failure_reports0: cluster_sp_count_failure_reports1 cluster_sp_count_failure_reports2 cluster_sp_count_failure_reports4;

*/
// CLUSTER COUNTKEYSINSLOT slot
// cluster_sp_countkeysinslot: cluster_sp_countkeysinslot0;
// todo: {'slot'}
/*
cluster_sp_countkeysinslot1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_countkeysinslot2: CLUSTER_SP_COUNTKEYSINSLOT3;
CLUSTER_SP_COUNTKEYSINSLOT3: 'countkeysinslot';
cluster_sp_countkeysinslot4: cluster_sp_countkeysinslot5;
cluster_sp_countkeysinslot5: 'slot.TODO';
cluster_sp_countkeysinslot0: cluster_sp_countkeysinslot1 cluster_sp_countkeysinslot2 cluster_sp_countkeysinslot4;

*/
// CLUSTER DELSLOTS slot [slot ...]
// cluster_sp_delslots: cluster_sp_delslots0;
// todo: {'slot'}
/*
cluster_sp_delslots1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_delslots2: CLUSTER_SP_DELSLOTS3;
CLUSTER_SP_DELSLOTS3: 'delslots';
cluster_sp_delslots4: cluster_sp_delslots5;
cluster_sp_delslots5: 'slot.TODO';
cluster_sp_delslots8: cluster_sp_delslots9;
cluster_sp_delslots9: 'slot.TODO';
cluster_sp_delslots7: cluster_sp_delslots8;
cluster_sp_delslots6: cluster_sp_delslots7 | cluster_sp_delslots6 cluster_sp_delslots7 | ;
cluster_sp_delslots0: cluster_sp_delslots1 cluster_sp_delslots2 cluster_sp_delslots4 cluster_sp_delslots6;

*/
// CLUSTER DELSLOTSRANGE start_slot end_slot [start-slot end_slot ...]
// cluster_sp_delslotsrange: cluster_sp_delslotsrange0;
// todo: {'start_slot', 'end_slot', 'start-slot'}
/*
cluster_sp_delslotsrange1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_delslotsrange2: CLUSTER_SP_DELSLOTSRANGE3;
CLUSTER_SP_DELSLOTSRANGE3: 'delslotsrange';
cluster_sp_delslotsrange4: cluster_sp_delslotsrange5;
cluster_sp_delslotsrange5: 'start_slot.TODO';
cluster_sp_delslotsrange6: cluster_sp_delslotsrange7;
cluster_sp_delslotsrange7: 'end_slot.TODO';
cluster_sp_delslotsrange10: cluster_sp_delslotsrange11;
cluster_sp_delslotsrange11: 'start-slot.TODO';
cluster_sp_delslotsrange12: cluster_sp_delslotsrange13;
cluster_sp_delslotsrange13: 'end_slot.TODO';
cluster_sp_delslotsrange9: cluster_sp_delslotsrange10 cluster_sp_delslotsrange12;
cluster_sp_delslotsrange8: cluster_sp_delslotsrange9 | cluster_sp_delslotsrange8 cluster_sp_delslotsrange9 | ;
cluster_sp_delslotsrange0: cluster_sp_delslotsrange1 cluster_sp_delslotsrange2 cluster_sp_delslotsrange4 cluster_sp_delslotsrange6 cluster_sp_delslotsrange8;

*/
// CLUSTER FAILOVER [FORCE | TAKEOVER]
cluster_sp_failover: cluster_sp_failover0;
cluster_sp_failover1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_failover2: CLUSTER_SP_FAILOVER3;
CLUSTER_SP_FAILOVER3: 'failover';
cluster_sp_failover7: CLUSTER_SP_FAILOVER8;
CLUSTER_SP_FAILOVER8: 'force';
cluster_sp_failover9: CLUSTER_SP_FAILOVER10;
CLUSTER_SP_FAILOVER10: 'takeover';
cluster_sp_failover6: cluster_sp_failover7 | cluster_sp_failover9;
cluster_sp_failover5: cluster_sp_failover6;
cluster_sp_failover4: cluster_sp_failover5 | ;
cluster_sp_failover0: cluster_sp_failover1 cluster_sp_failover2 cluster_sp_failover4;

// CLUSTER FLUSHSLOTS
cluster_sp_flushslots: cluster_sp_flushslots0;
cluster_sp_flushslots1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_flushslots2: CLUSTER_SP_FLUSHSLOTS3;
CLUSTER_SP_FLUSHSLOTS3: 'flushslots';
cluster_sp_flushslots0: cluster_sp_flushslots1 cluster_sp_flushslots2;

// CLUSTER FORGET node_id
// cluster_sp_forget: cluster_sp_forget0;
// todo: {'node_id'}
/*
cluster_sp_forget1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_forget2: CLUSTER_SP_FORGET3;
CLUSTER_SP_FORGET3: 'forget';
cluster_sp_forget4: cluster_sp_forget5;
cluster_sp_forget5: 'node_id.TODO';
cluster_sp_forget0: cluster_sp_forget1 cluster_sp_forget2 cluster_sp_forget4;

*/
// CLUSTER GETKEYSINSLOT slot count
// cluster_sp_getkeysinslot: cluster_sp_getkeysinslot0;
// todo: {'slot'}
/*
cluster_sp_getkeysinslot1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_getkeysinslot2: CLUSTER_SP_GETKEYSINSLOT3;
CLUSTER_SP_GETKEYSINSLOT3: 'getkeysinslot';
cluster_sp_getkeysinslot4: cluster_sp_getkeysinslot5;
cluster_sp_getkeysinslot5: 'slot.TODO';
cluster_sp_getkeysinslot6: count;
cluster_sp_getkeysinslot0: cluster_sp_getkeysinslot1 cluster_sp_getkeysinslot2 cluster_sp_getkeysinslot4 cluster_sp_getkeysinslot6;

*/
// CLUSTER INFO
cluster_sp_info: cluster_sp_info0;
cluster_sp_info1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_info2: CLIENT_SP_INFO3;
cluster_sp_info0: cluster_sp_info1 cluster_sp_info2;

// CLUSTER KEYSLOT key
cluster_sp_keyslot: cluster_sp_keyslot0;
cluster_sp_keyslot1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_keyslot2: CLUSTER_SP_KEYSLOT3;
CLUSTER_SP_KEYSLOT3: 'keyslot';
cluster_sp_keyslot4: key;
cluster_sp_keyslot0: cluster_sp_keyslot1 cluster_sp_keyslot2 cluster_sp_keyslot4;

// CLUSTER LINKS
cluster_sp_links: cluster_sp_links0;
cluster_sp_links1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_links2: CLUSTER_SP_LINKS3;
CLUSTER_SP_LINKS3: 'links';
cluster_sp_links0: cluster_sp_links1 cluster_sp_links2;

// CLUSTER MEET ip port [cluster_bus_port]
// cluster_sp_meet: cluster_sp_meet0;
// todo: {'cluster_bus_port'}
/*
cluster_sp_meet1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_meet2: CLUSTER_SP_MEET3;
CLUSTER_SP_MEET3: 'meet';
cluster_sp_meet4: ip;
cluster_sp_meet5: port;
cluster_sp_meet8: cluster_sp_meet9;
cluster_sp_meet9: 'cluster_bus_port.TODO';
cluster_sp_meet7: cluster_sp_meet8;
cluster_sp_meet6: cluster_sp_meet7 | ;
cluster_sp_meet0: cluster_sp_meet1 cluster_sp_meet2 cluster_sp_meet4 cluster_sp_meet5 cluster_sp_meet6;

*/
// CLUSTER MYID
cluster_sp_myid: cluster_sp_myid0;
cluster_sp_myid1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_myid2: CLUSTER_SP_MYID3;
CLUSTER_SP_MYID3: 'myid';
cluster_sp_myid0: cluster_sp_myid1 cluster_sp_myid2;

// CLUSTER NODES
cluster_sp_nodes: cluster_sp_nodes0;
cluster_sp_nodes1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_nodes2: CLUSTER_SP_NODES3;
CLUSTER_SP_NODES3: 'nodes';
cluster_sp_nodes0: cluster_sp_nodes1 cluster_sp_nodes2;

// CLUSTER REPLICAS node_id
// cluster_sp_replicas: cluster_sp_replicas0;
// todo: {'node_id'}
/*
cluster_sp_replicas1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_replicas2: CLUSTER_SP_REPLICAS3;
CLUSTER_SP_REPLICAS3: 'replicas';
cluster_sp_replicas4: cluster_sp_replicas5;
cluster_sp_replicas5: 'node_id.TODO';
cluster_sp_replicas0: cluster_sp_replicas1 cluster_sp_replicas2 cluster_sp_replicas4;

*/
// CLUSTER REPLICATE node_id
// cluster_sp_replicate: cluster_sp_replicate0;
// todo: {'node_id'}
/*
cluster_sp_replicate1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_replicate2: CLUSTER_SP_REPLICATE3;
CLUSTER_SP_REPLICATE3: 'replicate';
cluster_sp_replicate4: cluster_sp_replicate5;
cluster_sp_replicate5: 'node_id.TODO';
cluster_sp_replicate0: cluster_sp_replicate1 cluster_sp_replicate2 cluster_sp_replicate4;

*/
// CLUSTER RESET [HARD | SOFT]
cluster_sp_reset: cluster_sp_reset0;
cluster_sp_reset1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_reset2: ACL_SP_LOG9;
cluster_sp_reset6: CLUSTER_SP_RESET7;
CLUSTER_SP_RESET7: 'hard';
cluster_sp_reset8: CLUSTER_SP_RESET9;
CLUSTER_SP_RESET9: 'soft';
cluster_sp_reset5: cluster_sp_reset6 | cluster_sp_reset8;
cluster_sp_reset4: cluster_sp_reset5;
cluster_sp_reset3: cluster_sp_reset4 | ;
cluster_sp_reset0: cluster_sp_reset1 cluster_sp_reset2 cluster_sp_reset3;

// CLUSTER SAVECONFIG
cluster_sp_saveconfig: cluster_sp_saveconfig0;
cluster_sp_saveconfig1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_saveconfig2: CLUSTER_SP_SAVECONFIG3;
CLUSTER_SP_SAVECONFIG3: 'saveconfig';
cluster_sp_saveconfig0: cluster_sp_saveconfig1 cluster_sp_saveconfig2;

// CLUSTER SET-CONFIG-EPOCH config_epoch
// cluster_sp_set_config_epoch: cluster_sp_set_config_epoch0;
// todo: {'config_epoch'}
/*
cluster_sp_set_config_epoch1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_set_config_epoch2: CLUSTER_SP_SET_CONFIG_EPOCH3;
CLUSTER_SP_SET_CONFIG_EPOCH3: 'set-config-epoch';
cluster_sp_set_config_epoch4: cluster_sp_set_config_epoch5;
cluster_sp_set_config_epoch5: 'config_epoch.TODO';
cluster_sp_set_config_epoch0: cluster_sp_set_config_epoch1 cluster_sp_set_config_epoch2 cluster_sp_set_config_epoch4;

*/
// CLUSTER SETSLOT slot <IMPORTING node_id | MIGRATING node_id |   NODE node_id | STABLE>
// cluster_sp_setslot: cluster_sp_setslot0;
// todo: {'slot', 'node_id'}
/*
cluster_sp_setslot1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_setslot2: CLUSTER_SP_SETSLOT3;
CLUSTER_SP_SETSLOT3: 'setslot';
cluster_sp_setslot4: cluster_sp_setslot5;
cluster_sp_setslot5: 'slot.TODO';
cluster_sp_setslot8: CLUSTER_SP_SETSLOT9;
CLUSTER_SP_SETSLOT9: 'importing';
cluster_sp_setslot11: cluster_sp_setslot12;
cluster_sp_setslot12: 'node_id.TODO';
cluster_sp_setslot13: CLUSTER_SP_SETSLOT14;
CLUSTER_SP_SETSLOT14: 'migrating';
cluster_sp_setslot10: cluster_sp_setslot11 | cluster_sp_setslot13;
cluster_sp_setslot16: cluster_sp_setslot17;
cluster_sp_setslot17: 'node_id.TODO';
cluster_sp_setslot18: CLUSTER_SP_SETSLOT19;
CLUSTER_SP_SETSLOT19: 'node';
cluster_sp_setslot15: cluster_sp_setslot16 | cluster_sp_setslot18;
cluster_sp_setslot21: cluster_sp_setslot22;
cluster_sp_setslot22: 'node_id.TODO';
cluster_sp_setslot23: CLUSTER_SP_SETSLOT24;
CLUSTER_SP_SETSLOT24: 'stable';
cluster_sp_setslot20: cluster_sp_setslot21 | cluster_sp_setslot23;
cluster_sp_setslot7: cluster_sp_setslot8 cluster_sp_setslot10 cluster_sp_setslot15 cluster_sp_setslot20;
cluster_sp_setslot6: cluster_sp_setslot7;
cluster_sp_setslot0: cluster_sp_setslot1 cluster_sp_setslot2 cluster_sp_setslot4 cluster_sp_setslot6;

*/
// CLUSTER SHARDS
cluster_sp_shards: cluster_sp_shards0;
cluster_sp_shards1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_shards2: CLUSTER_SP_SHARDS3;
CLUSTER_SP_SHARDS3: 'shards';
cluster_sp_shards0: cluster_sp_shards1 cluster_sp_shards2;

// CLUSTER SLAVES node_id
// cluster_sp_slaves: cluster_sp_slaves0;
// todo: {'node_id'}
/*
cluster_sp_slaves1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_slaves2: CLUSTER_SP_SLAVES3;
CLUSTER_SP_SLAVES3: 'slaves';
cluster_sp_slaves4: cluster_sp_slaves5;
cluster_sp_slaves5: 'node_id.TODO';
cluster_sp_slaves0: cluster_sp_slaves1 cluster_sp_slaves2 cluster_sp_slaves4;

*/
// CLUSTER SLOTS
cluster_sp_slots: cluster_sp_slots0;
cluster_sp_slots1: CLUSTER_SP_BUMPEPOCH2;
cluster_sp_slots2: CLUSTER_SP_SLOTS3;
CLUSTER_SP_SLOTS3: 'slots';
cluster_sp_slots0: cluster_sp_slots1 cluster_sp_slots2;

// CMS.INCRBY key item increment [item increment ...]
cms_dot_incrby: cms_dot_incrby0;
cms_dot_incrby1: CMS_DOT_INCRBY2;
CMS_DOT_INCRBY2: 'cms.incrby';
cms_dot_incrby3: key;
cms_dot_incrby4: item;
cms_dot_incrby5: increment;
cms_dot_incrby8: item;
cms_dot_incrby9: increment;
cms_dot_incrby7: cms_dot_incrby8 cms_dot_incrby9;
cms_dot_incrby6: cms_dot_incrby7 | cms_dot_incrby6 cms_dot_incrby7 | ;
cms_dot_incrby0: cms_dot_incrby1 cms_dot_incrby3 cms_dot_incrby4 cms_dot_incrby5 cms_dot_incrby6;

// CMS.INFO key
cms_dot_info: cms_dot_info0;
cms_dot_info1: CMS_DOT_INFO2;
CMS_DOT_INFO2: 'cms.info';
cms_dot_info3: key;
cms_dot_info0: cms_dot_info1 cms_dot_info3;

// CMS.INITBYDIM key width depth_arg
cms_dot_initbydim: cms_dot_initbydim0;
cms_dot_initbydim1: CMS_DOT_INITBYDIM2;
CMS_DOT_INITBYDIM2: 'cms.initbydim';
cms_dot_initbydim3: key;
cms_dot_initbydim4: width;
cms_dot_initbydim5: depth_arg;
cms_dot_initbydim0: cms_dot_initbydim1 cms_dot_initbydim3 cms_dot_initbydim4 cms_dot_initbydim5;

// CMS.INITBYPROB key error probability
// cms_dot_initbyprob: cms_dot_initbyprob0;
// todo: {'error'}
/*
cms_dot_initbyprob1: CMS_DOT_INITBYPROB2;
CMS_DOT_INITBYPROB2: 'cms.initbyprob';
cms_dot_initbyprob3: key;
cms_dot_initbyprob4: cms_dot_initbyprob5;
cms_dot_initbyprob5: 'error.TODO';
cms_dot_initbyprob6: probability;
cms_dot_initbyprob0: cms_dot_initbyprob1 cms_dot_initbyprob3 cms_dot_initbyprob4 cms_dot_initbyprob6;

*/
// CMS.MERGE destination numKeys source [source ...] [WEIGHTS weight   [weight ...]]
// cms_dot_merge: cms_dot_merge0;
// todo: {'numKeys'}
/*
cms_dot_merge1: CMS_DOT_MERGE2;
CMS_DOT_MERGE2: 'cms.merge';
cms_dot_merge3: destination;
cms_dot_merge4: cms_dot_merge5;
cms_dot_merge5: 'numKeys.TODO';
cms_dot_merge6: source;
cms_dot_merge9: source;
cms_dot_merge8: cms_dot_merge9;
cms_dot_merge7: cms_dot_merge8 | cms_dot_merge7 cms_dot_merge8 | ;
cms_dot_merge12: CMS_DOT_MERGE13;
CMS_DOT_MERGE13: 'weights';
cms_dot_merge14: weight;
cms_dot_merge17: weight;
cms_dot_merge16: cms_dot_merge17;
cms_dot_merge15: cms_dot_merge16 | cms_dot_merge15 cms_dot_merge16 | ;
cms_dot_merge11: cms_dot_merge12 cms_dot_merge14 cms_dot_merge15;
cms_dot_merge10: cms_dot_merge11 | ;
cms_dot_merge0: cms_dot_merge1 cms_dot_merge3 cms_dot_merge4 cms_dot_merge6 cms_dot_merge7 cms_dot_merge10;

*/
// CMS.QUERY key item [item ...]
cms_dot_query: cms_dot_query0;
cms_dot_query1: CMS_DOT_QUERY2;
CMS_DOT_QUERY2: 'cms.query';
cms_dot_query3: key;
cms_dot_query4: item;
cms_dot_query7: item;
cms_dot_query6: cms_dot_query7;
cms_dot_query5: cms_dot_query6 | cms_dot_query5 cms_dot_query6 | ;
cms_dot_query0: cms_dot_query1 cms_dot_query3 cms_dot_query4 cms_dot_query5;

// COMMAND
command: command0;
command1: COMMAND2;
COMMAND2: 'command';
command0: command1;

// COMMAND COUNT
command_sp_count: command_sp_count0;
command_sp_count1: COMMAND2;
command_sp_count2: BLMPOP17;
command_sp_count0: command_sp_count1 command_sp_count2;

// COMMAND DOCS [command_name [command_name ...]]
command_sp_docs: command_sp_docs0;
command_sp_docs1: COMMAND2;
command_sp_docs2: COMMAND_SP_DOCS3;
COMMAND_SP_DOCS3: 'docs';
command_sp_docs6: command_name;
command_sp_docs9: command_name;
command_sp_docs8: command_sp_docs9;
command_sp_docs7: command_sp_docs8 | command_sp_docs7 command_sp_docs8 | ;
command_sp_docs5: command_sp_docs6 command_sp_docs7;
command_sp_docs4: command_sp_docs5 | ;
command_sp_docs0: command_sp_docs1 command_sp_docs2 command_sp_docs4;

// COMMAND GETKEYS
command_sp_getkeys: command_sp_getkeys0;
command_sp_getkeys1: COMMAND2;
command_sp_getkeys2: COMMAND_SP_GETKEYS3;
COMMAND_SP_GETKEYS3: 'getkeys';
command_sp_getkeys0: command_sp_getkeys1 command_sp_getkeys2;

// COMMAND GETKEYSANDFLAGS
command_sp_getkeysandflags: command_sp_getkeysandflags0;
command_sp_getkeysandflags1: COMMAND2;
command_sp_getkeysandflags2: COMMAND_SP_GETKEYSANDFLAGS3;
COMMAND_SP_GETKEYSANDFLAGS3: 'getkeysandflags';
command_sp_getkeysandflags0: command_sp_getkeysandflags1 command_sp_getkeysandflags2;

// COMMAND INFO [command_name [command_name ...]]
command_sp_info: command_sp_info0;
command_sp_info1: COMMAND2;
command_sp_info2: CLIENT_SP_INFO3;
command_sp_info5: command_name;
command_sp_info8: command_name;
command_sp_info7: command_sp_info8;
command_sp_info6: command_sp_info7 | command_sp_info6 command_sp_info7 | ;
command_sp_info4: command_sp_info5 command_sp_info6;
command_sp_info3: command_sp_info4 | ;
command_sp_info0: command_sp_info1 command_sp_info2 command_sp_info3;

// COMMAND LIST [FILTERBY <MODULE module_name | ACLCAT category |   PATTERN pattern>]
command_sp_list: command_sp_list0;
command_sp_list1: COMMAND2;
command_sp_list2: ACL_SP_LIST3;
command_sp_list5: COMMAND_SP_LIST6;
COMMAND_SP_LIST6: 'filterby';
command_sp_list9: COMMAND_SP_LIST10;
COMMAND_SP_LIST10: 'module';
command_sp_list12: module_name;
command_sp_list13: COMMAND_SP_LIST14;
COMMAND_SP_LIST14: 'aclcat';
command_sp_list11: command_sp_list12 | command_sp_list13;
command_sp_list16: category;
command_sp_list17: COMMAND_SP_LIST18;
COMMAND_SP_LIST18: 'pattern';
command_sp_list15: command_sp_list16 | command_sp_list17;
command_sp_list19: pattern;
command_sp_list8: command_sp_list9 command_sp_list11 command_sp_list15 command_sp_list19;
command_sp_list7: command_sp_list8;
command_sp_list4: command_sp_list5 command_sp_list7;
command_sp_list3: command_sp_list4 | ;
command_sp_list0: command_sp_list1 command_sp_list2 command_sp_list3;

// CONFIG GET parameter [parameter ...]
// config_sp_get: config_sp_get0;
// todo: {'parameter'}
/*
config_sp_get1: CONFIG_SP_GET2;
CONFIG_SP_GET2: 'config';
config_sp_get3: BITFIELD10;
config_sp_get4: config_sp_get5;
config_sp_get5: 'parameter.TODO';
config_sp_get8: config_sp_get9;
config_sp_get9: 'parameter.TODO';
config_sp_get7: config_sp_get8;
config_sp_get6: config_sp_get7 | config_sp_get6 config_sp_get7 | ;
config_sp_get0: config_sp_get1 config_sp_get3 config_sp_get4 config_sp_get6;

*/
// CONFIG RESETSTAT
config_sp_resetstat: config_sp_resetstat0;
config_sp_resetstat1: CONFIG_SP_RESETSTAT2;
CONFIG_SP_RESETSTAT2: 'config';
config_sp_resetstat3: CONFIG_SP_RESETSTAT4;
CONFIG_SP_RESETSTAT4: 'resetstat';
config_sp_resetstat0: config_sp_resetstat1 config_sp_resetstat3;

// CONFIG REWRITE
config_sp_rewrite: config_sp_rewrite0;
config_sp_rewrite1: CONFIG_SP_RESETSTAT2;
config_sp_rewrite2: CONFIG_SP_REWRITE3;
CONFIG_SP_REWRITE3: 'rewrite';
config_sp_rewrite0: config_sp_rewrite1 config_sp_rewrite2;

// CONFIG SET parameter value [parameter value ...]
// config_sp_set: config_sp_set0;
// todo: {'parameter'}
/*
config_sp_set1: CONFIG_SP_RESETSTAT2;
config_sp_set2: BITFIELD33;
config_sp_set3: config_sp_set4;
config_sp_set4: 'parameter.TODO';
config_sp_set5: value;
config_sp_set8: config_sp_set9;
config_sp_set9: 'parameter.TODO';
config_sp_set10: value;
config_sp_set7: config_sp_set8 config_sp_set10;
config_sp_set6: config_sp_set7 | config_sp_set6 config_sp_set7 | ;
config_sp_set0: config_sp_set1 config_sp_set2 config_sp_set3 config_sp_set5 config_sp_set6;

*/
// COPY source destination [DB destination_db] [REPLACE]
copy: copy0;
copy1: COPY2;
COPY2: 'copy';
copy3: source;
copy4: destination;
copy7: COPY8;
COPY8: 'db';
copy9: destination_db;
copy6: copy7 copy9;
copy5: copy6 | ;
copy12: COPY13;
COPY13: 'replace';
copy11: copy12;
copy10: copy11 | ;
copy0: copy1 elem1=copy3 elem2=copy4 copy5 copy10 #CopyRule1;

// DBSIZE
dbsize: dbsize0;
dbsize1: DBSIZE2;
DBSIZE2: 'dbsize';
dbsize0: dbsize1;

// DECR key
decr: decr0;
decr1: DECR2;
DECR2: 'decr';
decr3: elem=key #DecrRule1;
decr0: decr1 decr3;

// DECRBY key decrement
decrby: decrby0;
decrby1: DECRBY2;
DECRBY2: 'decrby';
decrby3: elem=key #DecrByRule1;
decrby4: decrement;
decrby0: decrby1 decrby3 decrby4;

// DEL key [key ...]
cmd_del: del0;
del1: DEL2;
DEL2: 'del';
del3: elem=key #DelRule1;
del6: elem=key #DelRule2;
del5: del6;
del4: del5 | del4 del5 | ;
del0: del1 del3 del4;

// DISCARD
discard: discard0;
discard1: DISCARD2;
DISCARD2: 'discard';
discard0: discard1;

// DUMP key
dump: dump0;
dump1: DUMP2;
DUMP2: 'dump';
dump3: elem=key #DumpRule1;
dump0: dump1 dump3;

// ECHO message
echo: echo0;
echo1: ECHO2;
ECHO2: 'echo';
echo3: message;
echo0: echo1 echo3;

// EVAL script numkeys [key [key ...]] [arg [arg ...]]
// eval: eval0;
// todo: {'script', 'arg'}
/*
eval1: EVAL2;
EVAL2: 'eval';
eval3: eval4;
eval4: 'script.TODO';
eval5: numkeys;
eval8: key;
eval11: key;
eval10: eval11;
eval9: eval10 | eval9 eval10 | ;
eval7: eval8 eval9;
eval6: eval7 | ;
eval14: eval15;
eval15: 'arg.TODO';
eval18: eval19;
eval19: 'arg.TODO';
eval17: eval18;
eval16: eval17 | eval16 eval17 | ;
eval13: eval14 eval16;
eval12: eval13 | ;
eval0: eval1 eval3 eval5 eval6 eval12;

*/
// EVAL_RO script numkeys [key [key ...]] [arg [arg ...]]
// eval_ro: eval_ro0;
// todo: {'script', 'arg'}
/*
eval_ro1: EVAL_RO2;
EVAL_RO2: 'eval_ro';
eval_ro3: eval_ro4;
eval_ro4: 'script.TODO';
eval_ro5: numkeys;
eval_ro8: key;
eval_ro11: key;
eval_ro10: eval_ro11;
eval_ro9: eval_ro10 | eval_ro9 eval_ro10 | ;
eval_ro7: eval_ro8 eval_ro9;
eval_ro6: eval_ro7 | ;
eval_ro14: eval_ro15;
eval_ro15: 'arg.TODO';
eval_ro18: eval_ro19;
eval_ro19: 'arg.TODO';
eval_ro17: eval_ro18;
eval_ro16: eval_ro17 | eval_ro16 eval_ro17 | ;
eval_ro13: eval_ro14 eval_ro16;
eval_ro12: eval_ro13 | ;
eval_ro0: eval_ro1 eval_ro3 eval_ro5 eval_ro6 eval_ro12;

*/
// EVALSHA sha1 numkeys [key [key ...]] [arg [arg ...]]
// evalsha: evalsha0;
// todo: {'sha1', 'arg'}
/*
evalsha1: EVALSHA2;
EVALSHA2: 'evalsha';
evalsha3: evalsha4;
evalsha4: 'sha1.TODO';
evalsha5: numkeys;
evalsha8: key;
evalsha11: key;
evalsha10: evalsha11;
evalsha9: evalsha10 | evalsha9 evalsha10 | ;
evalsha7: evalsha8 evalsha9;
evalsha6: evalsha7 | ;
evalsha14: evalsha15;
evalsha15: 'arg.TODO';
evalsha18: evalsha19;
evalsha19: 'arg.TODO';
evalsha17: evalsha18;
evalsha16: evalsha17 | evalsha16 evalsha17 | ;
evalsha13: evalsha14 evalsha16;
evalsha12: evalsha13 | ;
evalsha0: evalsha1 evalsha3 evalsha5 evalsha6 evalsha12;

*/
// EVALSHA_RO sha1 numkeys [key [key ...]] [arg [arg ...]]
// evalsha_ro: evalsha_ro0;
// todo: {'sha1', 'arg'}
/*
evalsha_ro1: EVALSHA_RO2;
EVALSHA_RO2: 'evalsha_ro';
evalsha_ro3: evalsha_ro4;
evalsha_ro4: 'sha1.TODO';
evalsha_ro5: numkeys;
evalsha_ro8: key;
evalsha_ro11: key;
evalsha_ro10: evalsha_ro11;
evalsha_ro9: evalsha_ro10 | evalsha_ro9 evalsha_ro10 | ;
evalsha_ro7: evalsha_ro8 evalsha_ro9;
evalsha_ro6: evalsha_ro7 | ;
evalsha_ro14: evalsha_ro15;
evalsha_ro15: 'arg.TODO';
evalsha_ro18: evalsha_ro19;
evalsha_ro19: 'arg.TODO';
evalsha_ro17: evalsha_ro18;
evalsha_ro16: evalsha_ro17 | evalsha_ro16 evalsha_ro17 | ;
evalsha_ro13: evalsha_ro14 evalsha_ro16;
evalsha_ro12: evalsha_ro13 | ;
evalsha_ro0: evalsha_ro1 evalsha_ro3 evalsha_ro5 evalsha_ro6 evalsha_ro12;

*/
// EXEC
exec: exec0;
exec1: EXEC2;
EXEC2: 'exec';
exec0: elem=exec1 #ExecRule1;

// EXISTS key [key ...]
exists: exists0;
exists1: EXISTS2;
EXISTS2: 'exists';
exists3: key;
exists6: key;
exists5: exists6;
exists4: exists5 | exists4 exists5 | ;
exists0: exists1 exists3 exists4;

// EXPIRE key seconds [NX | XX | GT | LT]
expire: expire0;
expire1: EXPIRE2;
EXPIRE2: 'expire';
expire3: elem=key #ExpireRule1;
expire4: seconds;
expire10: EXPIRE11;
EXPIRE11: 'nx';
expire12: EXPIRE13;
EXPIRE13: 'xx';
expire9: expire10 | expire12;
expire14: EXPIRE15;
EXPIRE15: 'gt';
expire8: expire9 | expire14;
expire16: EXPIRE17;
EXPIRE17: 'lt';
expire7: expire8 | expire16;
expire6: expire7;
expire5: expire6 | ;
expire0: expire1 expire3 expire4 expire5;

// EXPIREAT key unix_time_seconds [NX | XX | GT | LT]
expireat: expireat0;
expireat1: EXPIREAT2;
EXPIREAT2: 'expireat';
expireat3: key;
expireat4: unix_time_seconds;
expireat10: EXPIRE11;
expireat11: EXPIRE13;
expireat9: expireat10 | expireat11;
expireat12: EXPIRE15;
expireat8: expireat9 | expireat12;
expireat13: EXPIRE17;
expireat7: expireat8 | expireat13;
expireat6: expireat7;
expireat5: expireat6 | ;
expireat0: expireat1 expireat3 expireat4 expireat5;

// EXPIRETIME key
expiretime: expiretime0;
expiretime1: EXPIRETIME2;
EXPIRETIME2: 'expiretime';
expiretime3: key;
expiretime0: expiretime1 expiretime3;

// FAILOVER [TO host port [FORCE]] [ABORT] [TIMEOUT milliseconds]
// failover: failover0;
// todo: {'host'}
/*
failover1: CLUSTER_SP_FAILOVER3;
failover4: FAILOVER5;
FAILOVER5: 'to';
failover6: failover7;
failover7: 'host.TODO';
failover8: port;
failover11: CLUSTER_SP_FAILOVER8;
failover10: failover11;
failover9: failover10 | ;
failover3: failover4 failover6 failover8 failover9;
failover2: failover3 | ;
failover14: FAILOVER15;
FAILOVER15: 'abort';
failover13: failover14;
failover12: failover13 | ;
failover18: FAILOVER19;
FAILOVER19: 'timeout';
failover20: milliseconds;
failover17: failover18 failover20;
failover16: failover17 | ;
failover0: failover1 failover2 failover12 failover16;

*/
// FCALL function numkeys [key [key ...]] [arg [arg ...]]
// fcall: fcall0;
// todo: {'function', 'arg'}
/*
fcall1: FCALL2;
FCALL2: 'fcall';
fcall3: fcall4;
fcall4: 'function.TODO';
fcall5: numkeys;
fcall8: key;
fcall11: key;
fcall10: fcall11;
fcall9: fcall10 | fcall9 fcall10 | ;
fcall7: fcall8 fcall9;
fcall6: fcall7 | ;
fcall14: fcall15;
fcall15: 'arg.TODO';
fcall18: fcall19;
fcall19: 'arg.TODO';
fcall17: fcall18;
fcall16: fcall17 | fcall16 fcall17 | ;
fcall13: fcall14 fcall16;
fcall12: fcall13 | ;
fcall0: fcall1 fcall3 fcall5 fcall6 fcall12;

*/
// FCALL_RO function numkeys [key [key ...]] [arg [arg ...]]
// fcall_ro: fcall_ro0;
// todo: {'function', 'arg'}
/*
fcall_ro1: FCALL_RO2;
FCALL_RO2: 'fcall_ro';
fcall_ro3: fcall_ro4;
fcall_ro4: 'function.TODO';
fcall_ro5: numkeys;
fcall_ro8: key;
fcall_ro11: key;
fcall_ro10: fcall_ro11;
fcall_ro9: fcall_ro10 | fcall_ro9 fcall_ro10 | ;
fcall_ro7: fcall_ro8 fcall_ro9;
fcall_ro6: fcall_ro7 | ;
fcall_ro14: fcall_ro15;
fcall_ro15: 'arg.TODO';
fcall_ro18: fcall_ro19;
fcall_ro19: 'arg.TODO';
fcall_ro17: fcall_ro18;
fcall_ro16: fcall_ro17 | fcall_ro16 fcall_ro17 | ;
fcall_ro13: fcall_ro14 fcall_ro16;
fcall_ro12: fcall_ro13 | ;
fcall_ro0: fcall_ro1 fcall_ro3 fcall_ro5 fcall_ro6 fcall_ro12;

*/
// FLUSHALL [ASYNC | SYNC]
flushall: flushall0;
flushall1: FLUSHALL2;
FLUSHALL2: 'flushall';
flushall6: FLUSHALL7;
FLUSHALL7: 'async';
flushall8: FLUSHALL9;
FLUSHALL9: 'sync';
flushall5: flushall6 | flushall8;
flushall4: flushall5;
flushall3: flushall4 | ;
flushall0: flushall1 flushall3;

// FLUSHDB [ASYNC | SYNC]
flushdb: flushdb0;
flushdb1: FLUSHDB2;
FLUSHDB2: 'flushdb';
flushdb6: FLUSHALL7;
flushdb7: FLUSHALL9;
flushdb5: flushdb6 | flushdb7;
flushdb4: flushdb5;
flushdb3: flushdb4 | ;
flushdb0: flushdb1 flushdb3;

// FT._LIST
ft_dot__list: ft_dot__list0;
ft_dot__list1: FT_DOT__LIST2;
FT_DOT__LIST2: 'ft._list';
ft_dot__list0: ft_dot__list1;

// FT.AGGREGATE index query    [VERBATIM]    [ LOAD count field [field ...]]    [TIMEOUT timeout]    [LOAD *]    [ GROUPBY nargs property [property ...] [ REDUCE function nargs arg [arg ...] [AS name] [ REDUCE function nargs arg [arg ...] [AS name] ...]]    [ GROUPBY nargs property [property ...] [ REDUCE function nargs arg [arg ...] [AS name] [ REDUCE function nargs arg [arg ...] [AS name] ...]] ...]]    [ SORTBY nargs [ property ASC | DESC [ property ASC | DESC ...]] [MAX num]]    [ APPLY expression AS name [ APPLY expression AS name ...]]    [ LIMIT offset num]    [FILTER filter]    [ WITHCURSOR [COUNT read_size] [MAXIDLE idle_time]]    [ PARAMS nargs name value [ name value ...]]    [DIALECT dialect] 
// ft_dot_aggregate: ft_dot_aggregate0;
// todo: {'function', 'arg', 'expression', 'filter', 'read_size', 'idle_time'}
/*
ft_dot_aggregate1: FT_DOT_AGGREGATE2;
FT_DOT_AGGREGATE2: 'ft.aggregate';
ft_dot_aggregate3: index;
ft_dot_aggregate4: query;
ft_dot_aggregate7: FT_DOT_AGGREGATE8;
FT_DOT_AGGREGATE8: 'verbatim';
ft_dot_aggregate6: ft_dot_aggregate7;
ft_dot_aggregate5: ft_dot_aggregate6 | ;
ft_dot_aggregate11: ACL_SP_LOAD3;
ft_dot_aggregate12: count;
ft_dot_aggregate13: field;
ft_dot_aggregate16: field;
ft_dot_aggregate15: ft_dot_aggregate16;
ft_dot_aggregate14: ft_dot_aggregate15 | ft_dot_aggregate14 ft_dot_aggregate15 | ;
ft_dot_aggregate10: ft_dot_aggregate11 ft_dot_aggregate12 ft_dot_aggregate13 ft_dot_aggregate14;
ft_dot_aggregate9: ft_dot_aggregate10 | ;
ft_dot_aggregate19: FT_DOT_AGGREGATE20;
FT_DOT_AGGREGATE20: 'timeout';
ft_dot_aggregate21: timeout;
ft_dot_aggregate18: ft_dot_aggregate19 ft_dot_aggregate21;
ft_dot_aggregate17: ft_dot_aggregate18 | ;
ft_dot_aggregate24: ACL_SP_LOAD3;
ft_dot_aggregate25: FT_DOT_AGGREGATE26;
FT_DOT_AGGREGATE26: '*';
ft_dot_aggregate23: ft_dot_aggregate24 ft_dot_aggregate25;
ft_dot_aggregate22: ft_dot_aggregate23 | ;
ft_dot_aggregate29: FT_DOT_AGGREGATE30;
FT_DOT_AGGREGATE30: 'groupby';
ft_dot_aggregate31: nargs;
ft_dot_aggregate32: property;
ft_dot_aggregate35: property;
ft_dot_aggregate34: ft_dot_aggregate35;
ft_dot_aggregate33: ft_dot_aggregate34 | ft_dot_aggregate33 ft_dot_aggregate34 | ;
ft_dot_aggregate38: FT_DOT_AGGREGATE39;
FT_DOT_AGGREGATE39: 'reduce';
ft_dot_aggregate40: ft_dot_aggregate41;
ft_dot_aggregate41: 'function.TODO';
ft_dot_aggregate42: nargs;
ft_dot_aggregate43: ft_dot_aggregate44;
ft_dot_aggregate44: 'arg.TODO';
ft_dot_aggregate47: ft_dot_aggregate48;
ft_dot_aggregate48: 'arg.TODO';
ft_dot_aggregate46: ft_dot_aggregate47;
ft_dot_aggregate45: ft_dot_aggregate46 | ft_dot_aggregate45 ft_dot_aggregate46 | ;
ft_dot_aggregate51: FT_DOT_AGGREGATE52;
FT_DOT_AGGREGATE52: 'as';
ft_dot_aggregate53: name;
ft_dot_aggregate50: ft_dot_aggregate51 ft_dot_aggregate53;
ft_dot_aggregate49: ft_dot_aggregate50 | ;
ft_dot_aggregate56: FT_DOT_AGGREGATE39;
ft_dot_aggregate57: ft_dot_aggregate58;
ft_dot_aggregate58: 'function.TODO';
ft_dot_aggregate59: nargs;
ft_dot_aggregate60: ft_dot_aggregate61;
ft_dot_aggregate61: 'arg.TODO';
ft_dot_aggregate64: ft_dot_aggregate65;
ft_dot_aggregate65: 'arg.TODO';
ft_dot_aggregate63: ft_dot_aggregate64;
ft_dot_aggregate62: ft_dot_aggregate63 | ft_dot_aggregate62 ft_dot_aggregate63 | ;
ft_dot_aggregate68: FT_DOT_AGGREGATE52;
ft_dot_aggregate69: name;
ft_dot_aggregate67: ft_dot_aggregate68 ft_dot_aggregate69;
ft_dot_aggregate66: ft_dot_aggregate67 | ;
ft_dot_aggregate55: ft_dot_aggregate56 ft_dot_aggregate57 ft_dot_aggregate59 ft_dot_aggregate60 ft_dot_aggregate62 ft_dot_aggregate66;
ft_dot_aggregate54: ft_dot_aggregate55 | ft_dot_aggregate54 ft_dot_aggregate55 | ;
ft_dot_aggregate37: ft_dot_aggregate38 ft_dot_aggregate40 ft_dot_aggregate42 ft_dot_aggregate43 ft_dot_aggregate45 ft_dot_aggregate49 ft_dot_aggregate54;
ft_dot_aggregate36: ft_dot_aggregate37 | ;
ft_dot_aggregate72: FT_DOT_AGGREGATE30;
ft_dot_aggregate73: nargs;
ft_dot_aggregate74: property;
ft_dot_aggregate77: property;
ft_dot_aggregate76: ft_dot_aggregate77;
ft_dot_aggregate75: ft_dot_aggregate76 | ft_dot_aggregate75 ft_dot_aggregate76 | ;
ft_dot_aggregate80: FT_DOT_AGGREGATE39;
ft_dot_aggregate81: ft_dot_aggregate82;
ft_dot_aggregate82: 'function.TODO';
ft_dot_aggregate83: nargs;
ft_dot_aggregate84: ft_dot_aggregate85;
ft_dot_aggregate85: 'arg.TODO';
ft_dot_aggregate88: ft_dot_aggregate89;
ft_dot_aggregate89: 'arg.TODO';
ft_dot_aggregate87: ft_dot_aggregate88;
ft_dot_aggregate86: ft_dot_aggregate87 | ft_dot_aggregate86 ft_dot_aggregate87 | ;
ft_dot_aggregate92: FT_DOT_AGGREGATE52;
ft_dot_aggregate93: name;
ft_dot_aggregate91: ft_dot_aggregate92 ft_dot_aggregate93;
ft_dot_aggregate90: ft_dot_aggregate91 | ;
ft_dot_aggregate96: FT_DOT_AGGREGATE39;
ft_dot_aggregate97: ft_dot_aggregate98;
ft_dot_aggregate98: 'function.TODO';
ft_dot_aggregate99: nargs;
ft_dot_aggregate100: ft_dot_aggregate101;
ft_dot_aggregate101: 'arg.TODO';
ft_dot_aggregate104: ft_dot_aggregate105;
ft_dot_aggregate105: 'arg.TODO';
ft_dot_aggregate103: ft_dot_aggregate104;
ft_dot_aggregate102: ft_dot_aggregate103 | ft_dot_aggregate102 ft_dot_aggregate103 | ;
ft_dot_aggregate108: FT_DOT_AGGREGATE52;
ft_dot_aggregate109: name;
ft_dot_aggregate107: ft_dot_aggregate108 ft_dot_aggregate109;
ft_dot_aggregate106: ft_dot_aggregate107 | ;
ft_dot_aggregate95: ft_dot_aggregate96 ft_dot_aggregate97 ft_dot_aggregate99 ft_dot_aggregate100 ft_dot_aggregate102 ft_dot_aggregate106;
ft_dot_aggregate94: ft_dot_aggregate95 | ft_dot_aggregate94 ft_dot_aggregate95 | ;
ft_dot_aggregate79: ft_dot_aggregate80 ft_dot_aggregate81 ft_dot_aggregate83 ft_dot_aggregate84 ft_dot_aggregate86 ft_dot_aggregate90 ft_dot_aggregate94;
ft_dot_aggregate78: ft_dot_aggregate79 | ;
ft_dot_aggregate71: ft_dot_aggregate72 ft_dot_aggregate73 ft_dot_aggregate74 ft_dot_aggregate75 ft_dot_aggregate78;
ft_dot_aggregate70: ft_dot_aggregate71 | ft_dot_aggregate70 ft_dot_aggregate71 | ;
ft_dot_aggregate28: ft_dot_aggregate29 ft_dot_aggregate31 ft_dot_aggregate32 ft_dot_aggregate33 ft_dot_aggregate36 ft_dot_aggregate70;
ft_dot_aggregate27: ft_dot_aggregate28 | ;
ft_dot_aggregate112: FT_DOT_AGGREGATE113;
FT_DOT_AGGREGATE113: 'sortby';
ft_dot_aggregate114: nargs;
ft_dot_aggregate117: property;
ft_dot_aggregate119: FT_DOT_AGGREGATE120;
FT_DOT_AGGREGATE120: 'asc';
ft_dot_aggregate121: FT_DOT_AGGREGATE122;
FT_DOT_AGGREGATE122: 'desc';
ft_dot_aggregate118: ft_dot_aggregate119 | ft_dot_aggregate121;
ft_dot_aggregate125: property;
ft_dot_aggregate127: FT_DOT_AGGREGATE120;
ft_dot_aggregate128: FT_DOT_AGGREGATE122;
ft_dot_aggregate126: ft_dot_aggregate127 | ft_dot_aggregate128;
ft_dot_aggregate124: ft_dot_aggregate125 ft_dot_aggregate126;
ft_dot_aggregate123: ft_dot_aggregate124 | ft_dot_aggregate123 ft_dot_aggregate124 | ;
ft_dot_aggregate116: ft_dot_aggregate117 ft_dot_aggregate118 ft_dot_aggregate123;
ft_dot_aggregate115: ft_dot_aggregate116 | ;
ft_dot_aggregate131: BZMPOP15;
ft_dot_aggregate132: num;
ft_dot_aggregate130: ft_dot_aggregate131 ft_dot_aggregate132;
ft_dot_aggregate129: ft_dot_aggregate130 | ;
ft_dot_aggregate111: ft_dot_aggregate112 ft_dot_aggregate114 ft_dot_aggregate115 ft_dot_aggregate129;
ft_dot_aggregate110: ft_dot_aggregate111 | ;
ft_dot_aggregate135: FT_DOT_AGGREGATE136;
FT_DOT_AGGREGATE136: 'apply';
ft_dot_aggregate137: ft_dot_aggregate138;
ft_dot_aggregate138: 'expression.TODO';
ft_dot_aggregate139: FT_DOT_AGGREGATE52;
ft_dot_aggregate140: name;
ft_dot_aggregate143: FT_DOT_AGGREGATE136;
ft_dot_aggregate144: ft_dot_aggregate145;
ft_dot_aggregate145: 'expression.TODO';
ft_dot_aggregate146: FT_DOT_AGGREGATE52;
ft_dot_aggregate147: name;
ft_dot_aggregate142: ft_dot_aggregate143 ft_dot_aggregate144 ft_dot_aggregate146 ft_dot_aggregate147;
ft_dot_aggregate141: ft_dot_aggregate142 | ft_dot_aggregate141 ft_dot_aggregate142 | ;
ft_dot_aggregate134: ft_dot_aggregate135 ft_dot_aggregate137 ft_dot_aggregate139 ft_dot_aggregate140 ft_dot_aggregate141;
ft_dot_aggregate133: ft_dot_aggregate134 | ;
ft_dot_aggregate150: FT_DOT_AGGREGATE151;
FT_DOT_AGGREGATE151: 'limit';
ft_dot_aggregate152: offset;
ft_dot_aggregate153: num;
ft_dot_aggregate149: ft_dot_aggregate150 ft_dot_aggregate152 ft_dot_aggregate153;
ft_dot_aggregate148: ft_dot_aggregate149 | ;
ft_dot_aggregate156: FT_DOT_AGGREGATE157;
FT_DOT_AGGREGATE157: 'filter';
ft_dot_aggregate158: ft_dot_aggregate159;
ft_dot_aggregate159: 'filter.TODO';
ft_dot_aggregate155: ft_dot_aggregate156 ft_dot_aggregate158;
ft_dot_aggregate154: ft_dot_aggregate155 | ;
ft_dot_aggregate162: FT_DOT_AGGREGATE163;
FT_DOT_AGGREGATE163: 'withcursor';
ft_dot_aggregate166: BLMPOP17;
ft_dot_aggregate167: ft_dot_aggregate168;
ft_dot_aggregate168: 'read_size.TODO';
ft_dot_aggregate165: ft_dot_aggregate166 ft_dot_aggregate167;
ft_dot_aggregate164: ft_dot_aggregate165 | ;
ft_dot_aggregate171: FT_DOT_AGGREGATE172;
FT_DOT_AGGREGATE172: 'maxidle';
ft_dot_aggregate173: ft_dot_aggregate174;
ft_dot_aggregate174: 'idle_time.TODO';
ft_dot_aggregate170: ft_dot_aggregate171 ft_dot_aggregate173;
ft_dot_aggregate169: ft_dot_aggregate170 | ;
ft_dot_aggregate161: ft_dot_aggregate162 ft_dot_aggregate164 ft_dot_aggregate169;
ft_dot_aggregate160: ft_dot_aggregate161 | ;
ft_dot_aggregate177: FT_DOT_AGGREGATE178;
FT_DOT_AGGREGATE178: 'params';
ft_dot_aggregate179: nargs;
ft_dot_aggregate180: name;
ft_dot_aggregate181: value;
ft_dot_aggregate184: name;
ft_dot_aggregate185: value;
ft_dot_aggregate183: ft_dot_aggregate184 ft_dot_aggregate185;
ft_dot_aggregate182: ft_dot_aggregate183 | ft_dot_aggregate182 ft_dot_aggregate183 | ;
ft_dot_aggregate176: ft_dot_aggregate177 ft_dot_aggregate179 ft_dot_aggregate180 ft_dot_aggregate181 ft_dot_aggregate182;
ft_dot_aggregate175: ft_dot_aggregate176 | ;
ft_dot_aggregate188: FT_DOT_AGGREGATE189;
FT_DOT_AGGREGATE189: 'dialect';
ft_dot_aggregate190: dialect;
ft_dot_aggregate187: ft_dot_aggregate188 ft_dot_aggregate190;
ft_dot_aggregate186: ft_dot_aggregate187 | ;
ft_dot_aggregate0: ft_dot_aggregate1 ft_dot_aggregate3 ft_dot_aggregate4 ft_dot_aggregate5 ft_dot_aggregate9 ft_dot_aggregate17 ft_dot_aggregate22 ft_dot_aggregate27 ft_dot_aggregate110 ft_dot_aggregate133 ft_dot_aggregate148 ft_dot_aggregate154 ft_dot_aggregate160 ft_dot_aggregate175 ft_dot_aggregate186;

*/
// FT.ALIASADD alias index 
ft_dot_aliasadd: ft_dot_aliasadd0;
ft_dot_aliasadd1: FT_DOT_ALIASADD2;
FT_DOT_ALIASADD2: 'ft.aliasadd';
ft_dot_aliasadd3: alias;
ft_dot_aliasadd4: index;
ft_dot_aliasadd0: ft_dot_aliasadd1 ft_dot_aliasadd3 ft_dot_aliasadd4;

// FT.ALIASDEL alias 
ft_dot_aliasdel: ft_dot_aliasdel0;
ft_dot_aliasdel1: FT_DOT_ALIASDEL2;
FT_DOT_ALIASDEL2: 'ft.aliasdel';
ft_dot_aliasdel3: alias;
ft_dot_aliasdel0: ft_dot_aliasdel1 ft_dot_aliasdel3;

// FT.ALIASUPDATE alias index 
ft_dot_aliasupdate: ft_dot_aliasupdate0;
ft_dot_aliasupdate1: FT_DOT_ALIASUPDATE2;
FT_DOT_ALIASUPDATE2: 'ft.aliasupdate';
ft_dot_aliasupdate3: alias;
ft_dot_aliasupdate4: index;
ft_dot_aliasupdate0: ft_dot_aliasupdate1 ft_dot_aliasupdate3 ft_dot_aliasupdate4;

// FT.ALTER index [SKIPINITIALSCAN] SCHEMA ADD attribute_type options [attribute_type options ...] 
// ft_dot_alter: ft_dot_alter0;
// todo: {'attribute_type'}
/*
ft_dot_alter1: FT_DOT_ALTER2;
FT_DOT_ALTER2: 'ft.alter';
ft_dot_alter3: index;
ft_dot_alter6: FT_DOT_ALTER7;
FT_DOT_ALTER7: 'skipinitialscan';
ft_dot_alter5: ft_dot_alter6;
ft_dot_alter4: ft_dot_alter5 | ;
ft_dot_alter8: FT_DOT_ALTER9;
FT_DOT_ALTER9: 'schema';
ft_dot_alter10: FT_DOT_ALTER11;
FT_DOT_ALTER11: 'add';
ft_dot_alter12: ft_dot_alter13;
ft_dot_alter13: 'attribute_type.TODO';
ft_dot_alter14: options;
ft_dot_alter17: ft_dot_alter18;
ft_dot_alter18: 'attribute_type.TODO';
ft_dot_alter19: options;
ft_dot_alter16: ft_dot_alter17 ft_dot_alter19;
ft_dot_alter15: ft_dot_alter16 | ft_dot_alter15 ft_dot_alter16 | ;
ft_dot_alter0: ft_dot_alter1 ft_dot_alter3 ft_dot_alter4 ft_dot_alter8 ft_dot_alter10 ft_dot_alter12 ft_dot_alter14 ft_dot_alter15;

*/
// FT.CONFIG GET option 
ft_dot_config_sp_get: ft_dot_config_sp_get0;
ft_dot_config_sp_get1: FT_DOT_CONFIG_SP_GET2;
FT_DOT_CONFIG_SP_GET2: 'ft.config';
ft_dot_config_sp_get3: BITFIELD10;
ft_dot_config_sp_get4: option;
ft_dot_config_sp_get0: ft_dot_config_sp_get1 ft_dot_config_sp_get3 ft_dot_config_sp_get4;

// FT.CONFIG SET option value 
ft_dot_config_sp_set: ft_dot_config_sp_set0;
ft_dot_config_sp_set1: FT_DOT_CONFIG_SP_GET2;
ft_dot_config_sp_set2: BITFIELD33;
ft_dot_config_sp_set3: option;
ft_dot_config_sp_set4: value;
ft_dot_config_sp_set0: ft_dot_config_sp_set1 ft_dot_config_sp_set2 ft_dot_config_sp_set3 ft_dot_config_sp_set4;

// FT.CREATE index    [ON HASH | JSON]    [PREFIX count prefix [prefix ...]]    [FILTER {filter}]   [LANGUAGE default_lang]    [LANGUAGE_FIELD lang_attribute]    [SCORE default_score]    [SCORE_FIELD score_attribute]    [PAYLOAD_FIELD payload_attribute]    [MAXTEXTFIELDS]    [TEMPORARY seconds]    [NOOFFSETS]    [NOHL]    [NOFIELDS]    [NOFREQS]    [STOPWORDS count [stopword ...]]    [SKIPINITIALSCAN]   SCHEMA field_name [AS alias] TEXT | TAG | NUMERIC | GEO | VECTOR [ SORTABLE [UNF]]    [NOINDEX] [ field_name [AS alias] TEXT | TAG | NUMERIC | GEO | VECTOR [ SORTABLE [UNF]] [NOINDEX] ...] 
// ft_dot_create: ft_dot_create0;
// Unable to process

// FT.CURSOR DEL index cursor_id 
// ft_dot_cursor_sp_del: ft_dot_cursor_sp_del0;
// todo: {'cursor_id'}
/*
ft_dot_cursor_sp_del1: FT_DOT_CURSOR_SP_DEL2;
FT_DOT_CURSOR_SP_DEL2: 'ft.cursor';
ft_dot_cursor_sp_del3: DEL2;
ft_dot_cursor_sp_del4: index;
ft_dot_cursor_sp_del5: ft_dot_cursor_sp_del6;
ft_dot_cursor_sp_del6: 'cursor_id.TODO';
ft_dot_cursor_sp_del0: ft_dot_cursor_sp_del1 ft_dot_cursor_sp_del3 ft_dot_cursor_sp_del4 ft_dot_cursor_sp_del5;

*/
// FT.CURSOR READ index cursor_id [COUNT read_size] 
// ft_dot_cursor_sp_read: ft_dot_cursor_sp_read0;
// todo: {'cursor_id', 'read_size'}
/*
ft_dot_cursor_sp_read1: FT_DOT_CURSOR_SP_READ2;
FT_DOT_CURSOR_SP_READ2: 'ft.cursor';
ft_dot_cursor_sp_read3: FT_DOT_CURSOR_SP_READ4;
FT_DOT_CURSOR_SP_READ4: 'read';
ft_dot_cursor_sp_read5: index;
ft_dot_cursor_sp_read6: ft_dot_cursor_sp_read7;
ft_dot_cursor_sp_read7: 'cursor_id.TODO';
ft_dot_cursor_sp_read10: BLMPOP17;
ft_dot_cursor_sp_read11: ft_dot_cursor_sp_read12;
ft_dot_cursor_sp_read12: 'read_size.TODO';
ft_dot_cursor_sp_read9: ft_dot_cursor_sp_read10 ft_dot_cursor_sp_read11;
ft_dot_cursor_sp_read8: ft_dot_cursor_sp_read9 | ;
ft_dot_cursor_sp_read0: ft_dot_cursor_sp_read1 ft_dot_cursor_sp_read3 ft_dot_cursor_sp_read5 ft_dot_cursor_sp_read6 ft_dot_cursor_sp_read8;

*/
// FT.DICTADD dict term [term ...] 
// ft_dot_dictadd: ft_dot_dictadd0;
// todo: {'dict', 'term'}
/*
ft_dot_dictadd1: FT_DOT_DICTADD2;
FT_DOT_DICTADD2: 'ft.dictadd';
ft_dot_dictadd3: ft_dot_dictadd4;
ft_dot_dictadd4: 'dict.TODO';
ft_dot_dictadd5: ft_dot_dictadd6;
ft_dot_dictadd6: 'term.TODO';
ft_dot_dictadd9: ft_dot_dictadd10;
ft_dot_dictadd10: 'term.TODO';
ft_dot_dictadd8: ft_dot_dictadd9;
ft_dot_dictadd7: ft_dot_dictadd8 | ft_dot_dictadd7 ft_dot_dictadd8 | ;
ft_dot_dictadd0: ft_dot_dictadd1 ft_dot_dictadd3 ft_dot_dictadd5 ft_dot_dictadd7;

*/
// FT.DICTDEL dict term [term ...] 
// ft_dot_dictdel: ft_dot_dictdel0;
// todo: {'dict', 'term'}
/*
ft_dot_dictdel1: FT_DOT_DICTDEL2;
FT_DOT_DICTDEL2: 'ft.dictdel';
ft_dot_dictdel3: ft_dot_dictdel4;
ft_dot_dictdel4: 'dict.TODO';
ft_dot_dictdel5: ft_dot_dictdel6;
ft_dot_dictdel6: 'term.TODO';
ft_dot_dictdel9: ft_dot_dictdel10;
ft_dot_dictdel10: 'term.TODO';
ft_dot_dictdel8: ft_dot_dictdel9;
ft_dot_dictdel7: ft_dot_dictdel8 | ft_dot_dictdel7 ft_dot_dictdel8 | ;
ft_dot_dictdel0: ft_dot_dictdel1 ft_dot_dictdel3 ft_dot_dictdel5 ft_dot_dictdel7;

*/
// FT.DICTDUMP dict 
// ft_dot_dictdump: ft_dot_dictdump0;
// todo: {'dict'}
/*
ft_dot_dictdump1: FT_DOT_DICTDUMP2;
FT_DOT_DICTDUMP2: 'ft.dictdump';
ft_dot_dictdump3: ft_dot_dictdump4;
ft_dot_dictdump4: 'dict.TODO';
ft_dot_dictdump0: ft_dot_dictdump1 ft_dot_dictdump3;

*/
// FT.DROPINDEX index    [DD] 
ft_dot_dropindex: ft_dot_dropindex0;
ft_dot_dropindex1: FT_DOT_DROPINDEX2;
FT_DOT_DROPINDEX2: 'ft.dropindex';
ft_dot_dropindex3: index;
ft_dot_dropindex6: FT_DOT_DROPINDEX7;
FT_DOT_DROPINDEX7: 'dd';
ft_dot_dropindex5: ft_dot_dropindex6;
ft_dot_dropindex4: ft_dot_dropindex5 | ;
ft_dot_dropindex0: ft_dot_dropindex1 ft_dot_dropindex3 ft_dot_dropindex4;

// FT.EXPLAIN index query    [DIALECT dialect] 
ft_dot_explain: ft_dot_explain0;
ft_dot_explain1: FT_DOT_EXPLAIN2;
FT_DOT_EXPLAIN2: 'ft.explain';
ft_dot_explain3: index;
ft_dot_explain4: query;
ft_dot_explain7: FT_DOT_EXPLAIN8;
FT_DOT_EXPLAIN8: 'dialect';
ft_dot_explain9: dialect;
ft_dot_explain6: ft_dot_explain7 ft_dot_explain9;
ft_dot_explain5: ft_dot_explain6 | ;
ft_dot_explain0: ft_dot_explain1 ft_dot_explain3 ft_dot_explain4 ft_dot_explain5;

// FT.EXPLAINCLI index query    [DIALECT dialect] 
ft_dot_explaincli: ft_dot_explaincli0;
ft_dot_explaincli1: FT_DOT_EXPLAINCLI2;
FT_DOT_EXPLAINCLI2: 'ft.explaincli';
ft_dot_explaincli3: index;
ft_dot_explaincli4: query;
ft_dot_explaincli7: FT_DOT_EXPLAIN8;
ft_dot_explaincli8: dialect;
ft_dot_explaincli6: ft_dot_explaincli7 ft_dot_explaincli8;
ft_dot_explaincli5: ft_dot_explaincli6 | ;
ft_dot_explaincli0: ft_dot_explaincli1 ft_dot_explaincli3 ft_dot_explaincli4 ft_dot_explaincli5;

// FT.INFO index 
ft_dot_info: ft_dot_info0;
ft_dot_info1: FT_DOT_INFO2;
FT_DOT_INFO2: 'ft.info';
ft_dot_info3: index;
ft_dot_info0: ft_dot_info1 ft_dot_info3;

// FT.PROFILE index SEARCH | AGGREGATE [LIMITED] QUERY query 
ft_dot_profile: ft_dot_profile0;
ft_dot_profile1: FT_DOT_PROFILE2;
FT_DOT_PROFILE2: 'ft.profile';
ft_dot_profile3: index;
ft_dot_profile5: FT_DOT_PROFILE6;
FT_DOT_PROFILE6: 'search';
ft_dot_profile7: FT_DOT_PROFILE8;
FT_DOT_PROFILE8: 'aggregate';
ft_dot_profile4: ft_dot_profile5 | ft_dot_profile7;
ft_dot_profile11: FT_DOT_PROFILE12;
FT_DOT_PROFILE12: 'limited';
ft_dot_profile10: ft_dot_profile11;
ft_dot_profile9: ft_dot_profile10 | ;
ft_dot_profile13: FT_DOT_PROFILE14;
FT_DOT_PROFILE14: 'query';
ft_dot_profile15: query;
ft_dot_profile0: ft_dot_profile1 ft_dot_profile3 ft_dot_profile4 ft_dot_profile9 ft_dot_profile13 ft_dot_profile15;

// FT.SEARCH index query    [NOCONTENT]    [VERBATIM] [NOSTOPWORDS]    [WITHSCORES]    [WITHPAYLOADS]    [WITHSORTKEYS]    [ FILTER numeric_field min max [ FILTER numeric_field min max ...]]    [ GEOFILTER geo_field lon lat radius m | km | mi | ft [ GEOFILTER geo_field lon lat radius <m | km | mi | ft> ...]]    [ INKEYS count key [key ...]] [ INFIELDS count field [field ...]]    [ RETURN count identifier [AS property] [ identifier [AS property] ...]]    [ SUMMARIZE [ FIELDS count field [field ...]] [FRAGS num] [LEN fragsize]]    [ HIGHLIGHT [ FIELDS count field [field ...]] [ TAGS open close]]    [SLOP slop]    [TIMEOUT timeout]    [INORDER]    [LANGUAGE language]    [EXPLAINSCORE]    [PAYLOAD payload]    [ SORTBY sortby [ ASC | DESC]]    [ LIMIT offset num]    [ PARAMS nargs name value [ name value ...]]    [DIALECT dialect] 
ft_dot_search: ft_dot_search0;
ft_dot_search1: FT_DOT_SEARCH2;
FT_DOT_SEARCH2: 'ft.search';
ft_dot_search3: index;
ft_dot_search4: query;
ft_dot_search7: FT_DOT_SEARCH8;
FT_DOT_SEARCH8: 'nocontent';
ft_dot_search6: ft_dot_search7;
ft_dot_search5: ft_dot_search6 | ;
ft_dot_search11: FT_DOT_SEARCH12;
FT_DOT_SEARCH12: 'verbatim';
ft_dot_search10: ft_dot_search11;
ft_dot_search9: ft_dot_search10 | ;
ft_dot_search15: FT_DOT_SEARCH16;
FT_DOT_SEARCH16: 'nostopwords';
ft_dot_search14: ft_dot_search15;
ft_dot_search13: ft_dot_search14 | ;
ft_dot_search19: FT_DOT_SEARCH20;
FT_DOT_SEARCH20: 'withscores';
ft_dot_search18: ft_dot_search19;
ft_dot_search17: ft_dot_search18 | ;
ft_dot_search23: FT_DOT_SEARCH24;
FT_DOT_SEARCH24: 'withpayloads';
ft_dot_search22: ft_dot_search23;
ft_dot_search21: ft_dot_search22 | ;
ft_dot_search27: FT_DOT_SEARCH28;
FT_DOT_SEARCH28: 'withsortkeys';
ft_dot_search26: ft_dot_search27;
ft_dot_search25: ft_dot_search26 | ;
ft_dot_search31: FT_DOT_SEARCH32;
FT_DOT_SEARCH32: 'filter';
ft_dot_search33: numeric_field;
ft_dot_search34: min;
ft_dot_search35: max;
ft_dot_search38: FT_DOT_SEARCH32;
ft_dot_search39: numeric_field;
ft_dot_search40: min;
ft_dot_search41: max;
ft_dot_search37: ft_dot_search38 ft_dot_search39 ft_dot_search40 ft_dot_search41;
ft_dot_search36: ft_dot_search37 | ft_dot_search36 ft_dot_search37 | ;
ft_dot_search30: ft_dot_search31 ft_dot_search33 ft_dot_search34 ft_dot_search35 ft_dot_search36;
ft_dot_search29: ft_dot_search30 | ;
ft_dot_search44: FT_DOT_SEARCH45;
FT_DOT_SEARCH45: 'geofilter';
ft_dot_search46: geo_field;
ft_dot_search47: lon;
ft_dot_search48: lat;
ft_dot_search49: radius;
ft_dot_search53: m;
ft_dot_search54: km;
ft_dot_search52: ft_dot_search53 | ft_dot_search54;
ft_dot_search55: mi;
ft_dot_search51: ft_dot_search52 | ft_dot_search55;
ft_dot_search56: ft;
ft_dot_search50: ft_dot_search51 | ft_dot_search56;
ft_dot_search59: FT_DOT_SEARCH45;
ft_dot_search60: geo_field;
ft_dot_search61: lon;
ft_dot_search62: lat;
ft_dot_search63: radius;
ft_dot_search69: m;
ft_dot_search70: km;
ft_dot_search68: ft_dot_search69 | ft_dot_search70;
ft_dot_search71: mi;
ft_dot_search67: ft_dot_search68 | ft_dot_search71;
ft_dot_search72: ft;
ft_dot_search66: ft_dot_search67 | ft_dot_search72;
ft_dot_search65: ft_dot_search66;
ft_dot_search64: ft_dot_search65;
ft_dot_search58: ft_dot_search59 ft_dot_search60 ft_dot_search61 ft_dot_search62 ft_dot_search63 ft_dot_search64;
ft_dot_search57: ft_dot_search58 | ft_dot_search57 ft_dot_search58 | ;
ft_dot_search43: ft_dot_search44 ft_dot_search46 ft_dot_search47 ft_dot_search48 ft_dot_search49 ft_dot_search50 ft_dot_search57;
ft_dot_search42: ft_dot_search43 | ;
ft_dot_search75: FT_DOT_SEARCH76;
FT_DOT_SEARCH76: 'inkeys';
ft_dot_search77: count;
ft_dot_search78: key;
ft_dot_search81: key;
ft_dot_search80: ft_dot_search81;
ft_dot_search79: ft_dot_search80 | ft_dot_search79 ft_dot_search80 | ;
ft_dot_search74: ft_dot_search75 ft_dot_search77 ft_dot_search78 ft_dot_search79;
ft_dot_search73: ft_dot_search74 | ;
ft_dot_search84: FT_DOT_SEARCH85;
FT_DOT_SEARCH85: 'infields';
ft_dot_search86: count;
ft_dot_search87: field;
ft_dot_search90: field;
ft_dot_search89: ft_dot_search90;
ft_dot_search88: ft_dot_search89 | ft_dot_search88 ft_dot_search89 | ;
ft_dot_search83: ft_dot_search84 ft_dot_search86 ft_dot_search87 ft_dot_search88;
ft_dot_search82: ft_dot_search83 | ;
ft_dot_search93: FT_DOT_SEARCH94;
FT_DOT_SEARCH94: 'return';
ft_dot_search95: count;
ft_dot_search96: identifier;
ft_dot_search99: FT_DOT_SEARCH100;
FT_DOT_SEARCH100: 'as';
ft_dot_search101: property;
ft_dot_search98: ft_dot_search99 ft_dot_search101;
ft_dot_search97: ft_dot_search98 | ;
ft_dot_search104: identifier;
ft_dot_search107: FT_DOT_SEARCH100;
ft_dot_search108: property;
ft_dot_search106: ft_dot_search107 ft_dot_search108;
ft_dot_search105: ft_dot_search106 | ;
ft_dot_search103: ft_dot_search104 ft_dot_search105;
ft_dot_search102: ft_dot_search103 | ft_dot_search102 ft_dot_search103 | ;
ft_dot_search92: ft_dot_search93 ft_dot_search95 ft_dot_search96 ft_dot_search97 ft_dot_search102;
ft_dot_search91: ft_dot_search92 | ;
ft_dot_search111: FT_DOT_SEARCH112;
FT_DOT_SEARCH112: 'summarize';
ft_dot_search115: FT_DOT_SEARCH116;
FT_DOT_SEARCH116: 'fields';
ft_dot_search117: count;
ft_dot_search118: field;
ft_dot_search121: field;
ft_dot_search120: ft_dot_search121;
ft_dot_search119: ft_dot_search120 | ft_dot_search119 ft_dot_search120 | ;
ft_dot_search114: ft_dot_search115 ft_dot_search117 ft_dot_search118 ft_dot_search119;
ft_dot_search113: ft_dot_search114 | ;
ft_dot_search124: FT_DOT_SEARCH125;
FT_DOT_SEARCH125: 'frags';
ft_dot_search126: num;
ft_dot_search123: ft_dot_search124 ft_dot_search126;
ft_dot_search122: ft_dot_search123 | ;
ft_dot_search129: FT_DOT_SEARCH130;
FT_DOT_SEARCH130: 'len';
ft_dot_search131: fragsize;
ft_dot_search128: ft_dot_search129 ft_dot_search131;
ft_dot_search127: ft_dot_search128 | ;
ft_dot_search110: ft_dot_search111 ft_dot_search113 ft_dot_search122 ft_dot_search127;
ft_dot_search109: ft_dot_search110 | ;
ft_dot_search134: FT_DOT_SEARCH135;
FT_DOT_SEARCH135: 'highlight';
ft_dot_search138: FT_DOT_SEARCH116;
ft_dot_search139: count;
ft_dot_search140: field;
ft_dot_search143: field;
ft_dot_search142: ft_dot_search143;
ft_dot_search141: ft_dot_search142 | ft_dot_search141 ft_dot_search142 | ;
ft_dot_search137: ft_dot_search138 ft_dot_search139 ft_dot_search140 ft_dot_search141;
ft_dot_search136: ft_dot_search137 | ;
ft_dot_search146: FT_DOT_SEARCH147;
FT_DOT_SEARCH147: 'tags';
ft_dot_search148: open;
ft_dot_search149: close;
ft_dot_search145: ft_dot_search146 ft_dot_search148 ft_dot_search149;
ft_dot_search144: ft_dot_search145 | ;
ft_dot_search133: ft_dot_search134 ft_dot_search136 ft_dot_search144;
ft_dot_search132: ft_dot_search133 | ;
ft_dot_search152: FT_DOT_SEARCH153;
FT_DOT_SEARCH153: 'slop';
ft_dot_search154: slop;
ft_dot_search151: ft_dot_search152 ft_dot_search154;
ft_dot_search150: ft_dot_search151 | ;
ft_dot_search157: FT_DOT_SEARCH158;
FT_DOT_SEARCH158: 'timeout';
ft_dot_search159: timeout;
ft_dot_search156: ft_dot_search157 ft_dot_search159;
ft_dot_search155: ft_dot_search156 | ;
ft_dot_search162: FT_DOT_SEARCH163;
FT_DOT_SEARCH163: 'inorder';
ft_dot_search161: ft_dot_search162;
ft_dot_search160: ft_dot_search161 | ;
ft_dot_search166: FT_DOT_SEARCH167;
FT_DOT_SEARCH167: 'language';
ft_dot_search168: language;
ft_dot_search165: ft_dot_search166 ft_dot_search168;
ft_dot_search164: ft_dot_search165 | ;
ft_dot_search171: FT_DOT_SEARCH172;
FT_DOT_SEARCH172: 'explainscore';
ft_dot_search170: ft_dot_search171;
ft_dot_search169: ft_dot_search170 | ;
ft_dot_search175: FT_DOT_SEARCH176;
FT_DOT_SEARCH176: 'payload';
ft_dot_search177: payload;
ft_dot_search174: ft_dot_search175 ft_dot_search177;
ft_dot_search173: ft_dot_search174 | ;
ft_dot_search180: FT_DOT_SEARCH181;
FT_DOT_SEARCH181: 'sortby';
ft_dot_search182: sortby;
ft_dot_search186: FT_DOT_SEARCH187;
FT_DOT_SEARCH187: 'asc';
ft_dot_search188: FT_DOT_SEARCH189;
FT_DOT_SEARCH189: 'desc';
ft_dot_search185: ft_dot_search186 | ft_dot_search188;
ft_dot_search184: ft_dot_search185;
ft_dot_search183: ft_dot_search184 | ;
ft_dot_search179: ft_dot_search180 ft_dot_search182 ft_dot_search183;
ft_dot_search178: ft_dot_search179 | ;
ft_dot_search192: FT_DOT_SEARCH193;
FT_DOT_SEARCH193: 'limit';
ft_dot_search194: offset;
ft_dot_search195: num;
ft_dot_search191: ft_dot_search192 ft_dot_search194 ft_dot_search195;
ft_dot_search190: ft_dot_search191 | ;
ft_dot_search198: FT_DOT_SEARCH199;
FT_DOT_SEARCH199: 'params';
ft_dot_search200: nargs;
ft_dot_search201: name;
ft_dot_search202: value;
ft_dot_search205: name;
ft_dot_search206: value;
ft_dot_search204: ft_dot_search205 ft_dot_search206;
ft_dot_search203: ft_dot_search204 | ft_dot_search203 ft_dot_search204 | ;
ft_dot_search197: ft_dot_search198 ft_dot_search200 ft_dot_search201 ft_dot_search202 ft_dot_search203;
ft_dot_search196: ft_dot_search197 | ;
ft_dot_search209: FT_DOT_EXPLAIN8;
ft_dot_search210: dialect;
ft_dot_search208: ft_dot_search209 ft_dot_search210;
ft_dot_search207: ft_dot_search208 | ;
ft_dot_search0: ft_dot_search1 ft_dot_search3 ft_dot_search4 ft_dot_search5 ft_dot_search9 ft_dot_search13 ft_dot_search17 ft_dot_search21 ft_dot_search25 ft_dot_search29 ft_dot_search42 ft_dot_search73 ft_dot_search82 ft_dot_search91 ft_dot_search109 ft_dot_search132 ft_dot_search150 ft_dot_search155 ft_dot_search160 ft_dot_search164 ft_dot_search169 ft_dot_search173 ft_dot_search178 ft_dot_search190 ft_dot_search196 ft_dot_search207;

// FT.SPELLCHECK index query    [DISTANCE distance]    [TERMS INCLUDE | EXCLUDE dictionary [terms [terms ...]]]    [DIALECT dialect] 
// ft_dot_spellcheck: ft_dot_spellcheck0;
// todo: {'distance', 'dictionary', 'terms'}
/*
ft_dot_spellcheck1: FT_DOT_SPELLCHECK2;
FT_DOT_SPELLCHECK2: 'ft.spellcheck';
ft_dot_spellcheck3: index;
ft_dot_spellcheck4: query;
ft_dot_spellcheck7: FT_DOT_SPELLCHECK8;
FT_DOT_SPELLCHECK8: 'distance';
ft_dot_spellcheck9: ft_dot_spellcheck10;
ft_dot_spellcheck10: 'distance.TODO';
ft_dot_spellcheck6: ft_dot_spellcheck7 ft_dot_spellcheck9;
ft_dot_spellcheck5: ft_dot_spellcheck6 | ;
ft_dot_spellcheck13: FT_DOT_SPELLCHECK14;
FT_DOT_SPELLCHECK14: 'terms';
ft_dot_spellcheck16: FT_DOT_SPELLCHECK17;
FT_DOT_SPELLCHECK17: 'include';
ft_dot_spellcheck18: FT_DOT_SPELLCHECK19;
FT_DOT_SPELLCHECK19: 'exclude';
ft_dot_spellcheck15: ft_dot_spellcheck16 | ft_dot_spellcheck18;
ft_dot_spellcheck20: ft_dot_spellcheck21;
ft_dot_spellcheck21: 'dictionary.TODO';
ft_dot_spellcheck24: ft_dot_spellcheck25;
ft_dot_spellcheck25: 'terms.TODO';
ft_dot_spellcheck28: ft_dot_spellcheck29;
ft_dot_spellcheck29: 'terms.TODO';
ft_dot_spellcheck27: ft_dot_spellcheck28;
ft_dot_spellcheck26: ft_dot_spellcheck27 | ft_dot_spellcheck26 ft_dot_spellcheck27 | ;
ft_dot_spellcheck23: ft_dot_spellcheck24 ft_dot_spellcheck26;
ft_dot_spellcheck22: ft_dot_spellcheck23 | ;
ft_dot_spellcheck12: ft_dot_spellcheck13 ft_dot_spellcheck15 ft_dot_spellcheck20 ft_dot_spellcheck22;
ft_dot_spellcheck11: ft_dot_spellcheck12 | ;
ft_dot_spellcheck32: FT_DOT_EXPLAIN8;
ft_dot_spellcheck33: dialect;
ft_dot_spellcheck31: ft_dot_spellcheck32 ft_dot_spellcheck33;
ft_dot_spellcheck30: ft_dot_spellcheck31 | ;
ft_dot_spellcheck0: ft_dot_spellcheck1 ft_dot_spellcheck3 ft_dot_spellcheck4 ft_dot_spellcheck5 ft_dot_spellcheck11 ft_dot_spellcheck30;

*/
// FT.SUGADD key string score    [INCR]    [PAYLOAD payload] 
ft_dot_sugadd: ft_dot_sugadd0;
ft_dot_sugadd1: FT_DOT_SUGADD2;
FT_DOT_SUGADD2: 'ft.sugadd';
ft_dot_sugadd3: key;
ft_dot_sugadd4: string;
ft_dot_sugadd5: score;
ft_dot_sugadd8: FT_DOT_SUGADD9;
FT_DOT_SUGADD9: 'incr';
ft_dot_sugadd7: ft_dot_sugadd8;
ft_dot_sugadd6: ft_dot_sugadd7 | ;
ft_dot_sugadd12: FT_DOT_SEARCH176;
ft_dot_sugadd13: payload;
ft_dot_sugadd11: ft_dot_sugadd12 ft_dot_sugadd13;
ft_dot_sugadd10: ft_dot_sugadd11 | ;
ft_dot_sugadd0: ft_dot_sugadd1 ft_dot_sugadd3 ft_dot_sugadd4 ft_dot_sugadd5 ft_dot_sugadd6 ft_dot_sugadd10;

// FT.SUGDEL key string 
ft_dot_sugdel: ft_dot_sugdel0;
ft_dot_sugdel1: FT_DOT_SUGDEL2;
FT_DOT_SUGDEL2: 'ft.sugdel';
ft_dot_sugdel3: key;
ft_dot_sugdel4: string;
ft_dot_sugdel0: ft_dot_sugdel1 ft_dot_sugdel3 ft_dot_sugdel4;

// FT.SUGGET key prefix    [FUZZY]    [WITHSCORES]    [WITHPAYLOADS]    [MAX max] 
// ft_dot_sugget: ft_dot_sugget0;
// todo: {'prefix'}
/*
ft_dot_sugget1: FT_DOT_SUGGET2;
FT_DOT_SUGGET2: 'ft.sugget';
ft_dot_sugget3: key;
ft_dot_sugget4: ft_dot_sugget5;
ft_dot_sugget5: 'prefix.TODO';
ft_dot_sugget8: FT_DOT_SUGGET9;
FT_DOT_SUGGET9: 'fuzzy';
ft_dot_sugget7: ft_dot_sugget8;
ft_dot_sugget6: ft_dot_sugget7 | ;
ft_dot_sugget12: FT_DOT_SEARCH20;
ft_dot_sugget11: ft_dot_sugget12;
ft_dot_sugget10: ft_dot_sugget11 | ;
ft_dot_sugget15: FT_DOT_SEARCH24;
ft_dot_sugget14: ft_dot_sugget15;
ft_dot_sugget13: ft_dot_sugget14 | ;
ft_dot_sugget18: BZMPOP15;
ft_dot_sugget19: max;
ft_dot_sugget17: ft_dot_sugget18 ft_dot_sugget19;
ft_dot_sugget16: ft_dot_sugget17 | ;
ft_dot_sugget0: ft_dot_sugget1 ft_dot_sugget3 ft_dot_sugget4 ft_dot_sugget6 ft_dot_sugget10 ft_dot_sugget13 ft_dot_sugget16;

*/
// FT.SUGLEN key 
ft_dot_suglen: ft_dot_suglen0;
ft_dot_suglen1: FT_DOT_SUGLEN2;
FT_DOT_SUGLEN2: 'ft.suglen';
ft_dot_suglen3: key;
ft_dot_suglen0: ft_dot_suglen1 ft_dot_suglen3;

// FT.SYNDUMP index 
ft_dot_syndump: ft_dot_syndump0;
ft_dot_syndump1: FT_DOT_SYNDUMP2;
FT_DOT_SYNDUMP2: 'ft.syndump';
ft_dot_syndump3: index;
ft_dot_syndump0: ft_dot_syndump1 ft_dot_syndump3;

// FT.SYNUPDATE index synonym_group_id    [SKIPINITIALSCAN] term [term ...] 
// ft_dot_synupdate: ft_dot_synupdate0;
// todo: {'synonym_group_id', 'term'}
/*
ft_dot_synupdate1: FT_DOT_SYNUPDATE2;
FT_DOT_SYNUPDATE2: 'ft.synupdate';
ft_dot_synupdate3: index;
ft_dot_synupdate4: ft_dot_synupdate5;
ft_dot_synupdate5: 'synonym_group_id.TODO';
ft_dot_synupdate8: FT_DOT_SYNUPDATE9;
FT_DOT_SYNUPDATE9: 'skipinitialscan';
ft_dot_synupdate7: ft_dot_synupdate8;
ft_dot_synupdate6: ft_dot_synupdate7 | ;
ft_dot_synupdate10: ft_dot_synupdate11;
ft_dot_synupdate11: 'term.TODO';
ft_dot_synupdate14: ft_dot_synupdate15;
ft_dot_synupdate15: 'term.TODO';
ft_dot_synupdate13: ft_dot_synupdate14;
ft_dot_synupdate12: ft_dot_synupdate13 | ft_dot_synupdate12 ft_dot_synupdate13 | ;
ft_dot_synupdate0: ft_dot_synupdate1 ft_dot_synupdate3 ft_dot_synupdate4 ft_dot_synupdate6 ft_dot_synupdate10 ft_dot_synupdate12;

*/
// FT.TAGVALS index field_name 
// ft_dot_tagvals: ft_dot_tagvals0;
// todo: {'field_name'}
/*
ft_dot_tagvals1: FT_DOT_TAGVALS2;
FT_DOT_TAGVALS2: 'ft.tagvals';
ft_dot_tagvals3: index;
ft_dot_tagvals4: ft_dot_tagvals5;
ft_dot_tagvals5: 'field_name.TODO';
ft_dot_tagvals0: ft_dot_tagvals1 ft_dot_tagvals3 ft_dot_tagvals4;

*/
// FUNCTION DELETE library_name
// function_sp_delete: function_sp_delete0;
// todo: {'library_name'}
/*
function_sp_delete1: FUNCTION_SP_DELETE2;
FUNCTION_SP_DELETE2: 'function';
function_sp_delete3: FUNCTION_SP_DELETE4;
FUNCTION_SP_DELETE4: 'delete';
function_sp_delete5: function_sp_delete6;
function_sp_delete6: 'library_name.TODO';
function_sp_delete0: function_sp_delete1 function_sp_delete3 function_sp_delete5;

*/
// FUNCTION DUMP
function_sp_dump: function_sp_dump0;
function_sp_dump1: FUNCTION_SP_DUMP2;
FUNCTION_SP_DUMP2: 'function';
function_sp_dump3: DUMP2;
function_sp_dump0: function_sp_dump1 function_sp_dump3;

// FUNCTION FLUSH [ASYNC | SYNC]
function_sp_flush: function_sp_flush0;
function_sp_flush1: FUNCTION_SP_DUMP2;
function_sp_flush2: FUNCTION_SP_FLUSH3;
FUNCTION_SP_FLUSH3: 'flush';
function_sp_flush7: FLUSHALL7;
function_sp_flush8: FLUSHALL9;
function_sp_flush6: function_sp_flush7 | function_sp_flush8;
function_sp_flush5: function_sp_flush6;
function_sp_flush4: function_sp_flush5 | ;
function_sp_flush0: function_sp_flush1 function_sp_flush2 function_sp_flush4;

// FUNCTION KILL
function_sp_kill: function_sp_kill0;
function_sp_kill1: FUNCTION_SP_DUMP2;
function_sp_kill2: FUNCTION_SP_KILL3;
FUNCTION_SP_KILL3: 'kill';
function_sp_kill0: function_sp_kill1 function_sp_kill2;

// FUNCTION LIST [LIBRARYNAME library_name_pattern] [WITHCODE]
// function_sp_list: function_sp_list0;
// todo: {'library_name_pattern'}
/*
function_sp_list1: FUNCTION_SP_DUMP2;
function_sp_list2: ACL_SP_LIST3;
function_sp_list5: FUNCTION_SP_LIST6;
FUNCTION_SP_LIST6: 'libraryname';
function_sp_list7: function_sp_list8;
function_sp_list8: 'library_name_pattern.TODO';
function_sp_list4: function_sp_list5 function_sp_list7;
function_sp_list3: function_sp_list4 | ;
function_sp_list11: FUNCTION_SP_LIST12;
FUNCTION_SP_LIST12: 'withcode';
function_sp_list10: function_sp_list11;
function_sp_list9: function_sp_list10 | ;
function_sp_list0: function_sp_list1 function_sp_list2 function_sp_list3 function_sp_list9;

*/
// FUNCTION LOAD [REPLACE] function_code
// function_sp_load: function_sp_load0;
// todo: {'function_code'}
/*
function_sp_load1: FUNCTION_SP_DUMP2;
function_sp_load2: ACL_SP_LOAD3;
function_sp_load5: COPY13;
function_sp_load4: function_sp_load5;
function_sp_load3: function_sp_load4 | ;
function_sp_load6: function_sp_load7;
function_sp_load7: 'function_code.TODO';
function_sp_load0: function_sp_load1 function_sp_load2 function_sp_load3 function_sp_load6;

*/
// FUNCTION RESTORE serialized_value [FLUSH | APPEND | REPLACE]
function_sp_restore: function_sp_restore0;
function_sp_restore1: FUNCTION_SP_DUMP2;
function_sp_restore2: FUNCTION_SP_RESTORE3;
FUNCTION_SP_RESTORE3: 'restore';
function_sp_restore4: serialized_value;
function_sp_restore9: FUNCTION_SP_FLUSH3;
function_sp_restore10: APPEND2;
function_sp_restore8: function_sp_restore9 | function_sp_restore10;
function_sp_restore11: COPY13;
function_sp_restore7: function_sp_restore8 | function_sp_restore11;
function_sp_restore6: function_sp_restore7;
function_sp_restore5: function_sp_restore6 | ;
function_sp_restore0: function_sp_restore1 function_sp_restore2 function_sp_restore4 function_sp_restore5;

// FUNCTION STATS
function_sp_stats: function_sp_stats0;
function_sp_stats1: FUNCTION_SP_DUMP2;
function_sp_stats2: FUNCTION_SP_STATS3;
FUNCTION_SP_STATS3: 'stats';
function_sp_stats0: function_sp_stats1 function_sp_stats2;

// GEOADD key [NX | XX] [CH] longitude latitude member [longitude   latitude member ...]
geoadd: geoadd0;
geoadd1: GEOADD2;
GEOADD2: 'geoadd';
geoadd3: elem=key #GeoAddRule1;
geoadd7: EXPIRE11;
geoadd8: EXPIRE13;
geoadd6: geoadd7 | geoadd8;
geoadd5: geoadd6;
geoadd4: geoadd5 | ;
geoadd11: GEOADD12;
GEOADD12: 'ch';
geoadd10: geoadd11;
geoadd9: geoadd10 | ;
geoadd13: longitude;
geoadd14: latitude;
geoadd15: elem=member #GeoAddRuleMember1;
geoadd18: longitude;
geoadd19: latitude;
geoadd20: member;
geoadd17: geoadd18 geoadd19 geoadd20;
geoadd16: geoadd17 | geoadd16 geoadd17 | ;
geoadd0: geoadd1 geoadd3 geoadd4 geoadd9 geoadd13 geoadd14 geoadd15 geoadd16;

// GEODIST key member1 member2 [M | KM | FT | MI]
geodist: geodist0;
geodist1: GEODIST2;
GEODIST2: 'geodist';
geodist3: elem=key #GeoDistRule1;
geodist4: elem=member1 #GeoDistRule2;
geodist5: elem=member2 #GeoDistRule3;
geodist11: GEODIST12;
GEODIST12: 'm';
geodist13: GEODIST14;
GEODIST14: 'km';
geodist10: geodist11 | geodist13;
geodist15: GEODIST16;
GEODIST16: 'ft';
geodist9: geodist10 | geodist15;
geodist17: GEODIST18;
GEODIST18: 'mi';
geodist8: geodist9 | geodist17;
geodist7: geodist8;
geodist6: geodist7 | ;
geodist0: geodist1 geodist3 geodist4 geodist5 geodist6;

// GEOHASH key member [member ...]
geohash: geohash0;
geohash1: GEOHASH2;
GEOHASH2: 'geohash';
geohash3: elem=key #GeoHashRule1;
geohash4: elem=member #GeoHashRule2;
geohash7: elem=member #GeoHashRule3;
geohash6: geohash7;
geohash5: geohash6 | geohash5 geohash6 | ;
geohash0: geohash1 geohash3 geohash4 geohash5;

// GEOPOS key member [member ...]
geopos: geopos0;
geopos1: GEOPOS2;
GEOPOS2: 'geopos';
geopos3: elem=key #GeoPosRule1;
geopos4: elem=member #GeoPosRule2;
geopos7: elem=member #GeoPosRule3;
geopos6: geopos7;
geopos5: geopos6 | geopos5 geopos6 | ;
geopos0: geopos1 geopos3 geopos4 geopos5;

// GEORADIUS key longitude latitude radius <M | KM | FT | MI>   [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count [ANY]] [ASC | DESC]   [STORE key] [STOREDIST key]
georadius: georadius0;
georadius1: GEORADIUS2;
GEORADIUS2: 'georadius';
georadius3: elem=key #GeoRadiusRule1;
georadius4: longitude;
georadius5: latitude;
georadius6: radius;
georadius12: GEODIST12;
georadius13: GEODIST14;
georadius11: georadius12 | georadius13;
georadius14: GEODIST16;
georadius10: georadius11 | georadius14;
georadius15: GEODIST18;
georadius9: georadius10 | georadius15;
georadius8: georadius9;
georadius7: georadius8;
georadius18: GEORADIUS19;
GEORADIUS19: 'withcoord';
georadius17: georadius18;
georadius16: georadius17 | ;
georadius22: GEORADIUS23;
GEORADIUS23: 'withdist';
georadius21: georadius22;
georadius20: georadius21 | ;
georadius26: GEORADIUS27;
GEORADIUS27: 'withhash';
georadius25: georadius26;
georadius24: georadius25 | ;
georadius30: BLMPOP17;
georadius31: count;
georadius34: GEORADIUS35;
GEORADIUS35: 'any';
georadius33: georadius34;
georadius32: georadius33 | ;
georadius29: georadius30 georadius31 georadius32;
georadius28: georadius29 | ;
georadius39: FT_DOT_SEARCH187;
georadius40: FT_DOT_SEARCH189;
georadius38: georadius39 | georadius40;
georadius37: georadius38;
georadius36: georadius37 | ;
georadius43: GEORADIUS44;
GEORADIUS44: 'store';
georadius45: key;
georadius42: georadius43 georadius45;
georadius41: georadius42 | ;
georadius48: GEORADIUS49;
GEORADIUS49: 'storedist';
georadius50: key;
georadius47: georadius48 georadius50;
georadius46: georadius47 | ;
georadius0: georadius1 georadius3 georadius4 georadius5 georadius6 georadius7 georadius16 georadius20 georadius24 georadius28 georadius36 georadius41 georadius46;

// GEORADIUS_RO key longitude latitude radius <M | KM | FT | MI>   [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count [ANY]] [ASC | DESC]
georadius_ro: georadius_ro0;
georadius_ro1: GEORADIUS_RO2;
GEORADIUS_RO2: 'georadius_ro';
georadius_ro3: key;
georadius_ro4: longitude;
georadius_ro5: latitude;
georadius_ro6: radius;
georadius_ro12: GEODIST12;
georadius_ro13: GEODIST14;
georadius_ro11: georadius_ro12 | georadius_ro13;
georadius_ro14: GEODIST16;
georadius_ro10: georadius_ro11 | georadius_ro14;
georadius_ro15: GEODIST18;
georadius_ro9: georadius_ro10 | georadius_ro15;
georadius_ro8: georadius_ro9;
georadius_ro7: georadius_ro8;
georadius_ro18: GEORADIUS19;
georadius_ro17: georadius_ro18;
georadius_ro16: georadius_ro17 | ;
georadius_ro21: GEORADIUS23;
georadius_ro20: georadius_ro21;
georadius_ro19: georadius_ro20 | ;
georadius_ro24: GEORADIUS27;
georadius_ro23: georadius_ro24;
georadius_ro22: georadius_ro23 | ;
georadius_ro27: BLMPOP17;
georadius_ro28: count;
georadius_ro31: GEORADIUS35;
georadius_ro30: georadius_ro31;
georadius_ro29: georadius_ro30 | ;
georadius_ro26: georadius_ro27 georadius_ro28 georadius_ro29;
georadius_ro25: georadius_ro26 | ;
georadius_ro35: FT_DOT_SEARCH187;
georadius_ro36: FT_DOT_SEARCH189;
georadius_ro34: georadius_ro35 | georadius_ro36;
georadius_ro33: georadius_ro34;
georadius_ro32: georadius_ro33 | ;
georadius_ro0: georadius_ro1 georadius_ro3 georadius_ro4 georadius_ro5 georadius_ro6 georadius_ro7 georadius_ro16 georadius_ro19 georadius_ro22 georadius_ro25 georadius_ro32;

// GEORADIUSBYMEMBER key member radius <M | KM | FT | MI> [WITHCOORD]   [WITHDIST] [WITHHASH] [COUNT count [ANY]] [ASC | DESC] [STORE key]   [STOREDIST key]
georadiusbymember: georadiusbymember0;
georadiusbymember1: GEORADIUSBYMEMBER2;
GEORADIUSBYMEMBER2: 'georadiusbymember';
georadiusbymember3: key;
georadiusbymember4: member;
georadiusbymember5: radius;
georadiusbymember11: GEODIST12;
georadiusbymember12: GEODIST14;
georadiusbymember10: georadiusbymember11 | georadiusbymember12;
georadiusbymember13: GEODIST16;
georadiusbymember9: georadiusbymember10 | georadiusbymember13;
georadiusbymember14: GEODIST18;
georadiusbymember8: georadiusbymember9 | georadiusbymember14;
georadiusbymember7: georadiusbymember8;
georadiusbymember6: georadiusbymember7;
georadiusbymember17: GEORADIUS19;
georadiusbymember16: georadiusbymember17;
georadiusbymember15: georadiusbymember16 | ;
georadiusbymember20: GEORADIUS23;
georadiusbymember19: georadiusbymember20;
georadiusbymember18: georadiusbymember19 | ;
georadiusbymember23: GEORADIUS27;
georadiusbymember22: georadiusbymember23;
georadiusbymember21: georadiusbymember22 | ;
georadiusbymember26: BLMPOP17;
georadiusbymember27: count;
georadiusbymember30: GEORADIUS35;
georadiusbymember29: georadiusbymember30;
georadiusbymember28: georadiusbymember29 | ;
georadiusbymember25: georadiusbymember26 georadiusbymember27 georadiusbymember28;
georadiusbymember24: georadiusbymember25 | ;
georadiusbymember34: FT_DOT_SEARCH187;
georadiusbymember35: FT_DOT_SEARCH189;
georadiusbymember33: georadiusbymember34 | georadiusbymember35;
georadiusbymember32: georadiusbymember33;
georadiusbymember31: georadiusbymember32 | ;
georadiusbymember38: GEORADIUS44;
georadiusbymember39: key;
georadiusbymember37: georadiusbymember38 georadiusbymember39;
georadiusbymember36: georadiusbymember37 | ;
georadiusbymember42: GEORADIUS49;
georadiusbymember43: key;
georadiusbymember41: georadiusbymember42 georadiusbymember43;
georadiusbymember40: georadiusbymember41 | ;
georadiusbymember0: georadiusbymember1 georadiusbymember3 georadiusbymember4 georadiusbymember5 georadiusbymember6 georadiusbymember15 georadiusbymember18 georadiusbymember21 georadiusbymember24 georadiusbymember31 georadiusbymember36 georadiusbymember40;

// GEORADIUSBYMEMBER_RO key member radius <M | KM | FT | MI>   [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count [ANY]] [ASC | DESC]
georadiusbymember_ro: georadiusbymember_ro0;
georadiusbymember_ro1: GEORADIUSBYMEMBER_RO2;
GEORADIUSBYMEMBER_RO2: 'georadiusbymember_ro';
georadiusbymember_ro3: key;
georadiusbymember_ro4: member;
georadiusbymember_ro5: radius;
georadiusbymember_ro11: GEODIST12;
georadiusbymember_ro12: GEODIST14;
georadiusbymember_ro10: georadiusbymember_ro11 | georadiusbymember_ro12;
georadiusbymember_ro13: GEODIST16;
georadiusbymember_ro9: georadiusbymember_ro10 | georadiusbymember_ro13;
georadiusbymember_ro14: GEODIST18;
georadiusbymember_ro8: georadiusbymember_ro9 | georadiusbymember_ro14;
georadiusbymember_ro7: georadiusbymember_ro8;
georadiusbymember_ro6: georadiusbymember_ro7;
georadiusbymember_ro17: GEORADIUS19;
georadiusbymember_ro16: georadiusbymember_ro17;
georadiusbymember_ro15: georadiusbymember_ro16 | ;
georadiusbymember_ro20: GEORADIUS23;
georadiusbymember_ro19: georadiusbymember_ro20;
georadiusbymember_ro18: georadiusbymember_ro19 | ;
georadiusbymember_ro23: GEORADIUS27;
georadiusbymember_ro22: georadiusbymember_ro23;
georadiusbymember_ro21: georadiusbymember_ro22 | ;
georadiusbymember_ro26: BLMPOP17;
georadiusbymember_ro27: count;
georadiusbymember_ro30: GEORADIUS35;
georadiusbymember_ro29: georadiusbymember_ro30;
georadiusbymember_ro28: georadiusbymember_ro29 | ;
georadiusbymember_ro25: georadiusbymember_ro26 georadiusbymember_ro27 georadiusbymember_ro28;
georadiusbymember_ro24: georadiusbymember_ro25 | ;
georadiusbymember_ro34: FT_DOT_SEARCH187;
georadiusbymember_ro35: FT_DOT_SEARCH189;
georadiusbymember_ro33: georadiusbymember_ro34 | georadiusbymember_ro35;
georadiusbymember_ro32: georadiusbymember_ro33;
georadiusbymember_ro31: georadiusbymember_ro32 | ;
georadiusbymember_ro0: georadiusbymember_ro1 georadiusbymember_ro3 georadiusbymember_ro4 georadiusbymember_ro5 georadiusbymember_ro6 georadiusbymember_ro15 georadiusbymember_ro18 georadiusbymember_ro21 georadiusbymember_ro24 georadiusbymember_ro31;

// GEOSEARCH key <<FROMMEMBER member> | <FROMLONLAT longitude latitude>>   < <BYRADIUS radius <M | KM | FT | MI>> | <BYBOX width height <M | KM |   FT | MI>> > [ASC | DESC] [COUNT count [ANY]] [WITHCOORD] [WITHDIST]   [WITHHASH]
geosearch: geosearch0;
geosearch1: GEOSEARCH2;
GEOSEARCH2: 'geosearch';
geosearch3: elem=key #GeoSearchRule1;
geosearch9: GEOSEARCH10;
GEOSEARCH10: 'frommember';
geosearch11: elem=member #GeoSearchRule2;
geosearch8: geosearch9 geosearch11;
geosearch7: geosearch8;
geosearch14: GEOSEARCH15;
GEOSEARCH15: 'fromlonlat';
geosearch16: longitude;
geosearch17: latitude;
geosearch13: geosearch14 geosearch16 geosearch17;
geosearch12: geosearch13;
geosearch6: geosearch7 | geosearch12;
geosearch5: geosearch6;
geosearch4: geosearch5;
geosearch23: GEOSEARCH24;
GEOSEARCH24: 'byradius';
geosearch25: radius;
geosearch31: GEODIST12;
geosearch32: GEODIST14;
geosearch30: geosearch31 | geosearch32;
geosearch33: GEODIST16;
geosearch29: geosearch30 | geosearch33;
geosearch34: GEODIST18;
geosearch28: geosearch29 | geosearch34;
geosearch27: geosearch28;
geosearch26: geosearch27;
geosearch22: geosearch23 geosearch25 geosearch26;
geosearch21: geosearch22;
geosearch37: GEOSEARCH38;
GEOSEARCH38: 'bybox';
geosearch39: width;
geosearch40: height;
geosearch46: GEODIST12;
geosearch47: GEODIST14;
geosearch45: geosearch46 | geosearch47;
geosearch48: GEODIST16;
geosearch44: geosearch45 | geosearch48;
geosearch49: GEODIST18;
geosearch43: geosearch44 | geosearch49;
geosearch42: geosearch43;
geosearch41: geosearch42;
geosearch36: geosearch37 geosearch39 geosearch40 geosearch41;
geosearch35: geosearch36;
geosearch20: geosearch21 | geosearch35;
geosearch19: geosearch20;
geosearch18: geosearch19;
geosearch53: FT_DOT_SEARCH187;
geosearch54: FT_DOT_SEARCH189;
geosearch52: geosearch53 | geosearch54;
geosearch51: geosearch52;
geosearch50: geosearch51 | ;
geosearch57: BLMPOP17;
geosearch58: count;
geosearch61: GEORADIUS35;
geosearch60: geosearch61;
geosearch59: geosearch60 | ;
geosearch56: geosearch57 geosearch58 geosearch59;
geosearch55: geosearch56 | ;
geosearch64: GEORADIUS19;
geosearch63: geosearch64;
geosearch62: geosearch63 | ;
geosearch67: GEORADIUS23;
geosearch66: geosearch67;
geosearch65: geosearch66 | ;
geosearch70: GEORADIUS27;
geosearch69: geosearch70;
geosearch68: geosearch69 | ;
geosearch0: geosearch1 geosearch3 geosearch4 geosearch18 geosearch50 geosearch55 geosearch62 geosearch65 geosearch68;

// GEOSEARCHSTORE destination source <<FROMMEMBER member> |   <FROMLONLAT longitude latitude>> < <BYRADIUS radius <M | KM | FT | MI>>   | <BYBOX width height <M | KM | FT | MI>> > [ASC | DESC] [COUNT count   [ANY]] [STOREDIST]
geosearchstore: geosearchstore0;
geosearchstore1: GEOSEARCHSTORE2;
GEOSEARCHSTORE2: 'geosearchstore';
geosearchstore3: elem=destination #GeoSearchStoreRule1;
geosearchstore4: elem=source #GeoSearchStoreRule2;
geosearchstore10: GEOSEARCH10;
geosearchstore11: elem=member #GeoSearchStoreRule3;
geosearchstore9: geosearchstore10 geosearchstore11;
geosearchstore8: geosearchstore9;
geosearchstore14: GEOSEARCH15;
geosearchstore15: longitude;
geosearchstore16: latitude;
geosearchstore13: geosearchstore14 geosearchstore15 geosearchstore16;
geosearchstore12: geosearchstore13;
geosearchstore7: geosearchstore8 | geosearchstore12;
geosearchstore6: geosearchstore7;
geosearchstore5: geosearchstore6;
geosearchstore22: GEOSEARCH24;
geosearchstore23: radius;
geosearchstore29: GEODIST12;
geosearchstore30: GEODIST14;
geosearchstore28: geosearchstore29 | geosearchstore30;
geosearchstore31: GEODIST16;
geosearchstore27: geosearchstore28 | geosearchstore31;
geosearchstore32: GEODIST18;
geosearchstore26: geosearchstore27 | geosearchstore32;
geosearchstore25: geosearchstore26;
geosearchstore24: geosearchstore25;
geosearchstore21: geosearchstore22 geosearchstore23 geosearchstore24;
geosearchstore20: geosearchstore21;
geosearchstore35: GEOSEARCH38;
geosearchstore36: width;
geosearchstore37: height;
geosearchstore43: GEODIST12;
geosearchstore44: GEODIST14;
geosearchstore42: geosearchstore43 | geosearchstore44;
geosearchstore45: GEODIST16;
geosearchstore41: geosearchstore42 | geosearchstore45;
geosearchstore46: GEODIST18;
geosearchstore40: geosearchstore41 | geosearchstore46;
geosearchstore39: geosearchstore40;
geosearchstore38: geosearchstore39;
geosearchstore34: geosearchstore35 geosearchstore36 geosearchstore37 geosearchstore38;
geosearchstore33: geosearchstore34;
geosearchstore19: geosearchstore20 | geosearchstore33;
geosearchstore18: geosearchstore19;
geosearchstore17: geosearchstore18;
geosearchstore50: FT_DOT_SEARCH187;
geosearchstore51: FT_DOT_SEARCH189;
geosearchstore49: geosearchstore50 | geosearchstore51;
geosearchstore48: geosearchstore49;
geosearchstore47: geosearchstore48 | ;
geosearchstore54: BLMPOP17;
geosearchstore55: count;
geosearchstore58: GEORADIUS35;
geosearchstore57: geosearchstore58;
geosearchstore56: geosearchstore57 | ;
geosearchstore53: geosearchstore54 geosearchstore55 geosearchstore56;
geosearchstore52: geosearchstore53 | ;
geosearchstore61: GEORADIUS49;
geosearchstore60: geosearchstore61;
geosearchstore59: geosearchstore60 | ;
geosearchstore0: geosearchstore1 geosearchstore3 geosearchstore4 geosearchstore5 geosearchstore17 geosearchstore47 geosearchstore52 geosearchstore59;

// GET key
get: get0;
get1: BITFIELD10;
get2: elem=key #GetRule1;
get0: get1 get2;

// GETBIT key offset
getbit: getbit0;
getbit1: GETBIT2;
GETBIT2: 'getbit';
getbit3: key;
getbit4: offset;
getbit0: getbit1 getbit3 getbit4;

// GETDEL key
getdel: getdel0;
getdel1: GETDEL2;
GETDEL2: 'getdel';
getdel3: elem=key #GetDelRule1;
getdel0: getdel1 getdel3;

// GETEX key [EX seconds | PX milliseconds | EXAT unix_time_seconds |   PXAT unix_time_milliseconds | PERSIST]
getex: getex0;
getex1: GETEX2;
GETEX2: 'getex';
getex3: elem=key #GetExRule1;
getex6: GETEX7;
GETEX7: 'ex';
getex9: seconds;
getex10: GETEX11;
GETEX11: 'px';
getex8: getex9 | getex10;
getex13: milliseconds;
getex14: GETEX15;
GETEX15: 'exat';
getex12: getex13 | getex14;
getex17: unix_time_seconds;
getex18: GETEX19;
GETEX19: 'pxat';
getex16: getex17 | getex18;
getex21: unix_time_milliseconds;
getex22: GETEX23;
GETEX23: 'persist';
getex20: getex21 | getex22;
getex5: getex6 getex8 getex12 getex16 getex20;
getex4: getex5 | ;
getex0: getex1 getex3 getex4;

// GETRANGE key start end
getrange: getrange0;
getrange1: GETRANGE2;
GETRANGE2: 'getrange';
getrange3: elem=key #GetRangeRule1;
getrange4: start;
getrange5: end;
getrange0: getrange1 getrange3 getrange4 getrange5;

// GETSET key value
getset: getset0;
getset1: GETSET2;
GETSET2: 'getset';
getset3: elem=key #GetSetRule1;
getset4: value;
getset0: getset1 getset3 getset4;

// GRAPH.CONFIG GET name
graph_dot_config_sp_get: graph_dot_config_sp_get0;
graph_dot_config_sp_get1: GRAPH_DOT_CONFIG_SP_GET2;
GRAPH_DOT_CONFIG_SP_GET2: 'graph.config';
graph_dot_config_sp_get3: BITFIELD10;
graph_dot_config_sp_get4: name;
graph_dot_config_sp_get0: graph_dot_config_sp_get1 graph_dot_config_sp_get3 graph_dot_config_sp_get4;

// GRAPH.CONFIG SET name value
graph_dot_config_sp_set: graph_dot_config_sp_set0;
graph_dot_config_sp_set1: GRAPH_DOT_CONFIG_SP_GET2;
graph_dot_config_sp_set2: BITFIELD33;
graph_dot_config_sp_set3: name;
graph_dot_config_sp_set4: value;
graph_dot_config_sp_set0: graph_dot_config_sp_set1 graph_dot_config_sp_set2 graph_dot_config_sp_set3 graph_dot_config_sp_set4;

// GRAPH.DELETE graph
// graph_dot_delete: graph_dot_delete0;
// todo: {'graph'}
/*
graph_dot_delete1: GRAPH_DOT_DELETE2;
GRAPH_DOT_DELETE2: 'graph.delete';
graph_dot_delete3: graph_dot_delete4;
graph_dot_delete4: 'graph.TODO';
graph_dot_delete0: graph_dot_delete1 graph_dot_delete3;

*/
// GRAPH.EXPLAIN graph query
// graph_dot_explain: graph_dot_explain0;
// todo: {'graph'}
/*
graph_dot_explain1: GRAPH_DOT_EXPLAIN2;
GRAPH_DOT_EXPLAIN2: 'graph.explain';
graph_dot_explain3: graph_dot_explain4;
graph_dot_explain4: 'graph.TODO';
graph_dot_explain5: query;
graph_dot_explain0: graph_dot_explain1 graph_dot_explain3 graph_dot_explain5;

*/
// GRAPH.LIST
graph_dot_list: graph_dot_list0;
graph_dot_list1: GRAPH_DOT_LIST2;
GRAPH_DOT_LIST2: 'graph.list';
graph_dot_list0: graph_dot_list1;

// GRAPH.PROFILE graph query [TIMEOUT timeout]
// graph_dot_profile: graph_dot_profile0;
// todo: {'graph'}
/*
graph_dot_profile1: GRAPH_DOT_PROFILE2;
GRAPH_DOT_PROFILE2: 'graph.profile';
graph_dot_profile3: graph_dot_profile4;
graph_dot_profile4: 'graph.TODO';
graph_dot_profile5: query;
graph_dot_profile8: FT_DOT_SEARCH158;
graph_dot_profile9: timeout;
graph_dot_profile7: graph_dot_profile8 graph_dot_profile9;
graph_dot_profile6: graph_dot_profile7 | ;
graph_dot_profile0: graph_dot_profile1 graph_dot_profile3 graph_dot_profile5 graph_dot_profile6;

*/
// GRAPH.QUERY graph query [TIMEOUT timeout]
// graph_dot_query: graph_dot_query0;
// todo: {'graph'}
/*
graph_dot_query1: GRAPH_DOT_QUERY2;
GRAPH_DOT_QUERY2: 'graph.query';
graph_dot_query3: graph_dot_query4;
graph_dot_query4: 'graph.TODO';
graph_dot_query5: query;
graph_dot_query8: FT_DOT_SEARCH158;
graph_dot_query9: timeout;
graph_dot_query7: graph_dot_query8 graph_dot_query9;
graph_dot_query6: graph_dot_query7 | ;
graph_dot_query0: graph_dot_query1 graph_dot_query3 graph_dot_query5 graph_dot_query6;

*/
// GRAPH.RO_QUERY graph query [TIMEOUT timeout]
// graph_dot_ro_query: graph_dot_ro_query0;
// todo: {'graph'}
/*
graph_dot_ro_query1: GRAPH_DOT_RO_QUERY2;
GRAPH_DOT_RO_QUERY2: 'graph.ro_query';
graph_dot_ro_query3: graph_dot_ro_query4;
graph_dot_ro_query4: 'graph.TODO';
graph_dot_ro_query5: query;
graph_dot_ro_query8: FT_DOT_SEARCH158;
graph_dot_ro_query9: timeout;
graph_dot_ro_query7: graph_dot_ro_query8 graph_dot_ro_query9;
graph_dot_ro_query6: graph_dot_ro_query7 | ;
graph_dot_ro_query0: graph_dot_ro_query1 graph_dot_ro_query3 graph_dot_ro_query5 graph_dot_ro_query6;

*/
// GRAPH.SLOWLOG graph
// graph_dot_slowlog: graph_dot_slowlog0;
// todo: {'graph'}
/*
graph_dot_slowlog1: GRAPH_DOT_SLOWLOG2;
GRAPH_DOT_SLOWLOG2: 'graph.slowlog';
graph_dot_slowlog3: graph_dot_slowlog4;
graph_dot_slowlog4: 'graph.TODO';
graph_dot_slowlog0: graph_dot_slowlog1 graph_dot_slowlog3;

*/
// HDEL key field [field ...]
hdel: hdel0;
hdel1: HDEL2;
HDEL2: 'hdel';
hdel3: elem=key #HDelRule1;
hdel4: field;
hdel7: field;
hdel6: hdel7;
hdel5: hdel6 | hdel5 hdel6 | ;
hdel0: hdel1 hdel3 hdel4 hdel5;

// HELLO [protover [AUTH username password] [SETNAME clientname]]
// hello: hello0;
// todo: {'protover', 'clientname'}
/*
hello1: HELLO2;
HELLO2: 'hello';
hello5: hello6;
hello6: 'protover.TODO';
hello9: AUTH2;
hello10: username;
hello11: password;
hello8: hello9 hello10 hello11;
hello7: hello8 | ;
hello14: HELLO15;
HELLO15: 'setname';
hello16: hello17;
hello17: 'clientname.TODO';
hello13: hello14 hello16;
hello12: hello13 | ;
hello4: hello5 hello7 hello12;
hello3: hello4 | ;
hello0: hello1 hello3;

*/
// HEXISTS key field
hexists: hexists0;
hexists1: HEXISTS2;
HEXISTS2: 'hexists';
hexists3: elem=key #HExistsRule1;
hexists4: field;
hexists0: hexists1 hexists3 hexists4;

// HGET key field
hget: hget0;
hget1: HGET2;
HGET2: 'hget';
hget3: elem=key #HGetRule1;
hget4: elem=field #HGetField;
hget0: hget1 hget3 hget4;

// HGETALL key
hgetall: hgetall0;
hgetall1: HGETALL2;
HGETALL2: 'hgetall';
hgetall3: elem=key #HGetAllRule1;
hgetall0: hgetall1 hgetall3;

// HINCRBY key field increment
hincrby: hincrby0;
hincrby1: HINCRBY2;
HINCRBY2: 'hincrby';
hincrby3: elem=key #HIncrByRule1;
hincrby4: elem=field #HIncrByField;
hincrby5: increment;
hincrby0: hincrby1 hincrby3 hincrby4 hincrby5;

// HINCRBYFLOAT key field increment
hincrbyfloat: hincrbyfloat0;
hincrbyfloat1: HINCRBYFLOAT2;
HINCRBYFLOAT2: 'hincrbyfloat';
hincrbyfloat3: elem=key #HIncrByFloatRule1;
hincrbyfloat4: elem=field #HIncrByFloatField;
hincrbyfloat5: increment;
hincrbyfloat0: hincrbyfloat1 hincrbyfloat3 hincrbyfloat4 hincrbyfloat5;

// HKEYS key
hkeys: hkeys0;
hkeys1: HKEYS2;
HKEYS2: 'hkeys';
hkeys3: elem=key #HKeysRule1;
hkeys0: hkeys1 hkeys3;

// HLEN key
hlen: hlen0;
hlen1: HLEN2;
HLEN2: 'hlen';
hlen3: elem=key #HLenRule1;
hlen0: hlen1 hlen3;

// HMGET key field [field ...]
hmget: hmget0;
hmget1: HMGET2;
HMGET2: 'hmget';
hmget3: elem=key #HMGetRule1;
hmget4: elem=field #HMGetField1;
hmget7: elem=field #HMGetField2;
hmget6: hmget7;
hmget5: hmget6 | hmget5 hmget6 | ;
hmget0: hmget1 hmget3 hmget4 hmget5;

// HMSET key field value [field value ...]
hmset: hmset0;
hmset1: HMSET2;
HMSET2: 'hmset';
hmset3: elem=key #HMSetRule1;
hmset4: field;
hmset5: value;
hmset8: field;
hmset9: value;
hmset7: hmset8 hmset9;
hmset6: hmset7 | hmset6 hmset7 | ;
hmset0: hmset1 hmset3 hmset4 hmset5 hmset6;

// HRANDFIELD key [count [WITHVALUES]]
hrandfield: hrandfield0;
hrandfield1: HRANDFIELD2;
HRANDFIELD2: 'hrandfield';
hrandfield3: elem=key #HRandFieldRule1;
hrandfield6: count;
hrandfield9: HRANDFIELD10;
HRANDFIELD10: 'withvalues';
hrandfield8: hrandfield9;
hrandfield7: hrandfield8 | ;
hrandfield5: hrandfield6 hrandfield7;
hrandfield4: hrandfield5 | ;
hrandfield0: hrandfield1 hrandfield3 hrandfield4;

// HSCAN key cursor [MATCH pattern] [COUNT count]
hscan: hscan0;
hscan1: HSCAN2;
HSCAN2: 'hscan';
hscan3: elem=key #HScanRule1;
hscan4: cursor;
hscan7: HSCAN8;
HSCAN8: 'match';
hscan9: pattern;
hscan6: hscan7 hscan9;
hscan5: hscan6 | ;
hscan12: BLMPOP17;
hscan13: count;
hscan11: hscan12 hscan13;
hscan10: hscan11 | ;
hscan0: hscan1 hscan3 hscan4 hscan5 hscan10;

// HSET key field value [field value ...]
hset: hset0;
hset1: HSET2;
HSET2: 'hset';
hset3: elem=key #HSetRule1;
hset4: elem=field #HSetField1;
hset5: value;
hset8: elem=field #HSetField2;
hset9: value;
hset7: hset8 hset9;
hset6: hset7 | hset6 hset7 | ;
hset0: hset1 hset3 hset4 hset5 hset6;

// HSETNX key field value
hsetnx: hsetnx0;
hsetnx1: HSETNX2;
HSETNX2: 'hsetnx';
hsetnx3: elem=key #HSetNXRule1;
hsetnx4: elem=field #HSetNXField;
hsetnx5: value;
hsetnx0: hsetnx1 hsetnx3 hsetnx4 hsetnx5;

// HSTRLEN key field
hstrlen: hstrlen0;
hstrlen1: HSTRLEN2;
HSTRLEN2: 'hstrlen';
hstrlen3: elem=key #HStrLenRule1;
hstrlen4: elem=field #HSetLenField;
hstrlen0: hstrlen1 hstrlen3 hstrlen4;

// HVALS key
hvals: hvals0;
hvals1: HVALS2;
HVALS2: 'hvals';
hvals3: elem=key #HValsRule1;
hvals0: hvals1 hvals3;

// INCR key
incr: incr0;
incr1: FT_DOT_SUGADD9;
incr2: elem=key #IncrRule1;
incr0: incr1 incr2;

// INCRBY key increment
incrby: incrby0;
incrby1: BITFIELD40;
incrby2: elem=key #IncrByRule1;
incrby3: increment;
incrby0: incrby1 incrby2 incrby3;

// INCRBYFLOAT key increment
incrbyfloat: incrbyfloat0;
incrbyfloat1: INCRBYFLOAT2;
INCRBYFLOAT2: 'incrbyfloat';
incrbyfloat3: elem=key #IncrByFloatRule1;
incrbyfloat4: increment;
incrbyfloat0: incrbyfloat1 incrbyfloat3 incrbyfloat4;

// INFO [section [section ...]]
info: info0;
info1: CLIENT_SP_INFO3;
info4: section;
info7: section;
info6: info7;
info5: info6 | info5 info6 | ;
info3: info4 info5;
info2: info3 | ;
info0: info1 info2;

// JSON.ARRAPPEND key [path] value [value ...]
// json_dot_arrappend: json_dot_arrappend0;
// todo: {'path'}
/*
json_dot_arrappend1: JSON_DOT_ARRAPPEND2;
JSON_DOT_ARRAPPEND2: 'json.arrappend';
json_dot_arrappend3: key;
json_dot_arrappend6: json_dot_arrappend7;
json_dot_arrappend7: 'path.TODO';
json_dot_arrappend5: json_dot_arrappend6;
json_dot_arrappend4: json_dot_arrappend5 | ;
json_dot_arrappend8: value;
json_dot_arrappend11: value;
json_dot_arrappend10: json_dot_arrappend11;
json_dot_arrappend9: json_dot_arrappend10 | json_dot_arrappend9 json_dot_arrappend10 | ;
json_dot_arrappend0: json_dot_arrappend1 json_dot_arrappend3 json_dot_arrappend4 json_dot_arrappend8 json_dot_arrappend9;

*/
// JSON.ARRINDEX key path value [start [stop]]
// json_dot_arrindex: json_dot_arrindex0;
// todo: {'path'}
/*
json_dot_arrindex1: JSON_DOT_ARRINDEX2;
JSON_DOT_ARRINDEX2: 'json.arrindex';
json_dot_arrindex3: key;
json_dot_arrindex4: json_dot_arrindex5;
json_dot_arrindex5: 'path.TODO';
json_dot_arrindex6: value;
json_dot_arrindex9: start;
json_dot_arrindex12: stop;
json_dot_arrindex11: json_dot_arrindex12;
json_dot_arrindex10: json_dot_arrindex11 | ;
json_dot_arrindex8: json_dot_arrindex9 json_dot_arrindex10;
json_dot_arrindex7: json_dot_arrindex8 | ;
json_dot_arrindex0: json_dot_arrindex1 json_dot_arrindex3 json_dot_arrindex4 json_dot_arrindex6 json_dot_arrindex7;

*/
// JSON.ARRINSERT key path index value [value ...]
// json_dot_arrinsert: json_dot_arrinsert0;
// todo: {'path'}
/*
json_dot_arrinsert1: JSON_DOT_ARRINSERT2;
JSON_DOT_ARRINSERT2: 'json.arrinsert';
json_dot_arrinsert3: key;
json_dot_arrinsert4: json_dot_arrinsert5;
json_dot_arrinsert5: 'path.TODO';
json_dot_arrinsert6: index;
json_dot_arrinsert7: value;
json_dot_arrinsert10: value;
json_dot_arrinsert9: json_dot_arrinsert10;
json_dot_arrinsert8: json_dot_arrinsert9 | json_dot_arrinsert8 json_dot_arrinsert9 | ;
json_dot_arrinsert0: json_dot_arrinsert1 json_dot_arrinsert3 json_dot_arrinsert4 json_dot_arrinsert6 json_dot_arrinsert7 json_dot_arrinsert8;

*/
// JSON.ARRLEN key [path]
// json_dot_arrlen: json_dot_arrlen0;
// todo: {'path'}
/*
json_dot_arrlen1: JSON_DOT_ARRLEN2;
JSON_DOT_ARRLEN2: 'json.arrlen';
json_dot_arrlen3: key;
json_dot_arrlen6: json_dot_arrlen7;
json_dot_arrlen7: 'path.TODO';
json_dot_arrlen5: json_dot_arrlen6;
json_dot_arrlen4: json_dot_arrlen5 | ;
json_dot_arrlen0: json_dot_arrlen1 json_dot_arrlen3 json_dot_arrlen4;

*/
// JSON.ARRPOP key [path [index]]
// json_dot_arrpop: json_dot_arrpop0;
// todo: {'path'}
/*
json_dot_arrpop1: JSON_DOT_ARRPOP2;
JSON_DOT_ARRPOP2: 'json.arrpop';
json_dot_arrpop3: key;
json_dot_arrpop6: json_dot_arrpop7;
json_dot_arrpop7: 'path.TODO';
json_dot_arrpop10: index;
json_dot_arrpop9: json_dot_arrpop10;
json_dot_arrpop8: json_dot_arrpop9 | ;
json_dot_arrpop5: json_dot_arrpop6 json_dot_arrpop8;
json_dot_arrpop4: json_dot_arrpop5 | ;
json_dot_arrpop0: json_dot_arrpop1 json_dot_arrpop3 json_dot_arrpop4;

*/
// JSON.ARRTRIM key path start stop
// json_dot_arrtrim: json_dot_arrtrim0;
// todo: {'path'}
/*
json_dot_arrtrim1: JSON_DOT_ARRTRIM2;
JSON_DOT_ARRTRIM2: 'json.arrtrim';
json_dot_arrtrim3: key;
json_dot_arrtrim4: json_dot_arrtrim5;
json_dot_arrtrim5: 'path.TODO';
json_dot_arrtrim6: start;
json_dot_arrtrim7: stop;
json_dot_arrtrim0: json_dot_arrtrim1 json_dot_arrtrim3 json_dot_arrtrim4 json_dot_arrtrim6 json_dot_arrtrim7;

*/
// JSON.CLEAR key [path]
// json_dot_clear: json_dot_clear0;
// todo: {'path'}
/*
json_dot_clear1: JSON_DOT_CLEAR2;
JSON_DOT_CLEAR2: 'json.clear';
json_dot_clear3: key;
json_dot_clear6: json_dot_clear7;
json_dot_clear7: 'path.TODO';
json_dot_clear5: json_dot_clear6;
json_dot_clear4: json_dot_clear5 | ;
json_dot_clear0: json_dot_clear1 json_dot_clear3 json_dot_clear4;

*/
// JSON.DEBUG
json_dot_debug: json_dot_debug0;
json_dot_debug1: JSON_DOT_DEBUG2;
JSON_DOT_DEBUG2: 'json.debug';
json_dot_debug0: json_dot_debug1;

// JSON.DEBUG MEMORY key [path]
// json_dot_debug_sp_memory: json_dot_debug_sp_memory0;
// todo: {'path'}
/*
json_dot_debug_sp_memory1: JSON_DOT_DEBUG2;
json_dot_debug_sp_memory2: JSON_DOT_DEBUG_SP_MEMORY3;
JSON_DOT_DEBUG_SP_MEMORY3: 'memory';
json_dot_debug_sp_memory4: key;
json_dot_debug_sp_memory7: json_dot_debug_sp_memory8;
json_dot_debug_sp_memory8: 'path.TODO';
json_dot_debug_sp_memory6: json_dot_debug_sp_memory7;
json_dot_debug_sp_memory5: json_dot_debug_sp_memory6 | ;
json_dot_debug_sp_memory0: json_dot_debug_sp_memory1 json_dot_debug_sp_memory2 json_dot_debug_sp_memory4 json_dot_debug_sp_memory5;

*/
// JSON.DEL key [path]
// json_dot_del: json_dot_del0;
// todo: {'path'}
/*
json_dot_del1: JSON_DOT_DEL2;
JSON_DOT_DEL2: 'json.del';
json_dot_del3: key;
json_dot_del6: json_dot_del7;
json_dot_del7: 'path.TODO';
json_dot_del5: json_dot_del6;
json_dot_del4: json_dot_del5 | ;
json_dot_del0: json_dot_del1 json_dot_del3 json_dot_del4;

*/
// JSON.FORGET key [path]
// json_dot_forget: json_dot_forget0;
// todo: {'path'}
/*
json_dot_forget1: JSON_DOT_FORGET2;
JSON_DOT_FORGET2: 'json.forget';
json_dot_forget3: key;
json_dot_forget6: json_dot_forget7;
json_dot_forget7: 'path.TODO';
json_dot_forget5: json_dot_forget6;
json_dot_forget4: json_dot_forget5 | ;
json_dot_forget0: json_dot_forget1 json_dot_forget3 json_dot_forget4;

*/
// JSON.GET key [INDENT indent] [NEWLINE newline] [SPACE space] [paths   [paths ...]]
// json_dot_get: json_dot_get0;
// todo: {'indent', 'newline', 'space', 'paths'}
/*
json_dot_get1: JSON_DOT_GET2;
JSON_DOT_GET2: 'json.get';
json_dot_get3: key;
json_dot_get6: JSON_DOT_GET7;
JSON_DOT_GET7: 'indent';
json_dot_get8: json_dot_get9;
json_dot_get9: 'indent.TODO';
json_dot_get5: json_dot_get6 json_dot_get8;
json_dot_get4: json_dot_get5 | ;
json_dot_get12: JSON_DOT_GET13;
JSON_DOT_GET13: 'newline';
json_dot_get14: json_dot_get15;
json_dot_get15: 'newline.TODO';
json_dot_get11: json_dot_get12 json_dot_get14;
json_dot_get10: json_dot_get11 | ;
json_dot_get18: JSON_DOT_GET19;
JSON_DOT_GET19: 'space';
json_dot_get20: json_dot_get21;
json_dot_get21: 'space.TODO';
json_dot_get17: json_dot_get18 json_dot_get20;
json_dot_get16: json_dot_get17 | ;
json_dot_get24: json_dot_get25;
json_dot_get25: 'paths.TODO';
json_dot_get28: json_dot_get29;
json_dot_get29: 'paths.TODO';
json_dot_get27: json_dot_get28;
json_dot_get26: json_dot_get27 | json_dot_get26 json_dot_get27 | ;
json_dot_get23: json_dot_get24 json_dot_get26;
json_dot_get22: json_dot_get23 | ;
json_dot_get0: json_dot_get1 json_dot_get3 json_dot_get4 json_dot_get10 json_dot_get16 json_dot_get22;

*/
// JSON.MGET key [key ...] path
// json_dot_mget: json_dot_mget0;
// todo: {'path'}
/*
json_dot_mget1: JSON_DOT_MGET2;
JSON_DOT_MGET2: 'json.mget';
json_dot_mget3: key;
json_dot_mget6: key;
json_dot_mget5: json_dot_mget6;
json_dot_mget4: json_dot_mget5 | json_dot_mget4 json_dot_mget5 | ;
json_dot_mget7: json_dot_mget8;
json_dot_mget8: 'path.TODO';
json_dot_mget0: json_dot_mget1 json_dot_mget3 json_dot_mget4 json_dot_mget7;

*/
// JSON.NUMINCRBY key path value
// json_dot_numincrby: json_dot_numincrby0;
// todo: {'path'}
/*
json_dot_numincrby1: JSON_DOT_NUMINCRBY2;
JSON_DOT_NUMINCRBY2: 'json.numincrby';
json_dot_numincrby3: key;
json_dot_numincrby4: json_dot_numincrby5;
json_dot_numincrby5: 'path.TODO';
json_dot_numincrby6: value;
json_dot_numincrby0: json_dot_numincrby1 json_dot_numincrby3 json_dot_numincrby4 json_dot_numincrby6;

*/
// JSON.NUMMULTBY key path value
// json_dot_nummultby: json_dot_nummultby0;
// todo: {'path'}
/*
json_dot_nummultby1: JSON_DOT_NUMMULTBY2;
JSON_DOT_NUMMULTBY2: 'json.nummultby';
json_dot_nummultby3: key;
json_dot_nummultby4: json_dot_nummultby5;
json_dot_nummultby5: 'path.TODO';
json_dot_nummultby6: value;
json_dot_nummultby0: json_dot_nummultby1 json_dot_nummultby3 json_dot_nummultby4 json_dot_nummultby6;

*/
// JSON.OBJKEYS key [path]
// json_dot_objkeys: json_dot_objkeys0;
// todo: {'path'}
/*
json_dot_objkeys1: JSON_DOT_OBJKEYS2;
JSON_DOT_OBJKEYS2: 'json.objkeys';
json_dot_objkeys3: key;
json_dot_objkeys6: json_dot_objkeys7;
json_dot_objkeys7: 'path.TODO';
json_dot_objkeys5: json_dot_objkeys6;
json_dot_objkeys4: json_dot_objkeys5 | ;
json_dot_objkeys0: json_dot_objkeys1 json_dot_objkeys3 json_dot_objkeys4;

*/
// JSON.OBJLEN key [path]
// json_dot_objlen: json_dot_objlen0;
// todo: {'path'}
/*
json_dot_objlen1: JSON_DOT_OBJLEN2;
JSON_DOT_OBJLEN2: 'json.objlen';
json_dot_objlen3: key;
json_dot_objlen6: json_dot_objlen7;
json_dot_objlen7: 'path.TODO';
json_dot_objlen5: json_dot_objlen6;
json_dot_objlen4: json_dot_objlen5 | ;
json_dot_objlen0: json_dot_objlen1 json_dot_objlen3 json_dot_objlen4;

*/
// JSON.RESP key [path]
// json_dot_resp: json_dot_resp0;
// todo: {'path'}
/*
json_dot_resp1: JSON_DOT_RESP2;
JSON_DOT_RESP2: 'json.resp';
json_dot_resp3: key;
json_dot_resp6: json_dot_resp7;
json_dot_resp7: 'path.TODO';
json_dot_resp5: json_dot_resp6;
json_dot_resp4: json_dot_resp5 | ;
json_dot_resp0: json_dot_resp1 json_dot_resp3 json_dot_resp4;

*/
// JSON.SET key path value [NX | XX]
// json_dot_set: json_dot_set0;
// todo: {'path'}
/*
json_dot_set1: JSON_DOT_SET2;
JSON_DOT_SET2: 'json.set';
json_dot_set3: key;
json_dot_set4: json_dot_set5;
json_dot_set5: 'path.TODO';
json_dot_set6: value;
json_dot_set10: EXPIRE11;
json_dot_set11: EXPIRE13;
json_dot_set9: json_dot_set10 | json_dot_set11;
json_dot_set8: json_dot_set9;
json_dot_set7: json_dot_set8 | ;
json_dot_set0: json_dot_set1 json_dot_set3 json_dot_set4 json_dot_set6 json_dot_set7;

*/
// JSON.STRAPPEND key [path] value
// json_dot_strappend: json_dot_strappend0;
// todo: {'path'}
/*
json_dot_strappend1: JSON_DOT_STRAPPEND2;
JSON_DOT_STRAPPEND2: 'json.strappend';
json_dot_strappend3: key;
json_dot_strappend6: json_dot_strappend7;
json_dot_strappend7: 'path.TODO';
json_dot_strappend5: json_dot_strappend6;
json_dot_strappend4: json_dot_strappend5 | ;
json_dot_strappend8: value;
json_dot_strappend0: json_dot_strappend1 json_dot_strappend3 json_dot_strappend4 json_dot_strappend8;

*/
// JSON.STRLEN key [path]
// json_dot_strlen: json_dot_strlen0;
// todo: {'path'}
/*
json_dot_strlen1: JSON_DOT_STRLEN2;
JSON_DOT_STRLEN2: 'json.strlen';
json_dot_strlen3: key;
json_dot_strlen6: json_dot_strlen7;
json_dot_strlen7: 'path.TODO';
json_dot_strlen5: json_dot_strlen6;
json_dot_strlen4: json_dot_strlen5 | ;
json_dot_strlen0: json_dot_strlen1 json_dot_strlen3 json_dot_strlen4;

*/
// JSON.TOGGLE key path
// json_dot_toggle: json_dot_toggle0;
// todo: {'path'}
/*
json_dot_toggle1: JSON_DOT_TOGGLE2;
JSON_DOT_TOGGLE2: 'json.toggle';
json_dot_toggle3: key;
json_dot_toggle4: json_dot_toggle5;
json_dot_toggle5: 'path.TODO';
json_dot_toggle0: json_dot_toggle1 json_dot_toggle3 json_dot_toggle4;

*/
// JSON.TYPE key [path]
// json_dot_type: json_dot_type0;
// todo: {'path'}
/*
json_dot_type1: JSON_DOT_TYPE2;
JSON_DOT_TYPE2: 'json.type';
json_dot_type3: key;
json_dot_type6: json_dot_type7;
json_dot_type7: 'path.TODO';
json_dot_type5: json_dot_type6;
json_dot_type4: json_dot_type5 | ;
json_dot_type0: json_dot_type1 json_dot_type3 json_dot_type4;

*/
// KEYS pattern
keys: keys0;
keys1: KEYS2;
KEYS2: 'keys';
keys3: pattern;
keys0: keys1 keys3;

// LASTSAVE
lastsave: lastsave0;
lastsave1: LASTSAVE2;
LASTSAVE2: 'lastsave';
lastsave0: lastsave1;

// LATENCY DOCTOR
latency_sp_doctor: latency_sp_doctor0;
latency_sp_doctor1: LATENCY_SP_DOCTOR2;
LATENCY_SP_DOCTOR2: 'latency';
latency_sp_doctor3: LATENCY_SP_DOCTOR4;
LATENCY_SP_DOCTOR4: 'doctor';
latency_sp_doctor0: latency_sp_doctor1 latency_sp_doctor3;

// LATENCY GRAPH event
// latency_sp_graph: latency_sp_graph0;
// todo: {'event'}
/*
latency_sp_graph1: LATENCY_SP_DOCTOR2;
latency_sp_graph2: LATENCY_SP_GRAPH3;
LATENCY_SP_GRAPH3: 'graph';
latency_sp_graph4: latency_sp_graph5;
latency_sp_graph5: 'event.TODO';
latency_sp_graph0: latency_sp_graph1 latency_sp_graph2 latency_sp_graph4;

*/
// LATENCY HISTOGRAM [command [command ...]]
// latency_sp_histogram: latency_sp_histogram0;
// todo: {'command'}
/*
latency_sp_histogram1: LATENCY_SP_DOCTOR2;
latency_sp_histogram2: LATENCY_SP_HISTOGRAM3;
LATENCY_SP_HISTOGRAM3: 'histogram';
latency_sp_histogram6: latency_sp_histogram7;
latency_sp_histogram7: 'command.TODO';
latency_sp_histogram10: latency_sp_histogram11;
latency_sp_histogram11: 'command.TODO';
latency_sp_histogram9: latency_sp_histogram10;
latency_sp_histogram8: latency_sp_histogram9 | latency_sp_histogram8 latency_sp_histogram9 | ;
latency_sp_histogram5: latency_sp_histogram6 latency_sp_histogram8;
latency_sp_histogram4: latency_sp_histogram5 | ;
latency_sp_histogram0: latency_sp_histogram1 latency_sp_histogram2 latency_sp_histogram4;

*/
// LATENCY HISTORY event
// latency_sp_history: latency_sp_history0;
// todo: {'event'}
/*
latency_sp_history1: LATENCY_SP_DOCTOR2;
latency_sp_history2: LATENCY_SP_HISTORY3;
LATENCY_SP_HISTORY3: 'history';
latency_sp_history4: latency_sp_history5;
latency_sp_history5: 'event.TODO';
latency_sp_history0: latency_sp_history1 latency_sp_history2 latency_sp_history4;

*/
// LATENCY LATEST
latency_sp_latest: latency_sp_latest0;
latency_sp_latest1: LATENCY_SP_DOCTOR2;
latency_sp_latest2: LATENCY_SP_LATEST3;
LATENCY_SP_LATEST3: 'latest';
latency_sp_latest0: latency_sp_latest1 latency_sp_latest2;

// LATENCY RESET [event [event ...]]
// latency_sp_reset: latency_sp_reset0;
// todo: {'event'}
/*
latency_sp_reset1: LATENCY_SP_DOCTOR2;
latency_sp_reset2: ACL_SP_LOG9;
latency_sp_reset5: latency_sp_reset6;
latency_sp_reset6: 'event.TODO';
latency_sp_reset9: latency_sp_reset10;
latency_sp_reset10: 'event.TODO';
latency_sp_reset8: latency_sp_reset9;
latency_sp_reset7: latency_sp_reset8 | latency_sp_reset7 latency_sp_reset8 | ;
latency_sp_reset4: latency_sp_reset5 latency_sp_reset7;
latency_sp_reset3: latency_sp_reset4 | ;
latency_sp_reset0: latency_sp_reset1 latency_sp_reset2 latency_sp_reset3;

*/
// LCS key1 key2 [LEN] [IDX] [MINMATCHLEN len] [WITHMATCHLEN]
lcs: lcs0;
lcs1: LCS2;
LCS2: 'lcs';
lcs3: elem=key1 #LCSRule1;
lcs4: elem=key2 #LCSRule2;
lcs7: FT_DOT_SEARCH130;
lcs6: lcs7;
lcs5: lcs6 | ;
lcs10: LCS11;
LCS11: 'idx';
lcs9: lcs10;
lcs8: lcs9 | ;
lcs14: LCS15;
LCS15: 'minmatchlen';
lcs16: len;
lcs13: lcs14 lcs16;
lcs12: lcs13 | ;
lcs19: LCS20;
LCS20: 'withmatchlen';
lcs18: lcs19;
lcs17: lcs18 | ;
lcs0: lcs1 lcs3 lcs4 lcs5 lcs8 lcs12 lcs17;

// LINDEX key index
lindex: lindex0;
lindex1: LINDEX2;
LINDEX2: 'lindex';
lindex3: elem=key #LIndexRule1;
lindex4: index;
lindex0: lindex1 lindex3 lindex4;

// LINSERT key <BEFORE | AFTER> pivot element
linsert: linsert0;
linsert1: LINSERT2;
LINSERT2: 'linsert';
linsert3: elem=key #LInsertRule1;
linsert7: LINSERT8;
LINSERT8: 'before';
linsert9: LINSERT10;
LINSERT10: 'after';
linsert6: linsert7 | linsert9;
linsert5: linsert6;
linsert4: linsert5;
linsert11: pivot;
linsert12: element;
linsert0: linsert1 linsert3 linsert4 linsert11 linsert12;

// LLEN key
llen: llen0;
llen1: LLEN2;
LLEN2: 'llen';
llen3: elem=key #LLenRule1;
llen0: llen1 llen3;

// LMOVE source destination <LEFT | RIGHT> <LEFT | RIGHT>
lmove: lmove0;
lmove1: LMOVE2;
LMOVE2: 'lmove';
lmove3: elem=source #LMoveRule1;
lmove4: elem=destination #LMoveRule2;
lmove8: BLMOVE9;
lmove9: BLMOVE11;
lmove7: lmove8 | lmove9;
lmove6: lmove7;
lmove5: lmove6;
lmove13: BLMOVE9;
lmove14: BLMOVE11;
lmove12: lmove13 | lmove14;
lmove11: lmove12;
lmove10: lmove11;
lmove0: lmove1 lmove3 lmove4 lmove5 lmove10;

// LMPOP numkeys key [key ...] <LEFT | RIGHT> [COUNT count]
lmpop: lmpop0;
lmpop1: LMPOP2;
LMPOP2: 'lmpop';
lmpop3: numkeys;
lmpop4: elem=key #LMPopRule1;
lmpop7: elem=key #LMPopRule2;
lmpop6: lmpop7;
lmpop5: lmpop6 | lmpop5 lmpop6 | ;
lmpop11: BLMOVE9;
lmpop12: BLMOVE11;
lmpop10: lmpop11 | lmpop12;
lmpop9: lmpop10;
lmpop8: lmpop9;
lmpop15: BLMPOP17;
lmpop16: count;
lmpop14: lmpop15 lmpop16;
lmpop13: lmpop14 | ;
lmpop0: lmpop1 lmpop3 lmpop4 lmpop5 lmpop8 lmpop13;

// LOLWUT [VERSION version]
// lolwut: lolwut0;
// todo: {'version'}
/*
lolwut1: LOLWUT2;
LOLWUT2: 'lolwut';
lolwut5: LOLWUT6;
LOLWUT6: 'version';
lolwut7: lolwut8;
lolwut8: 'version.TODO';
lolwut4: lolwut5 lolwut7;
lolwut3: lolwut4 | ;
lolwut0: lolwut1 lolwut3;

*/
// LPOP key [count]
lpop: lpop0;
lpop1: LPOP2;
LPOP2: 'lpop';
lpop3: elem=key #LPopRule1;
lpop6: count;
lpop5: lpop6;
lpop4: lpop5 | ;
lpop0: lpop1 lpop3 lpop4;

// LPOS key element [RANK rank] [COUNT num_matches] [MAXLEN len]
lpos: lpos0;
lpos1: LPOS2;
LPOS2: 'lpos';
lpos3: elem=key #LPosRule1;
lpos4: element;
lpos7: LPOS8;
LPOS8: 'rank';
lpos9: rank;
lpos6: lpos7 lpos9;
lpos5: lpos6 | ;
lpos12: BLMPOP17;
lpos13: num_matches;
lpos11: lpos12 lpos13;
lpos10: lpos11 | ;
lpos16: LPOS17;
LPOS17: 'maxlen';
lpos18: len;
lpos15: lpos16 lpos18;
lpos14: lpos15 | ;
lpos0: lpos1 lpos3 lpos4 lpos5 lpos10 lpos14;

// LPUSH key element [element ...]
lpush: lpush0;
lpush1: LPUSH2;
LPUSH2: 'lpush';
lpush3: elem=key #LPushRule1;
lpush4: element;
lpush7: element;
lpush6: lpush7;
lpush5: lpush6 | lpush5 lpush6 | ;
lpush0: lpush1 lpush3 lpush4 lpush5;

// LPUSHX key element [element ...]
lpushx: lpushx0;
lpushx1: LPUSHX2;
LPUSHX2: 'lpushx';
lpushx3: elem=key #LPushXRule1;
lpushx4: element;
lpushx7: element;
lpushx6: lpushx7;
lpushx5: lpushx6 | lpushx5 lpushx6 | ;
lpushx0: lpushx1 lpushx3 lpushx4 lpushx5;

// LRANGE key start stop
lrange: lrange0;
lrange1: LRANGE2;
LRANGE2: 'lrange';
lrange3: elem=key #LRangeRule1;
lrange4: start;
lrange5: stop;
lrange0: lrange1 lrange3 lrange4 lrange5;

// LREM key count element
lrem: lrem0;
lrem1: LREM2;
LREM2: 'lrem';
lrem3: elem=key #LRemRule1;
lrem4: count;
lrem5: element;
lrem0: lrem1 lrem3 lrem4 lrem5;

// LSET key index element
lset: lset0;
lset1: LSET2;
LSET2: 'lset';
lset3: elem=key #LSetRule1;
lset4: index;
lset5: element;
lset0: lset1 lset3 lset4 lset5;

// LTRIM key start stop
ltrim: ltrim0;
ltrim1: LTRIM2;
LTRIM2: 'ltrim';
ltrim3: elem=key #LTrimRule1;
ltrim4: start;
ltrim5: stop;
ltrim0: ltrim1 ltrim3 ltrim4 ltrim5;

// MEMORY DOCTOR
memory_sp_doctor: memory_sp_doctor0;
memory_sp_doctor1: MEMORY_SP_DOCTOR2;
MEMORY_SP_DOCTOR2: 'memory';
memory_sp_doctor3: LATENCY_SP_DOCTOR4;
memory_sp_doctor0: memory_sp_doctor1 memory_sp_doctor3;

// MEMORY MALLOC-STATS
memory_sp_malloc_stats: memory_sp_malloc_stats0;
memory_sp_malloc_stats1: MEMORY_SP_DOCTOR2;
memory_sp_malloc_stats2: MEMORY_SP_MALLOC_STATS3;
MEMORY_SP_MALLOC_STATS3: 'malloc-stats';
memory_sp_malloc_stats0: memory_sp_malloc_stats1 memory_sp_malloc_stats2;

// MEMORY PURGE
memory_sp_purge: memory_sp_purge0;
memory_sp_purge1: MEMORY_SP_DOCTOR2;
memory_sp_purge2: MEMORY_SP_PURGE3;
MEMORY_SP_PURGE3: 'purge';
memory_sp_purge0: memory_sp_purge1 memory_sp_purge2;

// MEMORY STATS
memory_sp_stats: memory_sp_stats0;
memory_sp_stats1: MEMORY_SP_DOCTOR2;
memory_sp_stats2: FUNCTION_SP_STATS3;
memory_sp_stats0: memory_sp_stats1 memory_sp_stats2;

// MEMORY USAGE key [SAMPLES count]
memory_sp_usage: memory_sp_usage0;
memory_sp_usage1: MEMORY_SP_DOCTOR2;
memory_sp_usage2: MEMORY_SP_USAGE3;
MEMORY_SP_USAGE3: 'usage';
memory_sp_usage4: key;
memory_sp_usage7: MEMORY_SP_USAGE8;
MEMORY_SP_USAGE8: 'samples';
memory_sp_usage9: count;
memory_sp_usage6: memory_sp_usage7 memory_sp_usage9;
memory_sp_usage5: memory_sp_usage6 | ;
memory_sp_usage0: memory_sp_usage1 memory_sp_usage2 memory_sp_usage4 memory_sp_usage5;

// MGET key [key ...]
mget: mget0;
mget1: MGET2;
MGET2: 'mget';
mget3: elem=key #MGetRule1;
mget6: elem=key #MGetRule2;
mget5: mget6;
mget4: mget5 | mget4 mget5 | ;
mget0: mget1 mget3 mget4;

// MIGRATE host port key destination_db timeout [COPY] [REPLACE]   [[AUTH password] | [AUTH2 username password]] [KEYS key [key ...]]
// migrate: migrate0;
// todo: {'host'}
/*
migrate1: MIGRATE2;
MIGRATE2: 'migrate';
migrate3: migrate4;
migrate4: 'host.TODO';
migrate5: port;
migrate6: key;
migrate7: destination_db;
migrate8: timeout;
migrate11: COPY2;
migrate10: migrate11;
migrate9: migrate10 | ;
migrate14: COPY13;
migrate13: migrate14;
migrate12: migrate13 | ;
migrate20: AUTH2;
migrate21: password;
migrate19: migrate20 migrate21;
migrate18: migrate19 | ;
migrate24: MIGRATE25;
MIGRATE25: 'auth2';
migrate26: username;
migrate27: password;
migrate23: migrate24 migrate26 migrate27;
migrate22: migrate23 | ;
migrate17: migrate18 | migrate22;
migrate16: migrate17;
migrate15: migrate16 | ;
migrate30: KEYS2;
migrate31: key;
migrate34: key;
migrate33: migrate34;
migrate32: migrate33 | migrate32 migrate33 | ;
migrate29: migrate30 migrate31 migrate32;
migrate28: migrate29 | ;
migrate0: migrate1 migrate3 migrate5 migrate6 migrate7 migrate8 migrate9 migrate12 migrate15 migrate28;

*/
// MODULE LIST
module_sp_list: module_sp_list0;
module_sp_list1: COMMAND_SP_LIST10;
module_sp_list2: ACL_SP_LIST3;
module_sp_list0: module_sp_list1 module_sp_list2;

// MODULE LOAD path [arg [arg ...]]
// module_sp_load: module_sp_load0;
// todo: {'path', 'arg'}
/*
module_sp_load1: COMMAND_SP_LIST10;
module_sp_load2: ACL_SP_LOAD3;
module_sp_load3: module_sp_load4;
module_sp_load4: 'path.TODO';
module_sp_load7: module_sp_load8;
module_sp_load8: 'arg.TODO';
module_sp_load11: module_sp_load12;
module_sp_load12: 'arg.TODO';
module_sp_load10: module_sp_load11;
module_sp_load9: module_sp_load10 | module_sp_load9 module_sp_load10 | ;
module_sp_load6: module_sp_load7 module_sp_load9;
module_sp_load5: module_sp_load6 | ;
module_sp_load0: module_sp_load1 module_sp_load2 module_sp_load3 module_sp_load5;

*/
// MODULE LOADEX path [CONFIG name value [CONFIG name value ...]]   [ARGS arg [arg ...]]
// module_sp_loadex: module_sp_loadex0;
// todo: {'path', 'arg'}
/*
module_sp_loadex1: COMMAND_SP_LIST10;
module_sp_loadex2: MODULE_SP_LOADEX3;
MODULE_SP_LOADEX3: 'loadex';
module_sp_loadex4: module_sp_loadex5;
module_sp_loadex5: 'path.TODO';
module_sp_loadex8: CONFIG_SP_RESETSTAT2;
module_sp_loadex9: name;
module_sp_loadex10: value;
module_sp_loadex13: CONFIG_SP_RESETSTAT2;
module_sp_loadex14: name;
module_sp_loadex15: value;
module_sp_loadex12: module_sp_loadex13 module_sp_loadex14 module_sp_loadex15;
module_sp_loadex11: module_sp_loadex12 | module_sp_loadex11 module_sp_loadex12 | ;
module_sp_loadex7: module_sp_loadex8 module_sp_loadex9 module_sp_loadex10 module_sp_loadex11;
module_sp_loadex6: module_sp_loadex7 | ;
module_sp_loadex18: MODULE_SP_LOADEX19;
MODULE_SP_LOADEX19: 'args';
module_sp_loadex20: module_sp_loadex21;
module_sp_loadex21: 'arg.TODO';
module_sp_loadex24: module_sp_loadex25;
module_sp_loadex25: 'arg.TODO';
module_sp_loadex23: module_sp_loadex24;
module_sp_loadex22: module_sp_loadex23 | module_sp_loadex22 module_sp_loadex23 | ;
module_sp_loadex17: module_sp_loadex18 module_sp_loadex20 module_sp_loadex22;
module_sp_loadex16: module_sp_loadex17 | ;
module_sp_loadex0: module_sp_loadex1 module_sp_loadex2 module_sp_loadex4 module_sp_loadex6 module_sp_loadex16;

*/
// MODULE UNLOAD name
module_sp_unload: module_sp_unload0;
module_sp_unload1: COMMAND_SP_LIST10;
module_sp_unload2: MODULE_SP_UNLOAD3;
MODULE_SP_UNLOAD3: 'unload';
module_sp_unload4: name;
module_sp_unload0: module_sp_unload1 module_sp_unload2 module_sp_unload4;

// MONITOR
monitor: monitor0;
monitor1: MONITOR2;
MONITOR2: 'monitor';
monitor0: monitor1;

// MOVE key db
// move: move0;
// todo: {'db'}
/*
move1: MOVE2;
MOVE2: 'move';
move3: key;
move4: move5;
move5: 'db.TODO';
move0: move1 move3 move4;

*/
// MSET key value [key value ...]
mset: mset0;
mset1: MSET2;
MSET2: 'mset';
mset3: elem=key #MSetRule1;
mset4: value;
mset7: elem=key #MSetRule2;
mset8: value;
mset6: mset7 mset8;
mset5: mset6 | mset5 mset6 | ;
mset0: mset1 mset3 mset4 mset5;

// MSETNX key value [key value ...]
msetnx: msetnx0;
msetnx1: MSETNX2;
MSETNX2: 'msetnx';
msetnx3: elem=key #MSetNxRule1;
msetnx4: value;
msetnx7: elem=key #MSetNxRule2;
msetnx8: value;
msetnx6: msetnx7 msetnx8;
msetnx5: msetnx6 | msetnx5 msetnx6 | ;
msetnx0: msetnx1 msetnx3 msetnx4 msetnx5;

// MULTI
multi: multi0;
multi1: MULTI2;
MULTI2: 'multi';
multi0: elem=multi1 #MultiRule1;

// OBJECT ENCODING key
object_sp_encoding: object_sp_encoding0;
object_sp_encoding1: OBJECT_SP_ENCODING2;
OBJECT_SP_ENCODING2: 'object';
object_sp_encoding3: OBJECT_SP_ENCODING4;
OBJECT_SP_ENCODING4: 'encoding';
object_sp_encoding5: key;
object_sp_encoding0: object_sp_encoding1 object_sp_encoding3 object_sp_encoding5;

// OBJECT FREQ key
object_sp_freq: object_sp_freq0;
object_sp_freq1: OBJECT_SP_ENCODING2;
object_sp_freq2: OBJECT_SP_FREQ3;
OBJECT_SP_FREQ3: 'freq';
object_sp_freq4: key;
object_sp_freq0: object_sp_freq1 object_sp_freq2 object_sp_freq4;

// OBJECT IDLETIME key
object_sp_idletime: object_sp_idletime0;
object_sp_idletime1: OBJECT_SP_ENCODING2;
object_sp_idletime2: OBJECT_SP_IDLETIME3;
OBJECT_SP_IDLETIME3: 'idletime';
object_sp_idletime4: key;
object_sp_idletime0: object_sp_idletime1 object_sp_idletime2 object_sp_idletime4;

// OBJECT REFCOUNT key
object_sp_refcount: object_sp_refcount0;
object_sp_refcount1: OBJECT_SP_ENCODING2;
object_sp_refcount2: OBJECT_SP_REFCOUNT3;
OBJECT_SP_REFCOUNT3: 'refcount';
object_sp_refcount4: key;
object_sp_refcount0: object_sp_refcount1 object_sp_refcount2 object_sp_refcount4;

// PERSIST key
persist: persist0;
persist1: GETEX23;
persist2: key;
persist0: persist1 persist2;

// PEXPIRE key milliseconds [NX | XX | GT | LT]
pexpire: pexpire0;
pexpire1: PEXPIRE2;
PEXPIRE2: 'pexpire';
pexpire3: elem=key #PExpireRule1;
pexpire4: milliseconds;
pexpire10: EXPIRE11;
pexpire11: EXPIRE13;
pexpire9: pexpire10 | pexpire11;
pexpire12: EXPIRE15;
pexpire8: pexpire9 | pexpire12;
pexpire13: EXPIRE17;
pexpire7: pexpire8 | pexpire13;
pexpire6: pexpire7;
pexpire5: pexpire6 | ;
pexpire0: pexpire1 pexpire3 pexpire4 pexpire5;

// PEXPIREAT key unix_time_milliseconds [NX | XX | GT | LT]
pexpireat: pexpireat0;
pexpireat1: PEXPIREAT2;
PEXPIREAT2: 'pexpireat';
pexpireat3: key;
pexpireat4: unix_time_milliseconds;
pexpireat10: EXPIRE11;
pexpireat11: EXPIRE13;
pexpireat9: pexpireat10 | pexpireat11;
pexpireat12: EXPIRE15;
pexpireat8: pexpireat9 | pexpireat12;
pexpireat13: EXPIRE17;
pexpireat7: pexpireat8 | pexpireat13;
pexpireat6: pexpireat7;
pexpireat5: pexpireat6 | ;
pexpireat0: pexpireat1 pexpireat3 pexpireat4 pexpireat5;

// PEXPIRETIME key
pexpiretime: pexpiretime0;
pexpiretime1: PEXPIRETIME2;
PEXPIRETIME2: 'pexpiretime';
pexpiretime3: key;
pexpiretime0: pexpiretime1 pexpiretime3;

// PFADD key [element [element ...]]
pfadd: pfadd0;
pfadd1: PFADD2;
PFADD2: 'pfadd';
pfadd3: key;
pfadd6: element;
pfadd9: element;
pfadd8: pfadd9;
pfadd7: pfadd8 | pfadd7 pfadd8 | ;
pfadd5: pfadd6 pfadd7;
pfadd4: pfadd5 | ;
pfadd0: pfadd1 pfadd3 pfadd4;

// PFCOUNT key [key ...]
pfcount: pfcount0;
pfcount1: PFCOUNT2;
PFCOUNT2: 'pfcount';
pfcount3: key;
pfcount6: key;
pfcount5: pfcount6;
pfcount4: pfcount5 | pfcount4 pfcount5 | ;
pfcount0: pfcount1 pfcount3 pfcount4;

// PFDEBUG subcommand key
// pfdebug: pfdebug0;
// todo: {'subcommand'}
/*
pfdebug1: PFDEBUG2;
PFDEBUG2: 'pfdebug';
pfdebug3: pfdebug4;
pfdebug4: 'subcommand.TODO';
pfdebug5: key;
pfdebug0: pfdebug1 pfdebug3 pfdebug5;

*/
// PFMERGE destkey sourcekey [sourcekey ...]
pfmerge: pfmerge0;
pfmerge1: PFMERGE2;
PFMERGE2: 'pfmerge';
pfmerge3: destkey;
pfmerge4: sourcekey;
pfmerge7: sourcekey;
pfmerge6: pfmerge7;
pfmerge5: pfmerge6 | pfmerge5 pfmerge6 | ;
pfmerge0: pfmerge1 pfmerge3 pfmerge4 pfmerge5;

// PFSELFTEST
pfselftest: pfselftest0;
pfselftest1: PFSELFTEST2;
PFSELFTEST2: 'pfselftest';
pfselftest0: pfselftest1;

// PING [message]
ping: ping0;
ping1: PING2;
PING2: 'ping';
ping5: message;
ping4: ping5;
ping3: ping4 | ;
ping0: ping1 ping3;

// PSETEX key milliseconds value
psetex: psetex0;
psetex1: PSETEX2;
PSETEX2: 'psetex';
psetex3: elem=key #PSetExRule1;
psetex4: milliseconds;
psetex5: value;
psetex0: psetex1 psetex3 psetex4 psetex5;

// PSUBSCRIBE pattern [pattern ...]
psubscribe: psubscribe0;
psubscribe1: PSUBSCRIBE2;
PSUBSCRIBE2: 'psubscribe';
psubscribe3: pattern;
psubscribe6: pattern;
psubscribe5: psubscribe6;
psubscribe4: psubscribe5 | psubscribe4 psubscribe5 | ;
psubscribe0: psubscribe1 psubscribe3 psubscribe4;

// PSYNC replicationid offset
psync: psync0;
psync1: PSYNC2;
PSYNC2: 'psync';
psync3: replicationid;
psync4: offset;
psync0: psync1 psync3 psync4;

// PTTL key
pttl: pttl0;
pttl1: PTTL2;
PTTL2: 'pttl';
pttl3: key;
pttl0: pttl1 pttl3;

// PUBLISH channel message
publish: publish0;
publish1: PUBLISH2;
PUBLISH2: 'publish';
publish3: channel;
publish4: message;
publish0: publish1 publish3 publish4;

// PUBSUB CHANNELS [pattern]
pubsub_sp_channels: pubsub_sp_channels0;
pubsub_sp_channels1: PUBSUB_SP_CHANNELS2;
PUBSUB_SP_CHANNELS2: 'pubsub';
pubsub_sp_channels3: PUBSUB_SP_CHANNELS4;
PUBSUB_SP_CHANNELS4: 'channels';
pubsub_sp_channels7: pattern;
pubsub_sp_channels6: pubsub_sp_channels7;
pubsub_sp_channels5: pubsub_sp_channels6 | ;
pubsub_sp_channels0: pubsub_sp_channels1 pubsub_sp_channels3 pubsub_sp_channels5;

// PUBSUB NUMPAT
pubsub_sp_numpat: pubsub_sp_numpat0;
pubsub_sp_numpat1: PUBSUB_SP_CHANNELS2;
pubsub_sp_numpat2: PUBSUB_SP_NUMPAT3;
PUBSUB_SP_NUMPAT3: 'numpat';
pubsub_sp_numpat0: pubsub_sp_numpat1 pubsub_sp_numpat2;

// PUBSUB NUMSUB [channel [channel ...]]
pubsub_sp_numsub: pubsub_sp_numsub0;
pubsub_sp_numsub1: PUBSUB_SP_CHANNELS2;
pubsub_sp_numsub2: PUBSUB_SP_NUMSUB3;
PUBSUB_SP_NUMSUB3: 'numsub';
pubsub_sp_numsub6: channel;
pubsub_sp_numsub9: channel;
pubsub_sp_numsub8: pubsub_sp_numsub9;
pubsub_sp_numsub7: pubsub_sp_numsub8 | pubsub_sp_numsub7 pubsub_sp_numsub8 | ;
pubsub_sp_numsub5: pubsub_sp_numsub6 pubsub_sp_numsub7;
pubsub_sp_numsub4: pubsub_sp_numsub5 | ;
pubsub_sp_numsub0: pubsub_sp_numsub1 pubsub_sp_numsub2 pubsub_sp_numsub4;

// PUBSUB SHARDCHANNELS [pattern]
pubsub_sp_shardchannels: pubsub_sp_shardchannels0;
pubsub_sp_shardchannels1: PUBSUB_SP_CHANNELS2;
pubsub_sp_shardchannels2: PUBSUB_SP_SHARDCHANNELS3;
PUBSUB_SP_SHARDCHANNELS3: 'shardchannels';
pubsub_sp_shardchannels6: pattern;
pubsub_sp_shardchannels5: pubsub_sp_shardchannels6;
pubsub_sp_shardchannels4: pubsub_sp_shardchannels5 | ;
pubsub_sp_shardchannels0: pubsub_sp_shardchannels1 pubsub_sp_shardchannels2 pubsub_sp_shardchannels4;

// PUBSUB SHARDNUMSUB [shardchannel [shardchannel ...]]
pubsub_sp_shardnumsub: pubsub_sp_shardnumsub0;
pubsub_sp_shardnumsub1: PUBSUB_SP_CHANNELS2;
pubsub_sp_shardnumsub2: PUBSUB_SP_SHARDNUMSUB3;
PUBSUB_SP_SHARDNUMSUB3: 'shardnumsub';
pubsub_sp_shardnumsub6: shardchannel;
pubsub_sp_shardnumsub9: shardchannel;
pubsub_sp_shardnumsub8: pubsub_sp_shardnumsub9;
pubsub_sp_shardnumsub7: pubsub_sp_shardnumsub8 | pubsub_sp_shardnumsub7 pubsub_sp_shardnumsub8 | ;
pubsub_sp_shardnumsub5: pubsub_sp_shardnumsub6 pubsub_sp_shardnumsub7;
pubsub_sp_shardnumsub4: pubsub_sp_shardnumsub5 | ;
pubsub_sp_shardnumsub0: pubsub_sp_shardnumsub1 pubsub_sp_shardnumsub2 pubsub_sp_shardnumsub4;

// PUNSUBSCRIBE [pattern [pattern ...]]
punsubscribe: punsubscribe0;
punsubscribe1: PUNSUBSCRIBE2;
PUNSUBSCRIBE2: 'punsubscribe';
punsubscribe5: pattern;
punsubscribe8: pattern;
punsubscribe7: punsubscribe8;
punsubscribe6: punsubscribe7 | punsubscribe6 punsubscribe7 | ;
punsubscribe4: punsubscribe5 punsubscribe6;
punsubscribe3: punsubscribe4 | ;
punsubscribe0: punsubscribe1 punsubscribe3;

// QUIT
quit: quit0;
quit1: QUIT2;
QUIT2: 'quit';
quit0: quit1;

// RANDOMKEY
randomkey: randomkey0;
randomkey1: RANDOMKEY2;
RANDOMKEY2: 'randomkey';
randomkey0: randomkey1;

// READONLY
readonly: readonly0;
readonly1: READONLY2;
READONLY2: 'readonly';
readonly0: readonly1;

// READWRITE
readwrite: readwrite0;
readwrite1: READWRITE2;
READWRITE2: 'readwrite';
readwrite0: readwrite1;

// RENAME key newkey
rename: rename0;
rename1: RENAME2;
RENAME2: 'rename';
rename3: key;
rename4: newkey;
rename0: rename1 rename3 rename4;

// RENAMENX key newkey
renamenx: renamenx0;
renamenx1: RENAMENX2;
RENAMENX2: 'renamenx';
renamenx3: key;
renamenx4: newkey;
renamenx0: renamenx1 renamenx3 renamenx4;

// REPLCONF
replconf: replconf0;
replconf1: REPLCONF2;
REPLCONF2: 'replconf';
replconf0: replconf1;

// REPLICAOF host port
// replicaof: replicaof0;
// todo: {'host'}
/*
replicaof1: REPLICAOF2;
REPLICAOF2: 'replicaof';
replicaof3: replicaof4;
replicaof4: 'host.TODO';
replicaof5: port;
replicaof0: replicaof1 replicaof3 replicaof5;

*/
// RESET
reset_cmd: reset_cmd0;
reset_cmd1: ACL_SP_LOG9;
reset_cmd0: reset_cmd1;

// RESTORE key ttl_arg serialized_value [REPLACE] [ABSTTL]   [IDLETIME seconds] [FREQ frequency]
restore: restore0;
restore1: FUNCTION_SP_RESTORE3;
restore2: key;
restore3: ttl_arg;
restore4: serialized_value;
restore7: COPY13;
restore6: restore7;
restore5: restore6 | ;
restore10: RESTORE11;
RESTORE11: 'absttl';
restore9: restore10;
restore8: restore9 | ;
restore14: OBJECT_SP_IDLETIME3;
restore15: seconds;
restore13: restore14 restore15;
restore12: restore13 | ;
restore18: OBJECT_SP_FREQ3;
restore19: frequency;
restore17: restore18 restore19;
restore16: restore17 | ;
restore0: restore1 restore2 restore3 restore4 restore5 restore8 restore12 restore16;

// RESTORE-ASKING key ttl_arg serialized_value [REPLACE] [ABSTTL]   [IDLETIME seconds] [FREQ frequency]
restore_asking: restore_asking0;
restore_asking1: RESTORE_ASKING2;
RESTORE_ASKING2: 'restore-asking';
restore_asking3: key;
restore_asking4: ttl_arg;
restore_asking5: serialized_value;
restore_asking8: COPY13;
restore_asking7: restore_asking8;
restore_asking6: restore_asking7 | ;
restore_asking11: RESTORE11;
restore_asking10: restore_asking11;
restore_asking9: restore_asking10 | ;
restore_asking14: OBJECT_SP_IDLETIME3;
restore_asking15: seconds;
restore_asking13: restore_asking14 restore_asking15;
restore_asking12: restore_asking13 | ;
restore_asking18: OBJECT_SP_FREQ3;
restore_asking19: frequency;
restore_asking17: restore_asking18 restore_asking19;
restore_asking16: restore_asking17 | ;
restore_asking0: restore_asking1 restore_asking3 restore_asking4 restore_asking5 restore_asking6 restore_asking9 restore_asking12 restore_asking16;

// ROLE
role: role0;
role1: ROLE2;
ROLE2: 'role';
role0: role1;

// RPOP key [count]
rpop: rpop0;
rpop1: RPOP2;
RPOP2: 'rpop';
rpop3: elem=key #RPopRule1;
rpop6: count;
rpop5: rpop6;
rpop4: rpop5 | ;
rpop0: rpop1 rpop3 rpop4;

// RPOPLPUSH source destination
rpoplpush: rpoplpush0;
rpoplpush1: RPOPLPUSH2;
RPOPLPUSH2: 'rpoplpush';
rpoplpush3: elem=source #RPopLPushRule1;
rpoplpush4: elem=destination #RPopLPushRule2;
rpoplpush0: rpoplpush1 rpoplpush3 rpoplpush4;

// RPUSH key element [element ...]
rpush: rpush0;
rpush1: RPUSH2;
RPUSH2: 'rpush';
rpush3: elem=key #RPushRule1;
rpush4: element;
rpush7: element;
rpush6: rpush7;
rpush5: rpush6 | rpush5 rpush6 | ;
rpush0: rpush1 rpush3 rpush4 rpush5;

// RPUSHX key element [element ...]
rpushx: rpushx0;
rpushx1: RPUSHX2;
RPUSHX2: 'rpushx';
rpushx3: elem=key #RPushXRule1;
rpushx4: element;
rpushx7: element;
rpushx6: rpushx7;
rpushx5: rpushx6 | rpushx5 rpushx6 | ;
rpushx0: rpushx1 rpushx3 rpushx4 rpushx5;

// SADD key member [member ...]
sadd: sadd0;
sadd1: SADD2;
SADD2: 'sadd';
sadd3: elem=key #SAddRule1;
sadd4: member;
sadd7: member;
sadd6: sadd7;
sadd5: sadd6 | sadd5 sadd6 | ;
sadd0: sadd1 sadd3 sadd4 sadd5;

// SAVE
save: save0;
save1: ACL_SP_SAVE3;
save0: elem=save1 #SaveRule;

// SCAN cursor [MATCH pattern] [COUNT count] [TYPE scan_type]
scan: scan0;
scan1: SCAN2;
SCAN2: 'scan';
scan3: cursor;
scan6: HSCAN8;
scan7: pattern;
scan5: scan6 scan7;
scan4: scan5 | ;
scan10: BLMPOP17;
scan11: count;
scan9: scan10 scan11;
scan8: scan9 | ;
scan14: SCAN15;
SCAN15: 'type';
scan16: scan_type;
scan13: scan14 scan16;
scan12: scan13 | ;
scan0: scan1 scan3 scan4 scan8 scan12;

// SCARD key
scard: scard0;
scard1: SCARD2;
SCARD2: 'scard';
scard3: elem=key #SCardRule1;
scard0: scard1 scard3;

// SCRIPT DEBUG <YES | SYNC | NO>
script_sp_debug: script_sp_debug0;
script_sp_debug1: SCRIPT_SP_DEBUG2;
SCRIPT_SP_DEBUG2: 'script';
script_sp_debug3: SCRIPT_SP_DEBUG4;
SCRIPT_SP_DEBUG4: 'debug';
script_sp_debug9: CLIENT_SP_CACHING9;
script_sp_debug10: FLUSHALL9;
script_sp_debug8: script_sp_debug9 | script_sp_debug10;
script_sp_debug11: CLIENT_SP_CACHING11;
script_sp_debug7: script_sp_debug8 | script_sp_debug11;
script_sp_debug6: script_sp_debug7;
script_sp_debug5: script_sp_debug6;
script_sp_debug0: script_sp_debug1 script_sp_debug3 script_sp_debug5;

// SCRIPT EXISTS sha1 [sha1 ...]
// script_sp_exists: script_sp_exists0;
// todo: {'sha1'}
/*
script_sp_exists1: SCRIPT_SP_DEBUG2;
script_sp_exists2: EXISTS2;
script_sp_exists3: script_sp_exists4;
script_sp_exists4: 'sha1.TODO';
script_sp_exists7: script_sp_exists8;
script_sp_exists8: 'sha1.TODO';
script_sp_exists6: script_sp_exists7;
script_sp_exists5: script_sp_exists6 | script_sp_exists5 script_sp_exists6 | ;
script_sp_exists0: script_sp_exists1 script_sp_exists2 script_sp_exists3 script_sp_exists5;

*/
// SCRIPT FLUSH [ASYNC | SYNC]
script_sp_flush: script_sp_flush0;
script_sp_flush1: SCRIPT_SP_DEBUG2;
script_sp_flush2: FUNCTION_SP_FLUSH3;
script_sp_flush6: FLUSHALL7;
script_sp_flush7: FLUSHALL9;
script_sp_flush5: script_sp_flush6 | script_sp_flush7;
script_sp_flush4: script_sp_flush5;
script_sp_flush3: script_sp_flush4 | ;
script_sp_flush0: script_sp_flush1 script_sp_flush2 script_sp_flush3;

// SCRIPT KILL
script_sp_kill: script_sp_kill0;
script_sp_kill1: SCRIPT_SP_DEBUG2;
script_sp_kill2: FUNCTION_SP_KILL3;
script_sp_kill0: script_sp_kill1 script_sp_kill2;

// SCRIPT LOAD script
// script_sp_load: script_sp_load0;
// todo: {'script'}
/*
script_sp_load1: SCRIPT_SP_DEBUG2;
script_sp_load2: ACL_SP_LOAD3;
script_sp_load3: script_sp_load4;
script_sp_load4: 'script.TODO';
script_sp_load0: script_sp_load1 script_sp_load2 script_sp_load3;

*/
// SDIFF key [key ...]
sdiff: sdiff0;
sdiff1: SDIFF2;
SDIFF2: 'sdiff';
sdiff3: elem=key #SDiffRule1;
sdiff6: elem=key #SDiffRule2;
sdiff5: sdiff6;
sdiff4: sdiff5 | sdiff4 sdiff5 | ;
sdiff0: sdiff1 sdiff3 sdiff4;

// SDIFFSTORE destination key [key ...]
sdiffstore: sdiffstore0;
sdiffstore1: SDIFFSTORE2;
SDIFFSTORE2: 'sdiffstore';
sdiffstore3: elem=destination #SDiffStoreRule1;
sdiffstore4: elem=key #SDiffStoreRule2;
sdiffstore7: elem=key #SDiffStoreRule3;
sdiffstore6: sdiffstore7;
sdiffstore5: sdiffstore6 | sdiffstore5 sdiffstore6 | ;
sdiffstore0: sdiffstore1 sdiffstore3 sdiffstore4 sdiffstore5;

// SELECT index
select: select0;
select1: SELECT2;
SELECT2: 'select';
select3: index;
select0: select1 select3;

// SET key value [NX | XX] [GET] [EX seconds | PX milliseconds |   EXAT unix_time_seconds | PXAT unix_time_milliseconds | KEEPTTL]
set: set0;
set1: BITFIELD33;
set2: elem=key #SetRule1;
set3: value;
set7: EXPIRE11;
set8: EXPIRE13;
set6: set7 | set8;
set5: set6;
set4: set5 | ;
set11: BITFIELD10;
set10: set11;
set9: set10 | ;
set14: GETEX7;
set16: seconds;
set17: GETEX11;
set15: set16 | set17;
set19: milliseconds;
set20: GETEX15;
set18: set19 | set20;
set22: unix_time_seconds;
set23: GETEX19;
set21: set22 | set23;
set25: unix_time_milliseconds;
set26: SET27;
SET27: 'keepttl';
set24: set25 | set26;
set13: set14 set15 set18 set21 set24;
set12: set13 | ;
set0: set1 set2 set3 set4 set9 set12;

// SETBIT key offset value
setbit: setbit0;
setbit1: SETBIT2;
SETBIT2: 'setbit';
setbit3: elem=key #SetBitRule1;
setbit4: offset;
setbit5: value;
setbit0: setbit1 setbit3 setbit4 setbit5;

// SETEX key seconds value
setex: setex0;
setex1: SETEX2;
SETEX2: 'setex';
setex3: elem=key #SetExRule1;
setex4: seconds;
setex5: value;
setex0: setex1 setex3 setex4 setex5;

// SETNX key value
setnx: setnx0;
setnx1: SETNX2;
SETNX2: 'setnx';
setnx3: elem=key #SetNxRule1;
setnx4: value;
setnx0: setnx1 setnx3 setnx4;

// SETRANGE key offset value
setrange: setrange0;
setrange1: SETRANGE2;
SETRANGE2: 'setrange';
setrange3: elem=key #SetRangeRule1;
setrange4: offset;
setrange5: value;
setrange0: setrange1 setrange3 setrange4 setrange5;

// SHUTDOWN [NOSAVE | SAVE] [NOW] [FORCE] [ABORT]
shutdown: shutdown0;
shutdown1: SHUTDOWN2;
SHUTDOWN2: 'shutdown';
shutdown6: SHUTDOWN7;
SHUTDOWN7: 'nosave';
shutdown8: ACL_SP_SAVE3;
shutdown5: shutdown6 | shutdown8;
shutdown4: shutdown5;
shutdown3: shutdown4 | ;
shutdown11: SHUTDOWN12;
SHUTDOWN12: 'now';
shutdown10: shutdown11;
shutdown9: shutdown10 | ;
shutdown15: CLUSTER_SP_FAILOVER8;
shutdown14: shutdown15;
shutdown13: shutdown14 | ;
shutdown18: SHUTDOWN19;
SHUTDOWN19: 'abort';
shutdown17: shutdown18;
shutdown16: shutdown17 | ;
shutdown0: shutdown1 shutdown3 shutdown9 shutdown13 shutdown16;

// SINTER key [key ...]
sinter: sinter0;
sinter1: SINTER2;
SINTER2: 'sinter';
sinter3: elem=key #SInterRule1;
sinter6: elem=key #SInterRule2;
sinter5: sinter6;
sinter4: sinter5 | sinter4 sinter5 | ;
sinter0: sinter1 sinter3 sinter4;

// SINTERCARD numkeys key [key ...] [LIMIT limit]
sintercard: sintercard0;
sintercard1: SINTERCARD2;
SINTERCARD2: 'sintercard';
sintercard3: numkeys;
sintercard4: elem=key #SInterCardRule1;
sintercard7: elem=key #SInterCardRule2;
sintercard6: sintercard7;
sintercard5: sintercard6 | sintercard5 sintercard6 | ;
sintercard10: FT_DOT_SEARCH193;
sintercard11: limit;
sintercard9: sintercard10 sintercard11;
sintercard8: sintercard9 | ;
sintercard0: sintercard1 sintercard3 sintercard4 sintercard5 sintercard8;

// SINTERSTORE destination key [key ...]
sinterstore: sinterstore0;
sinterstore1: SINTERSTORE2;
SINTERSTORE2: 'sinterstore';
sinterstore3: elem=destination #SInterStoreRule1;
sinterstore4: elem=key #SInterStoreRule2;
sinterstore7: elem=key #SInterStoreRule3;
sinterstore6: sinterstore7;
sinterstore5: sinterstore6 | sinterstore5 sinterstore6 | ;
sinterstore0: sinterstore1 sinterstore3 sinterstore4 sinterstore5;

// SISMEMBER key member
sismember: sismember0;
sismember1: SISMEMBER2;
SISMEMBER2: 'sismember';
sismember3: elem=key #SIsMemberRule1;
sismember4: member;
sismember0: sismember1 sismember3 sismember4;

// SLAVEOF host port
// slaveof: slaveof0;
// todo: {'host'}
/*
slaveof1: SLAVEOF2;
SLAVEOF2: 'slaveof';
slaveof3: slaveof4;
slaveof4: 'host.TODO';
slaveof5: port;
slaveof0: slaveof1 slaveof3 slaveof5;

*/
// SLOWLOG GET [count]
slowlog_sp_get: slowlog_sp_get0;
slowlog_sp_get1: SLOWLOG_SP_GET2;
SLOWLOG_SP_GET2: 'slowlog';
slowlog_sp_get3: BITFIELD10;
slowlog_sp_get6: count;
slowlog_sp_get5: slowlog_sp_get6;
slowlog_sp_get4: slowlog_sp_get5 | ;
slowlog_sp_get0: slowlog_sp_get1 slowlog_sp_get3 slowlog_sp_get4;

// SLOWLOG LEN
slowlog_sp_len: slowlog_sp_len0;
slowlog_sp_len1: SLOWLOG_SP_GET2;
slowlog_sp_len2: FT_DOT_SEARCH130;
slowlog_sp_len0: slowlog_sp_len1 slowlog_sp_len2;

// SLOWLOG RESET
slowlog_sp_reset: slowlog_sp_reset0;
slowlog_sp_reset1: SLOWLOG_SP_GET2;
slowlog_sp_reset2: ACL_SP_LOG9;
slowlog_sp_reset0: slowlog_sp_reset1 slowlog_sp_reset2;

// SMEMBERS key
smembers: smembers0;
smembers1: SMEMBERS2;
SMEMBERS2: 'smembers';
smembers3: elem=key #SMembersRule1;
smembers0: smembers1 smembers3;

// SMISMEMBER key member [member ...]
smismember: smismember0;
smismember1: SMISMEMBER2;
SMISMEMBER2: 'smismember';
smismember3: elem=key #SMIsMemberRule1;
smismember4: member;
smismember7: member;
smismember6: smismember7;
smismember5: smismember6 | smismember5 smismember6 | ;
smismember0: smismember1 smismember3 smismember4 smismember5;

// SMOVE source destination member
smove: smove0;
smove1: SMOVE2;
SMOVE2: 'smove';
smove3: elem=source #SMoveRule1;
smove4: elem=destination #SMoveRule2;
smove5: member;
smove0: smove1 smove3 smove4 smove5;

// SORT key [BY pattern] [LIMIT offset count] [GET pattern [GET pattern   ...]] [ASC | DESC] [ALPHA] [STORE destination]
sort: sort0;
sort1: SORT2;
SORT2: 'sort';
sort3: elem=key #SortRule1;
sort6: SORT7;
SORT7: 'by';
sort8: pattern;
sort5: sort6 sort8;
sort4: sort5 | ;
sort11: FT_DOT_SEARCH193;
sort12: offset;
sort13: count;
sort10: sort11 sort12 sort13;
sort9: sort10 | ;
sort16: BITFIELD10;
sort17: get_pattern;
sort20: BITFIELD10;
sort21: get_pattern;
sort19: sort20 sort21;
sort18: sort19 | sort18 sort19 | ;
sort15: sort16 sort17 sort18;
sort14: sort15 | ;
sort25: FT_DOT_SEARCH187;
sort26: FT_DOT_SEARCH189;
sort24: sort25 | sort26;
sort23: sort24;
sort22: sort23 | ;
sort29: SORT30;
SORT30: 'alpha';
sort28: sort29;
sort27: sort28 | ;
sort33: GEORADIUS44;
sort34: destination;
sort32: sort33 sort34;
sort31: sort32 | ;
sort0: sort1 sort3 sort4 sort9 sort14 sort22 sort27 sort31;

get_pattern: pattern | '#';

// SORT_RO key [BY pattern] [LIMIT offset count] [GET pattern [GET   pattern ...]] [ASC | DESC] [ALPHA]
sort_ro: sort_ro0;
sort_ro1: SORT_RO2;
SORT_RO2: 'sort_ro';
sort_ro3: key;
sort_ro6: SORT7;
sort_ro7: pattern;
sort_ro5: sort_ro6 sort_ro7;
sort_ro4: sort_ro5 | ;
sort_ro10: FT_DOT_SEARCH193;
sort_ro11: offset;
sort_ro12: count;
sort_ro9: sort_ro10 sort_ro11 sort_ro12;
sort_ro8: sort_ro9 | ;
sort_ro15: BITFIELD10;
sort_ro16: pattern;
sort_ro19: BITFIELD10;
sort_ro20: pattern;
sort_ro18: sort_ro19 sort_ro20;
sort_ro17: sort_ro18 | sort_ro17 sort_ro18 | ;
sort_ro14: sort_ro15 sort_ro16 sort_ro17;
sort_ro13: sort_ro14 | ;
sort_ro24: FT_DOT_SEARCH187;
sort_ro25: FT_DOT_SEARCH189;
sort_ro23: sort_ro24 | sort_ro25;
sort_ro22: sort_ro23;
sort_ro21: sort_ro22 | ;
sort_ro28: SORT30;
sort_ro27: sort_ro28;
sort_ro26: sort_ro27 | ;
sort_ro0: sort_ro1 sort_ro3 sort_ro4 sort_ro8 sort_ro13 sort_ro21 sort_ro26;

// SPOP key [count]
spop: spop0;
spop1: SPOP2;
SPOP2: 'spop';
spop3: elem=key #SPopRule1;
spop6: count;
spop5: spop6;
spop4: spop5 | ;
spop0: spop1 spop3 spop4;

// SPUBLISH shardchannel message
spublish: spublish0;
spublish1: SPUBLISH2;
SPUBLISH2: 'spublish';
spublish3: shardchannel;
spublish4: message;
spublish0: spublish1 spublish3 spublish4;

// SRANDMEMBER key [count]
srandmember: srandmember0;
srandmember1: SRANDMEMBER2;
SRANDMEMBER2: 'srandmember';
srandmember3: elem=key #SRandMemberRule1;
srandmember6: count;
srandmember5: srandmember6;
srandmember4: srandmember5 | ;
srandmember0: srandmember1 srandmember3 srandmember4;

// SREM key member [member ...]
srem: srem0;
srem1: SREM2;
SREM2: 'srem';
srem3: elem=key #SRemRule1;
srem4: member;
srem7: member;
srem6: srem7;
srem5: srem6 | srem5 srem6 | ;
srem0: srem1 srem3 srem4 srem5;

// SSCAN key cursor [MATCH pattern] [COUNT count]
sscan: sscan0;
sscan1: SSCAN2;
SSCAN2: 'sscan';
sscan3: elem=key #SScanRule1;
sscan4: cursor;
sscan7: HSCAN8;
sscan8: pattern;
sscan6: sscan7 sscan8;
sscan5: sscan6 | ;
sscan11: BLMPOP17;
sscan12: count;
sscan10: sscan11 sscan12;
sscan9: sscan10 | ;
sscan0: sscan1 sscan3 sscan4 sscan5 sscan9;

// SSUBSCRIBE shardchannel [shardchannel ...]
ssubscribe: ssubscribe0;
ssubscribe1: SSUBSCRIBE2;
SSUBSCRIBE2: 'ssubscribe';
ssubscribe3: shardchannel;
ssubscribe6: shardchannel;
ssubscribe5: ssubscribe6;
ssubscribe4: ssubscribe5 | ssubscribe4 ssubscribe5 | ;
ssubscribe0: ssubscribe1 ssubscribe3 ssubscribe4;

// STRLEN key
strlen: strlen0;
strlen1: STRLEN2;
STRLEN2: 'strlen';
strlen3: elem=key #StrLenRule1;
strlen0: strlen1 strlen3;

// SUBSCRIBE channel [channel ...]
subscribe: subscribe0;
subscribe1: SUBSCRIBE2;
SUBSCRIBE2: 'subscribe';
subscribe3: channel;
subscribe6: channel;
subscribe5: subscribe6;
subscribe4: subscribe5 | subscribe4 subscribe5 | ;
subscribe0: subscribe1 subscribe3 subscribe4;

// SUBSTR key start end
substr: substr0;
substr1: SUBSTR2;
SUBSTR2: 'substr';
substr3: elem=key #SubStrRule1;
substr4: start;
substr5: end;
substr0: substr1 substr3 substr4 substr5;

// SUNION key [key ...]
sunion: sunion0;
sunion1: SUNION2;
SUNION2: 'sunion';
sunion3: elem=key #SUnionRule1;
sunion6: elem=key #SUnionRule2;
sunion5: sunion6;
sunion4: sunion5 | sunion4 sunion5 | ;
sunion0: sunion1 sunion3 sunion4;

// SUNIONSTORE destination key [key ...]
sunionstore: sunionstore0;
sunionstore1: SUNIONSTORE2;
SUNIONSTORE2: 'sunionstore';
sunionstore3: elem=destination #SUnionStoreRule0;
sunionstore4: elem=key #SUnionStoreRule1;
sunionstore7: elem=key #SUnionStoreRule2;
sunionstore6: sunionstore7;
sunionstore5: sunionstore6 | sunionstore5 sunionstore6 | ;
sunionstore0: sunionstore1 sunionstore3 sunionstore4 sunionstore5;

// SUNSUBSCRIBE [shardchannel [shardchannel ...]]
sunsubscribe: sunsubscribe0;
sunsubscribe1: SUNSUBSCRIBE2;
SUNSUBSCRIBE2: 'sunsubscribe';
sunsubscribe5: shardchannel;
sunsubscribe8: shardchannel;
sunsubscribe7: sunsubscribe8;
sunsubscribe6: sunsubscribe7 | sunsubscribe6 sunsubscribe7 | ;
sunsubscribe4: sunsubscribe5 sunsubscribe6;
sunsubscribe3: sunsubscribe4 | ;
sunsubscribe0: sunsubscribe1 sunsubscribe3;

// SWAPDB index1 index2
swapdb: swapdb0;
swapdb1: SWAPDB2;
SWAPDB2: 'swapdb';
swapdb3: index1;
swapdb4: index2;
swapdb0: swapdb1 swapdb3 swapdb4;

// SYNC
sync: sync0;
sync1: FLUSHALL9;
sync0: sync1;

// TDIGEST.ADD key value [value ...]
tdigest_dot_add: tdigest_dot_add0;
tdigest_dot_add1: TDIGEST_DOT_ADD2;
TDIGEST_DOT_ADD2: 'tdigest.add';
tdigest_dot_add3: key;
tdigest_dot_add4: value;
tdigest_dot_add7: value;
tdigest_dot_add6: tdigest_dot_add7;
tdigest_dot_add5: tdigest_dot_add6 | tdigest_dot_add5 tdigest_dot_add6 | ;
tdigest_dot_add0: tdigest_dot_add1 tdigest_dot_add3 tdigest_dot_add4 tdigest_dot_add5;

// TDIGEST.BYRANK key rank [rank ...]
tdigest_dot_byrank: tdigest_dot_byrank0;
tdigest_dot_byrank1: TDIGEST_DOT_BYRANK2;
TDIGEST_DOT_BYRANK2: 'tdigest.byrank';
tdigest_dot_byrank3: key;
tdigest_dot_byrank4: rank;
tdigest_dot_byrank7: rank;
tdigest_dot_byrank6: tdigest_dot_byrank7;
tdigest_dot_byrank5: tdigest_dot_byrank6 | tdigest_dot_byrank5 tdigest_dot_byrank6 | ;
tdigest_dot_byrank0: tdigest_dot_byrank1 tdigest_dot_byrank3 tdigest_dot_byrank4 tdigest_dot_byrank5;

// TDIGEST.BYREVRANK key reverse_rank [reverse_rank ...]
// tdigest_dot_byrevrank: tdigest_dot_byrevrank0;
// todo: {'reverse_rank'}
/*
tdigest_dot_byrevrank1: TDIGEST_DOT_BYREVRANK2;
TDIGEST_DOT_BYREVRANK2: 'tdigest.byrevrank';
tdigest_dot_byrevrank3: key;
tdigest_dot_byrevrank4: tdigest_dot_byrevrank5;
tdigest_dot_byrevrank5: 'reverse_rank.TODO';
tdigest_dot_byrevrank8: tdigest_dot_byrevrank9;
tdigest_dot_byrevrank9: 'reverse_rank.TODO';
tdigest_dot_byrevrank7: tdigest_dot_byrevrank8;
tdigest_dot_byrevrank6: tdigest_dot_byrevrank7 | tdigest_dot_byrevrank6 tdigest_dot_byrevrank7 | ;
tdigest_dot_byrevrank0: tdigest_dot_byrevrank1 tdigest_dot_byrevrank3 tdigest_dot_byrevrank4 tdigest_dot_byrevrank6;

*/
// TDIGEST.CDF key value [value ...]
tdigest_dot_cdf: tdigest_dot_cdf0;
tdigest_dot_cdf1: TDIGEST_DOT_CDF2;
TDIGEST_DOT_CDF2: 'tdigest.cdf';
tdigest_dot_cdf3: key;
tdigest_dot_cdf4: value;
tdigest_dot_cdf7: value;
tdigest_dot_cdf6: tdigest_dot_cdf7;
tdigest_dot_cdf5: tdigest_dot_cdf6 | tdigest_dot_cdf5 tdigest_dot_cdf6 | ;
tdigest_dot_cdf0: tdigest_dot_cdf1 tdigest_dot_cdf3 tdigest_dot_cdf4 tdigest_dot_cdf5;

// TDIGEST.CREATE key [COMPRESSION compression]
// tdigest_dot_create: tdigest_dot_create0;
// todo: {'compression'}
/*
tdigest_dot_create1: TDIGEST_DOT_CREATE2;
TDIGEST_DOT_CREATE2: 'tdigest.create';
tdigest_dot_create3: key;
tdigest_dot_create6: TDIGEST_DOT_CREATE7;
TDIGEST_DOT_CREATE7: 'compression';
tdigest_dot_create8: tdigest_dot_create9;
tdigest_dot_create9: 'compression.TODO';
tdigest_dot_create5: tdigest_dot_create6 tdigest_dot_create8;
tdigest_dot_create4: tdigest_dot_create5 | ;
tdigest_dot_create0: tdigest_dot_create1 tdigest_dot_create3 tdigest_dot_create4;

*/
// TDIGEST.INFO key
tdigest_dot_info: tdigest_dot_info0;
tdigest_dot_info1: TDIGEST_DOT_INFO2;
TDIGEST_DOT_INFO2: 'tdigest.info';
tdigest_dot_info3: key;
tdigest_dot_info0: tdigest_dot_info1 tdigest_dot_info3;

// TDIGEST.MAX key
tdigest_dot_max: tdigest_dot_max0;
tdigest_dot_max1: TDIGEST_DOT_MAX2;
TDIGEST_DOT_MAX2: 'tdigest.max';
tdigest_dot_max3: key;
tdigest_dot_max0: tdigest_dot_max1 tdigest_dot_max3;

// TDIGEST.MERGE destination_key numkeys sourceKey [sourceKey ...]   [COMPRESSION compression] [OVERRIDE]
// tdigest_dot_merge: tdigest_dot_merge0;
// todo: {'destination_key', 'sourceKey', 'compression'}
/*
tdigest_dot_merge1: TDIGEST_DOT_MERGE2;
TDIGEST_DOT_MERGE2: 'tdigest.merge';
tdigest_dot_merge3: tdigest_dot_merge4;
tdigest_dot_merge4: 'destination_key.TODO';
tdigest_dot_merge5: numkeys;
tdigest_dot_merge6: tdigest_dot_merge7;
tdigest_dot_merge7: 'sourceKey.TODO';
tdigest_dot_merge10: tdigest_dot_merge11;
tdigest_dot_merge11: 'sourceKey.TODO';
tdigest_dot_merge9: tdigest_dot_merge10;
tdigest_dot_merge8: tdigest_dot_merge9 | tdigest_dot_merge8 tdigest_dot_merge9 | ;
tdigest_dot_merge14: TDIGEST_DOT_MERGE15;
TDIGEST_DOT_MERGE15: 'compression';
tdigest_dot_merge16: tdigest_dot_merge17;
tdigest_dot_merge17: 'compression.TODO';
tdigest_dot_merge13: tdigest_dot_merge14 tdigest_dot_merge16;
tdigest_dot_merge12: tdigest_dot_merge13 | ;
tdigest_dot_merge20: TDIGEST_DOT_MERGE21;
TDIGEST_DOT_MERGE21: 'override';
tdigest_dot_merge19: tdigest_dot_merge20;
tdigest_dot_merge18: tdigest_dot_merge19 | ;
tdigest_dot_merge0: tdigest_dot_merge1 tdigest_dot_merge3 tdigest_dot_merge5 tdigest_dot_merge6 tdigest_dot_merge8 tdigest_dot_merge12 tdigest_dot_merge18;

*/
// TDIGEST.MIN key
tdigest_dot_min: tdigest_dot_min0;
tdigest_dot_min1: TDIGEST_DOT_MIN2;
TDIGEST_DOT_MIN2: 'tdigest.min';
tdigest_dot_min3: key;
tdigest_dot_min0: tdigest_dot_min1 tdigest_dot_min3;

// TDIGEST.QUANTILE key quantile [quantile ...]
// tdigest_dot_quantile: tdigest_dot_quantile0;
// todo: {'quantile'}
/*
tdigest_dot_quantile1: TDIGEST_DOT_QUANTILE2;
TDIGEST_DOT_QUANTILE2: 'tdigest.quantile';
tdigest_dot_quantile3: key;
tdigest_dot_quantile4: tdigest_dot_quantile5;
tdigest_dot_quantile5: 'quantile.TODO';
tdigest_dot_quantile8: tdigest_dot_quantile9;
tdigest_dot_quantile9: 'quantile.TODO';
tdigest_dot_quantile7: tdigest_dot_quantile8;
tdigest_dot_quantile6: tdigest_dot_quantile7 | tdigest_dot_quantile6 tdigest_dot_quantile7 | ;
tdigest_dot_quantile0: tdigest_dot_quantile1 tdigest_dot_quantile3 tdigest_dot_quantile4 tdigest_dot_quantile6;

*/
// TDIGEST.RANK key value [value ...]
tdigest_dot_rank: tdigest_dot_rank0;
tdigest_dot_rank1: TDIGEST_DOT_RANK2;
TDIGEST_DOT_RANK2: 'tdigest.rank';
tdigest_dot_rank3: key;
tdigest_dot_rank4: value;
tdigest_dot_rank7: value;
tdigest_dot_rank6: tdigest_dot_rank7;
tdigest_dot_rank5: tdigest_dot_rank6 | tdigest_dot_rank5 tdigest_dot_rank6 | ;
tdigest_dot_rank0: tdigest_dot_rank1 tdigest_dot_rank3 tdigest_dot_rank4 tdigest_dot_rank5;

// TDIGEST.RESET key
tdigest_dot_reset: tdigest_dot_reset0;
tdigest_dot_reset1: TDIGEST_DOT_RESET2;
TDIGEST_DOT_RESET2: 'tdigest.reset';
tdigest_dot_reset3: key;
tdigest_dot_reset0: tdigest_dot_reset1 tdigest_dot_reset3;

// TDIGEST.REVRANK key value [value ...]
tdigest_dot_revrank: tdigest_dot_revrank0;
tdigest_dot_revrank1: TDIGEST_DOT_REVRANK2;
TDIGEST_DOT_REVRANK2: 'tdigest.revrank';
tdigest_dot_revrank3: key;
tdigest_dot_revrank4: value;
tdigest_dot_revrank7: value;
tdigest_dot_revrank6: tdigest_dot_revrank7;
tdigest_dot_revrank5: tdigest_dot_revrank6 | tdigest_dot_revrank5 tdigest_dot_revrank6 | ;
tdigest_dot_revrank0: tdigest_dot_revrank1 tdigest_dot_revrank3 tdigest_dot_revrank4 tdigest_dot_revrank5;

// TDIGEST.TRIMMED_MEAN key low_cut_quantile high_cut_quantile
// tdigest_dot_trimmed_mean: tdigest_dot_trimmed_mean0;
// todo: {'low_cut_quantile', 'high_cut_quantile'}
/*
tdigest_dot_trimmed_mean1: TDIGEST_DOT_TRIMMED_MEAN2;
TDIGEST_DOT_TRIMMED_MEAN2: 'tdigest.trimmed_mean';
tdigest_dot_trimmed_mean3: key;
tdigest_dot_trimmed_mean4: tdigest_dot_trimmed_mean5;
tdigest_dot_trimmed_mean5: 'low_cut_quantile.TODO';
tdigest_dot_trimmed_mean6: tdigest_dot_trimmed_mean7;
tdigest_dot_trimmed_mean7: 'high_cut_quantile.TODO';
tdigest_dot_trimmed_mean0: tdigest_dot_trimmed_mean1 tdigest_dot_trimmed_mean3 tdigest_dot_trimmed_mean4 tdigest_dot_trimmed_mean6;

*/
// TIME
time: time0;
time1: TIME2;
TIME2: 'time';
time0: time1;

// TOPK.ADD key items [items ...]
// topk_dot_add: topk_dot_add0;
// todo: {'items'}
/*
topk_dot_add1: TOPK_DOT_ADD2;
TOPK_DOT_ADD2: 'topk.add';
topk_dot_add3: key;
topk_dot_add4: topk_dot_add5;
topk_dot_add5: 'items.TODO';
topk_dot_add8: topk_dot_add9;
topk_dot_add9: 'items.TODO';
topk_dot_add7: topk_dot_add8;
topk_dot_add6: topk_dot_add7 | topk_dot_add6 topk_dot_add7 | ;
topk_dot_add0: topk_dot_add1 topk_dot_add3 topk_dot_add4 topk_dot_add6;

*/
// TOPK.COUNT key item [item ...]
topk_dot_count: topk_dot_count0;
topk_dot_count1: TOPK_DOT_COUNT2;
TOPK_DOT_COUNT2: 'topk.count';
topk_dot_count3: key;
topk_dot_count4: item;
topk_dot_count7: item;
topk_dot_count6: topk_dot_count7;
topk_dot_count5: topk_dot_count6 | topk_dot_count5 topk_dot_count6 | ;
topk_dot_count0: topk_dot_count1 topk_dot_count3 topk_dot_count4 topk_dot_count5;

// TOPK.INCRBY key item increment [item increment ...]
topk_dot_incrby: topk_dot_incrby0;
topk_dot_incrby1: TOPK_DOT_INCRBY2;
TOPK_DOT_INCRBY2: 'topk.incrby';
topk_dot_incrby3: key;
topk_dot_incrby4: item;
topk_dot_incrby5: increment;
topk_dot_incrby8: item;
topk_dot_incrby9: increment;
topk_dot_incrby7: topk_dot_incrby8 topk_dot_incrby9;
topk_dot_incrby6: topk_dot_incrby7 | topk_dot_incrby6 topk_dot_incrby7 | ;
topk_dot_incrby0: topk_dot_incrby1 topk_dot_incrby3 topk_dot_incrby4 topk_dot_incrby5 topk_dot_incrby6;

// TOPK.INFO key
topk_dot_info: topk_dot_info0;
topk_dot_info1: TOPK_DOT_INFO2;
TOPK_DOT_INFO2: 'topk.info';
topk_dot_info3: key;
topk_dot_info0: topk_dot_info1 topk_dot_info3;

// TOPK.LIST key [WITHCOUNT]
topk_dot_list: topk_dot_list0;
topk_dot_list1: TOPK_DOT_LIST2;
TOPK_DOT_LIST2: 'topk.list';
topk_dot_list3: key;
topk_dot_list6: TOPK_DOT_LIST7;
TOPK_DOT_LIST7: 'withcount';
topk_dot_list5: topk_dot_list6;
topk_dot_list4: topk_dot_list5 | ;
topk_dot_list0: topk_dot_list1 topk_dot_list3 topk_dot_list4;

// TOPK.QUERY key item [item ...]
topk_dot_query: topk_dot_query0;
topk_dot_query1: TOPK_DOT_QUERY2;
TOPK_DOT_QUERY2: 'topk.query';
topk_dot_query3: key;
topk_dot_query4: item;
topk_dot_query7: item;
topk_dot_query6: topk_dot_query7;
topk_dot_query5: topk_dot_query6 | topk_dot_query5 topk_dot_query6 | ;
topk_dot_query0: topk_dot_query1 topk_dot_query3 topk_dot_query4 topk_dot_query5;

// TOPK.RESERVE key topk [width depth_arg decay]
// topk_dot_reserve: topk_dot_reserve0;
// todo: {'topk', 'decay'}
/*
topk_dot_reserve1: TOPK_DOT_RESERVE2;
TOPK_DOT_RESERVE2: 'topk.reserve';
topk_dot_reserve3: key;
topk_dot_reserve4: topk_dot_reserve5;
topk_dot_reserve5: 'topk.TODO';
topk_dot_reserve8: width;
topk_dot_reserve9: depth_arg;
topk_dot_reserve10: topk_dot_reserve11;
topk_dot_reserve11: 'decay.TODO';
topk_dot_reserve7: topk_dot_reserve8 topk_dot_reserve9 topk_dot_reserve10;
topk_dot_reserve6: topk_dot_reserve7 | ;
topk_dot_reserve0: topk_dot_reserve1 topk_dot_reserve3 topk_dot_reserve4 topk_dot_reserve6;

*/
// TOUCH key [key ...]
touch: touch0;
touch1: TOUCH2;
TOUCH2: 'touch';
touch3: key;
touch6: key;
touch5: touch6;
touch4: touch5 | touch4 touch5 | ;
touch0: touch1 touch3 touch4;

// TS.ADD key timestamp value    [RETENTION retentionPeriod]    [ENCODING [COMPRESSED|UNCOMPRESSED]]    [CHUNK_SIZE size]    [ON_DUPLICATE policy]    [LABELS [label value ...]] 
// ts_dot_add: ts_dot_add0;
// todo: {'retentionPeriod', 'size', 'policy'}
/*
ts_dot_add1: TS_DOT_ADD2;
TS_DOT_ADD2: 'ts.add';
ts_dot_add3: key;
ts_dot_add4: timestamp;
ts_dot_add5: value;
ts_dot_add8: TS_DOT_ADD9;
TS_DOT_ADD9: 'retention';
ts_dot_add10: ts_dot_add11;
ts_dot_add11: 'retentionPeriod.TODO';
ts_dot_add7: ts_dot_add8 ts_dot_add10;
ts_dot_add6: ts_dot_add7 | ;
ts_dot_add14: OBJECT_SP_ENCODING4;
ts_dot_add18: TS_DOT_ADD19;
TS_DOT_ADD19: 'compressed';
ts_dot_add20: TS_DOT_ADD21;
TS_DOT_ADD21: 'uncompressed';
ts_dot_add17: ts_dot_add18 | ts_dot_add20;
ts_dot_add16: ts_dot_add17;
ts_dot_add15: ts_dot_add16 | ;
ts_dot_add13: ts_dot_add14 ts_dot_add15;
ts_dot_add12: ts_dot_add13 | ;
ts_dot_add24: TS_DOT_ADD25;
TS_DOT_ADD25: 'chunk_size';
ts_dot_add26: ts_dot_add27;
ts_dot_add27: 'size.TODO';
ts_dot_add23: ts_dot_add24 ts_dot_add26;
ts_dot_add22: ts_dot_add23 | ;
ts_dot_add30: TS_DOT_ADD31;
TS_DOT_ADD31: 'on_duplicate';
ts_dot_add32: ts_dot_add33;
ts_dot_add33: 'policy.TODO';
ts_dot_add29: ts_dot_add30 ts_dot_add32;
ts_dot_add28: ts_dot_add29 | ;
ts_dot_add36: TS_DOT_ADD37;
TS_DOT_ADD37: 'labels';
ts_dot_add40: label;
ts_dot_add41: value;
ts_dot_add39: ts_dot_add40 ts_dot_add41;
ts_dot_add38: ts_dot_add39 | ts_dot_add38 ts_dot_add39 | ;
ts_dot_add35: ts_dot_add36 ts_dot_add38;
ts_dot_add34: ts_dot_add35 | ;
ts_dot_add0: ts_dot_add1 ts_dot_add3 ts_dot_add4 ts_dot_add5 ts_dot_add6 ts_dot_add12 ts_dot_add22 ts_dot_add28 ts_dot_add34;

*/
// TS.ALTER key    [RETENTION retentionPeriod]    [CHUNK_SIZE size]    [DUPLICATE_POLICY policy]    [LABELS [{label value}...]] 
// ts_dot_alter: ts_dot_alter0;
// Unable to process

// TS.CREATE key    [RETENTION retentionPeriod]    [ENCODING [UNCOMPRESSED|COMPRESSED]]    [CHUNK_SIZE size]    [DUPLICATE_POLICY policy]    [LABELS {label value}...] 
// ts_dot_create: ts_dot_create0;
// Unable to process

// TS.CREATERULE sourceKey destKey    AGGREGATION aggregator bucketDuration    [alignTimestamp] 
// ts_dot_createrule: ts_dot_createrule0;
// todo: {'sourceKey', 'aggregator', 'bucketDuration', 'alignTimestamp'}
/*
ts_dot_createrule1: TS_DOT_CREATERULE2;
TS_DOT_CREATERULE2: 'ts.createrule';
ts_dot_createrule3: ts_dot_createrule4;
ts_dot_createrule4: 'sourceKey.TODO';
ts_dot_createrule5: destKey;
ts_dot_createrule6: TS_DOT_CREATERULE7;
TS_DOT_CREATERULE7: 'aggregation';
ts_dot_createrule8: ts_dot_createrule9;
ts_dot_createrule9: 'aggregator.TODO';
ts_dot_createrule10: ts_dot_createrule11;
ts_dot_createrule11: 'bucketDuration.TODO';
ts_dot_createrule14: ts_dot_createrule15;
ts_dot_createrule15: 'alignTimestamp.TODO';
ts_dot_createrule13: ts_dot_createrule14;
ts_dot_createrule12: ts_dot_createrule13 | ;
ts_dot_createrule0: ts_dot_createrule1 ts_dot_createrule3 ts_dot_createrule5 ts_dot_createrule6 ts_dot_createrule8 ts_dot_createrule10 ts_dot_createrule12;

*/
// TS.DECRBY key value    [TIMESTAMP timestamp]    [RETENTION retentionPeriod]    [UNCOMPRESSED]    [CHUNK_SIZE size]    [LABELS {label value}...] 
// ts_dot_decrby: ts_dot_decrby0;
// Unable to process

// TS.DEL key fromTimestamp toTimestamp 
// ts_dot_del: ts_dot_del0;
// todo: {'fromTimestamp', 'toTimestamp'}
/*
ts_dot_del1: TS_DOT_DEL2;
TS_DOT_DEL2: 'ts.del';
ts_dot_del3: key;
ts_dot_del4: ts_dot_del5;
ts_dot_del5: 'fromTimestamp.TODO';
ts_dot_del6: ts_dot_del7;
ts_dot_del7: 'toTimestamp.TODO';
ts_dot_del0: ts_dot_del1 ts_dot_del3 ts_dot_del4 ts_dot_del6;

*/
// TS.DELETERULE sourceKey destKey 
// ts_dot_deleterule: ts_dot_deleterule0;
// todo: {'sourceKey'}
/*
ts_dot_deleterule1: TS_DOT_DELETERULE2;
TS_DOT_DELETERULE2: 'ts.deleterule';
ts_dot_deleterule3: ts_dot_deleterule4;
ts_dot_deleterule4: 'sourceKey.TODO';
ts_dot_deleterule5: destKey;
ts_dot_deleterule0: ts_dot_deleterule1 ts_dot_deleterule3 ts_dot_deleterule5;

*/
// TS.GET key    [LATEST] 
ts_dot_get: ts_dot_get0;
ts_dot_get1: TS_DOT_GET2;
TS_DOT_GET2: 'ts.get';
ts_dot_get3: key;
ts_dot_get6: LATENCY_SP_LATEST3;
ts_dot_get5: ts_dot_get6;
ts_dot_get4: ts_dot_get5 | ;
ts_dot_get0: ts_dot_get1 ts_dot_get3 ts_dot_get4;

// TS.INCRBY key value    [TIMESTAMP timestamp]    [RETENTION retentionPeriod]    [UNCOMPRESSED]    [CHUNK_SIZE size]    [LABELS {label value}...] 
// ts_dot_incrby: ts_dot_incrby0;
// Unable to process

// TS.INFO key    [DEBUG] 
ts_dot_info: ts_dot_info0;
ts_dot_info1: TS_DOT_INFO2;
TS_DOT_INFO2: 'ts.info';
ts_dot_info3: key;
ts_dot_info6: SCRIPT_SP_DEBUG4;
ts_dot_info5: ts_dot_info6;
ts_dot_info4: ts_dot_info5 | ;
ts_dot_info0: ts_dot_info1 ts_dot_info3 ts_dot_info4;

// TS.MADD key timestamp value [key timestamp value ...] 
ts_dot_madd: ts_dot_madd0;
ts_dot_madd1: TS_DOT_MADD2;
TS_DOT_MADD2: 'ts.madd';
ts_dot_madd3: key;
ts_dot_madd4: timestamp;
ts_dot_madd5: value;
ts_dot_madd8: key;
ts_dot_madd9: timestamp;
ts_dot_madd10: value;
ts_dot_madd7: ts_dot_madd8 ts_dot_madd9 ts_dot_madd10;
ts_dot_madd6: ts_dot_madd7 | ts_dot_madd6 ts_dot_madd7 | ;
ts_dot_madd0: ts_dot_madd1 ts_dot_madd3 ts_dot_madd4 ts_dot_madd5 ts_dot_madd6;

// TS.MGET [LATEST] [WITHLABELS | SELECTED_LABELS label...] FILTER filter [filter ...] 
// ts_dot_mget: ts_dot_mget0;
// todo: {'label...', 'filter'}
/*
ts_dot_mget1: TS_DOT_MGET2;
TS_DOT_MGET2: 'ts.mget';
ts_dot_mget5: LATENCY_SP_LATEST3;
ts_dot_mget4: ts_dot_mget5;
ts_dot_mget3: ts_dot_mget4 | ;
ts_dot_mget9: TS_DOT_MGET10;
TS_DOT_MGET10: 'withlabels';
ts_dot_mget11: TS_DOT_MGET12;
TS_DOT_MGET12: 'selected_labels';
ts_dot_mget8: ts_dot_mget9 | ts_dot_mget11;
ts_dot_mget13: ts_dot_mget14;
ts_dot_mget14: 'label....TODO';
ts_dot_mget7: ts_dot_mget8 ts_dot_mget13;
ts_dot_mget6: ts_dot_mget7 | ;
ts_dot_mget15: FT_DOT_SEARCH32;
ts_dot_mget16: ts_dot_mget17;
ts_dot_mget17: 'filter.TODO';
ts_dot_mget20: ts_dot_mget21;
ts_dot_mget21: 'filter.TODO';
ts_dot_mget19: ts_dot_mget20;
ts_dot_mget18: ts_dot_mget19 | ts_dot_mget18 ts_dot_mget19 | ;
ts_dot_mget0: ts_dot_mget1 ts_dot_mget3 ts_dot_mget6 ts_dot_mget15 ts_dot_mget16 ts_dot_mget18;

*/
// TS.MRANGE fromTimestamp toTimestamp   [LATEST]   [FILTER_BY_TS ts...]   [FILTER_BY_VALUE min max]   [WITHLABELS | SELECTED_LABELS label...]   [COUNT count]   [[ALIGN align] AGGREGATION aggregator bucketDuration [BUCKETTIMESTAMP bt] [EMPTY]]   FILTER filter..   [GROUPBY label REDUCE reducer] 
// ts_dot_mrange: ts_dot_mrange0;
// todo: {'fromTimestamp', 'toTimestamp', 'ts...', 'label...', 'aggregator', 'bucketDuration', 'bt', 'filter..', 'reducer'}
/*
ts_dot_mrange1: TS_DOT_MRANGE2;
TS_DOT_MRANGE2: 'ts.mrange';
ts_dot_mrange3: ts_dot_mrange4;
ts_dot_mrange4: 'fromTimestamp.TODO';
ts_dot_mrange5: ts_dot_mrange6;
ts_dot_mrange6: 'toTimestamp.TODO';
ts_dot_mrange9: LATENCY_SP_LATEST3;
ts_dot_mrange8: ts_dot_mrange9;
ts_dot_mrange7: ts_dot_mrange8 | ;
ts_dot_mrange12: TS_DOT_MRANGE13;
TS_DOT_MRANGE13: 'filter_by_ts';
ts_dot_mrange14: ts_dot_mrange15;
ts_dot_mrange15: 'ts....TODO';
ts_dot_mrange11: ts_dot_mrange12 ts_dot_mrange14;
ts_dot_mrange10: ts_dot_mrange11 | ;
ts_dot_mrange18: TS_DOT_MRANGE19;
TS_DOT_MRANGE19: 'filter_by_value';
ts_dot_mrange20: min;
ts_dot_mrange21: max;
ts_dot_mrange17: ts_dot_mrange18 ts_dot_mrange20 ts_dot_mrange21;
ts_dot_mrange16: ts_dot_mrange17 | ;
ts_dot_mrange25: TS_DOT_MRANGE26;
TS_DOT_MRANGE26: 'withlabels';
ts_dot_mrange27: TS_DOT_MRANGE28;
TS_DOT_MRANGE28: 'selected_labels';
ts_dot_mrange24: ts_dot_mrange25 | ts_dot_mrange27;
ts_dot_mrange29: ts_dot_mrange30;
ts_dot_mrange30: 'label....TODO';
ts_dot_mrange23: ts_dot_mrange24 ts_dot_mrange29;
ts_dot_mrange22: ts_dot_mrange23 | ;
ts_dot_mrange33: BLMPOP17;
ts_dot_mrange34: count;
ts_dot_mrange32: ts_dot_mrange33 ts_dot_mrange34;
ts_dot_mrange31: ts_dot_mrange32 | ;
ts_dot_mrange39: TS_DOT_MRANGE40;
TS_DOT_MRANGE40: 'align';
ts_dot_mrange41: align;
ts_dot_mrange38: ts_dot_mrange39 ts_dot_mrange41;
ts_dot_mrange37: ts_dot_mrange38 | ;
ts_dot_mrange42: TS_DOT_MRANGE43;
TS_DOT_MRANGE43: 'aggregation';
ts_dot_mrange44: ts_dot_mrange45;
ts_dot_mrange45: 'aggregator.TODO';
ts_dot_mrange46: ts_dot_mrange47;
ts_dot_mrange47: 'bucketDuration.TODO';
ts_dot_mrange50: TS_DOT_MRANGE51;
TS_DOT_MRANGE51: 'buckettimestamp';
ts_dot_mrange52: ts_dot_mrange53;
ts_dot_mrange53: 'bt.TODO';
ts_dot_mrange49: ts_dot_mrange50 ts_dot_mrange52;
ts_dot_mrange48: ts_dot_mrange49 | ;
ts_dot_mrange56: TS_DOT_MRANGE57;
TS_DOT_MRANGE57: 'empty';
ts_dot_mrange55: ts_dot_mrange56;
ts_dot_mrange54: ts_dot_mrange55 | ;
ts_dot_mrange36: ts_dot_mrange37 ts_dot_mrange42 ts_dot_mrange44 ts_dot_mrange46 ts_dot_mrange48 ts_dot_mrange54;
ts_dot_mrange35: ts_dot_mrange36 | ;
ts_dot_mrange58: FT_DOT_SEARCH32;
ts_dot_mrange59: ts_dot_mrange60;
ts_dot_mrange60: 'filter...TODO';
ts_dot_mrange63: TS_DOT_MRANGE64;
TS_DOT_MRANGE64: 'groupby';
ts_dot_mrange65: label;
ts_dot_mrange66: TS_DOT_MRANGE67;
TS_DOT_MRANGE67: 'reduce';
ts_dot_mrange68: ts_dot_mrange69;
ts_dot_mrange69: 'reducer.TODO';
ts_dot_mrange62: ts_dot_mrange63 ts_dot_mrange65 ts_dot_mrange66 ts_dot_mrange68;
ts_dot_mrange61: ts_dot_mrange62 | ;
ts_dot_mrange0: ts_dot_mrange1 ts_dot_mrange3 ts_dot_mrange5 ts_dot_mrange7 ts_dot_mrange10 ts_dot_mrange16 ts_dot_mrange22 ts_dot_mrange31 ts_dot_mrange35 ts_dot_mrange58 ts_dot_mrange59 ts_dot_mrange61;

*/
// TS.MREVRANGE fromTimestamp toTimestamp   [LATEST]   [FILTER_BY_TS TS...]   [FILTER_BY_VALUE min max]   [WITHLABELS | SELECTED_LABELS label...]   [COUNT count]   [[ALIGN align] AGGREGATION aggregator bucketDuration [BUCKETTIMESTAMP bt] [EMPTY]]   FILTER filter..   [GROUPBY label REDUCE reducer] 
// ts_dot_mrevrange: ts_dot_mrevrange0;
// todo: {'fromTimestamp', 'toTimestamp', 'label...', 'aggregator', 'bucketDuration', 'bt', 'filter..', 'reducer'}
/*
ts_dot_mrevrange1: TS_DOT_MREVRANGE2;
TS_DOT_MREVRANGE2: 'ts.mrevrange';
ts_dot_mrevrange3: ts_dot_mrevrange4;
ts_dot_mrevrange4: 'fromTimestamp.TODO';
ts_dot_mrevrange5: ts_dot_mrevrange6;
ts_dot_mrevrange6: 'toTimestamp.TODO';
ts_dot_mrevrange9: LATENCY_SP_LATEST3;
ts_dot_mrevrange8: ts_dot_mrevrange9;
ts_dot_mrevrange7: ts_dot_mrevrange8 | ;
ts_dot_mrevrange12: TS_DOT_MREVRANGE13;
TS_DOT_MREVRANGE13: 'filter_by_ts';
ts_dot_mrevrange14: TS_DOT_MREVRANGE15;
TS_DOT_MREVRANGE15: 'ts...';
ts_dot_mrevrange11: ts_dot_mrevrange12 ts_dot_mrevrange14;
ts_dot_mrevrange10: ts_dot_mrevrange11 | ;
ts_dot_mrevrange18: TS_DOT_MREVRANGE19;
TS_DOT_MREVRANGE19: 'filter_by_value';
ts_dot_mrevrange20: min;
ts_dot_mrevrange21: max;
ts_dot_mrevrange17: ts_dot_mrevrange18 ts_dot_mrevrange20 ts_dot_mrevrange21;
ts_dot_mrevrange16: ts_dot_mrevrange17 | ;
ts_dot_mrevrange25: TS_DOT_MREVRANGE26;
TS_DOT_MREVRANGE26: 'withlabels';
ts_dot_mrevrange27: TS_DOT_MREVRANGE28;
TS_DOT_MREVRANGE28: 'selected_labels';
ts_dot_mrevrange24: ts_dot_mrevrange25 | ts_dot_mrevrange27;
ts_dot_mrevrange29: ts_dot_mrevrange30;
ts_dot_mrevrange30: 'label....TODO';
ts_dot_mrevrange23: ts_dot_mrevrange24 ts_dot_mrevrange29;
ts_dot_mrevrange22: ts_dot_mrevrange23 | ;
ts_dot_mrevrange33: BLMPOP17;
ts_dot_mrevrange34: count;
ts_dot_mrevrange32: ts_dot_mrevrange33 ts_dot_mrevrange34;
ts_dot_mrevrange31: ts_dot_mrevrange32 | ;
ts_dot_mrevrange39: TS_DOT_MREVRANGE40;
TS_DOT_MREVRANGE40: 'align';
ts_dot_mrevrange41: align;
ts_dot_mrevrange38: ts_dot_mrevrange39 ts_dot_mrevrange41;
ts_dot_mrevrange37: ts_dot_mrevrange38 | ;
ts_dot_mrevrange42: TS_DOT_MREVRANGE43;
TS_DOT_MREVRANGE43: 'aggregation';
ts_dot_mrevrange44: ts_dot_mrevrange45;
ts_dot_mrevrange45: 'aggregator.TODO';
ts_dot_mrevrange46: ts_dot_mrevrange47;
ts_dot_mrevrange47: 'bucketDuration.TODO';
ts_dot_mrevrange50: TS_DOT_MREVRANGE51;
TS_DOT_MREVRANGE51: 'buckettimestamp';
ts_dot_mrevrange52: ts_dot_mrevrange53;
ts_dot_mrevrange53: 'bt.TODO';
ts_dot_mrevrange49: ts_dot_mrevrange50 ts_dot_mrevrange52;
ts_dot_mrevrange48: ts_dot_mrevrange49 | ;
ts_dot_mrevrange56: TS_DOT_MREVRANGE57;
TS_DOT_MREVRANGE57: 'empty';
ts_dot_mrevrange55: ts_dot_mrevrange56;
ts_dot_mrevrange54: ts_dot_mrevrange55 | ;
ts_dot_mrevrange36: ts_dot_mrevrange37 ts_dot_mrevrange42 ts_dot_mrevrange44 ts_dot_mrevrange46 ts_dot_mrevrange48 ts_dot_mrevrange54;
ts_dot_mrevrange35: ts_dot_mrevrange36 | ;
ts_dot_mrevrange58: FT_DOT_SEARCH32;
ts_dot_mrevrange59: ts_dot_mrevrange60;
ts_dot_mrevrange60: 'filter...TODO';
ts_dot_mrevrange63: TS_DOT_MREVRANGE64;
TS_DOT_MREVRANGE64: 'groupby';
ts_dot_mrevrange65: label;
ts_dot_mrevrange66: TS_DOT_MREVRANGE67;
TS_DOT_MREVRANGE67: 'reduce';
ts_dot_mrevrange68: ts_dot_mrevrange69;
ts_dot_mrevrange69: 'reducer.TODO';
ts_dot_mrevrange62: ts_dot_mrevrange63 ts_dot_mrevrange65 ts_dot_mrevrange66 ts_dot_mrevrange68;
ts_dot_mrevrange61: ts_dot_mrevrange62 | ;
ts_dot_mrevrange0: ts_dot_mrevrange1 ts_dot_mrevrange3 ts_dot_mrevrange5 ts_dot_mrevrange7 ts_dot_mrevrange10 ts_dot_mrevrange16 ts_dot_mrevrange22 ts_dot_mrevrange31 ts_dot_mrevrange35 ts_dot_mrevrange58 ts_dot_mrevrange59 ts_dot_mrevrange61;

*/
// TS.QUERYINDEX filter [filter ...] 
// ts_dot_queryindex: ts_dot_queryindex0;
// todo: {'filter'}
/*
ts_dot_queryindex1: TS_DOT_QUERYINDEX2;
TS_DOT_QUERYINDEX2: 'ts.queryindex';
ts_dot_queryindex3: ts_dot_queryindex4;
ts_dot_queryindex4: 'filter.TODO';
ts_dot_queryindex7: ts_dot_queryindex8;
ts_dot_queryindex8: 'filter.TODO';
ts_dot_queryindex6: ts_dot_queryindex7;
ts_dot_queryindex5: ts_dot_queryindex6 | ts_dot_queryindex5 ts_dot_queryindex6 | ;
ts_dot_queryindex0: ts_dot_queryindex1 ts_dot_queryindex3 ts_dot_queryindex5;

*/
// TS.RANGE key fromTimestamp toTimestamp   [LATEST]   [FILTER_BY_TS ts...]   [FILTER_BY_VALUE min max]   [COUNT count]    [[ALIGN align] AGGREGATION aggregator bucketDuration [BUCKETTIMESTAMP bt] [EMPTY]] 
// ts_dot_range: ts_dot_range0;
// todo: {'fromTimestamp', 'toTimestamp', 'ts...', 'aggregator', 'bucketDuration', 'bt'}
/*
ts_dot_range1: TS_DOT_RANGE2;
TS_DOT_RANGE2: 'ts.range';
ts_dot_range3: key;
ts_dot_range4: ts_dot_range5;
ts_dot_range5: 'fromTimestamp.TODO';
ts_dot_range6: ts_dot_range7;
ts_dot_range7: 'toTimestamp.TODO';
ts_dot_range10: LATENCY_SP_LATEST3;
ts_dot_range9: ts_dot_range10;
ts_dot_range8: ts_dot_range9 | ;
ts_dot_range13: TS_DOT_RANGE14;
TS_DOT_RANGE14: 'filter_by_ts';
ts_dot_range15: ts_dot_range16;
ts_dot_range16: 'ts....TODO';
ts_dot_range12: ts_dot_range13 ts_dot_range15;
ts_dot_range11: ts_dot_range12 | ;
ts_dot_range19: TS_DOT_RANGE20;
TS_DOT_RANGE20: 'filter_by_value';
ts_dot_range21: min;
ts_dot_range22: max;
ts_dot_range18: ts_dot_range19 ts_dot_range21 ts_dot_range22;
ts_dot_range17: ts_dot_range18 | ;
ts_dot_range25: BLMPOP17;
ts_dot_range26: count;
ts_dot_range24: ts_dot_range25 ts_dot_range26;
ts_dot_range23: ts_dot_range24 | ;
ts_dot_range31: TS_DOT_RANGE32;
TS_DOT_RANGE32: 'align';
ts_dot_range33: align;
ts_dot_range30: ts_dot_range31 ts_dot_range33;
ts_dot_range29: ts_dot_range30 | ;
ts_dot_range34: TS_DOT_RANGE35;
TS_DOT_RANGE35: 'aggregation';
ts_dot_range36: ts_dot_range37;
ts_dot_range37: 'aggregator.TODO';
ts_dot_range38: ts_dot_range39;
ts_dot_range39: 'bucketDuration.TODO';
ts_dot_range42: TS_DOT_RANGE43;
TS_DOT_RANGE43: 'buckettimestamp';
ts_dot_range44: ts_dot_range45;
ts_dot_range45: 'bt.TODO';
ts_dot_range41: ts_dot_range42 ts_dot_range44;
ts_dot_range40: ts_dot_range41 | ;
ts_dot_range48: TS_DOT_RANGE49;
TS_DOT_RANGE49: 'empty';
ts_dot_range47: ts_dot_range48;
ts_dot_range46: ts_dot_range47 | ;
ts_dot_range28: ts_dot_range29 ts_dot_range34 ts_dot_range36 ts_dot_range38 ts_dot_range40 ts_dot_range46;
ts_dot_range27: ts_dot_range28 | ;
ts_dot_range0: ts_dot_range1 ts_dot_range3 ts_dot_range4 ts_dot_range6 ts_dot_range8 ts_dot_range11 ts_dot_range17 ts_dot_range23 ts_dot_range27;

*/
// TS.REVRANGE key fromTimestamp toTimestamp   [LATEST]   [FILTER_BY_TS TS...]   [FILTER_BY_VALUE min max]   [COUNT count]   [[ALIGN align] AGGREGATION aggregator bucketDuration [BUCKETTIMESTAMP bt] [EMPTY]] 
// ts_dot_revrange: ts_dot_revrange0;
// todo: {'fromTimestamp', 'toTimestamp', 'aggregator', 'bucketDuration', 'bt'}
/*
ts_dot_revrange1: TS_DOT_REVRANGE2;
TS_DOT_REVRANGE2: 'ts.revrange';
ts_dot_revrange3: key;
ts_dot_revrange4: ts_dot_revrange5;
ts_dot_revrange5: 'fromTimestamp.TODO';
ts_dot_revrange6: ts_dot_revrange7;
ts_dot_revrange7: 'toTimestamp.TODO';
ts_dot_revrange10: LATENCY_SP_LATEST3;
ts_dot_revrange9: ts_dot_revrange10;
ts_dot_revrange8: ts_dot_revrange9 | ;
ts_dot_revrange13: TS_DOT_REVRANGE14;
TS_DOT_REVRANGE14: 'filter_by_ts';
ts_dot_revrange15: TS_DOT_REVRANGE16;
TS_DOT_REVRANGE16: 'ts...';
ts_dot_revrange12: ts_dot_revrange13 ts_dot_revrange15;
ts_dot_revrange11: ts_dot_revrange12 | ;
ts_dot_revrange19: TS_DOT_REVRANGE20;
TS_DOT_REVRANGE20: 'filter_by_value';
ts_dot_revrange21: min;
ts_dot_revrange22: max;
ts_dot_revrange18: ts_dot_revrange19 ts_dot_revrange21 ts_dot_revrange22;
ts_dot_revrange17: ts_dot_revrange18 | ;
ts_dot_revrange25: BLMPOP17;
ts_dot_revrange26: count;
ts_dot_revrange24: ts_dot_revrange25 ts_dot_revrange26;
ts_dot_revrange23: ts_dot_revrange24 | ;
ts_dot_revrange31: TS_DOT_REVRANGE32;
TS_DOT_REVRANGE32: 'align';
ts_dot_revrange33: align;
ts_dot_revrange30: ts_dot_revrange31 ts_dot_revrange33;
ts_dot_revrange29: ts_dot_revrange30 | ;
ts_dot_revrange34: TS_DOT_REVRANGE35;
TS_DOT_REVRANGE35: 'aggregation';
ts_dot_revrange36: ts_dot_revrange37;
ts_dot_revrange37: 'aggregator.TODO';
ts_dot_revrange38: ts_dot_revrange39;
ts_dot_revrange39: 'bucketDuration.TODO';
ts_dot_revrange42: TS_DOT_REVRANGE43;
TS_DOT_REVRANGE43: 'buckettimestamp';
ts_dot_revrange44: ts_dot_revrange45;
ts_dot_revrange45: 'bt.TODO';
ts_dot_revrange41: ts_dot_revrange42 ts_dot_revrange44;
ts_dot_revrange40: ts_dot_revrange41 | ;
ts_dot_revrange48: TS_DOT_REVRANGE49;
TS_DOT_REVRANGE49: 'empty';
ts_dot_revrange47: ts_dot_revrange48;
ts_dot_revrange46: ts_dot_revrange47 | ;
ts_dot_revrange28: ts_dot_revrange29 ts_dot_revrange34 ts_dot_revrange36 ts_dot_revrange38 ts_dot_revrange40 ts_dot_revrange46;
ts_dot_revrange27: ts_dot_revrange28 | ;
ts_dot_revrange0: ts_dot_revrange1 ts_dot_revrange3 ts_dot_revrange4 ts_dot_revrange6 ts_dot_revrange8 ts_dot_revrange11 ts_dot_revrange17 ts_dot_revrange23 ts_dot_revrange27;

*/
// TTL key
ttl: ttl0;
ttl1: TTL2;
TTL2: 'ttl';
ttl3: key;
ttl0: ttl1 ttl3;

// TYPE key
type: type0;
type1: SCAN15;
type2: key;
type0: type1 type2;

// UNLINK key [key ...]
unlink: unlink0;
unlink1: UNLINK2;
UNLINK2: 'unlink';
unlink3: key;
unlink6: key;
unlink5: unlink6;
unlink4: unlink5 | unlink4 unlink5 | ;
unlink0: unlink1 unlink3 unlink4;

// UNSUBSCRIBE [channel [channel ...]]
unsubscribe: unsubscribe0;
unsubscribe1: UNSUBSCRIBE2;
UNSUBSCRIBE2: 'unsubscribe';
unsubscribe5: channel;
unsubscribe8: channel;
unsubscribe7: unsubscribe8;
unsubscribe6: unsubscribe7 | unsubscribe6 unsubscribe7 | ;
unsubscribe4: unsubscribe5 unsubscribe6;
unsubscribe3: unsubscribe4 | ;
unsubscribe0: unsubscribe1 unsubscribe3;

// UNWATCH
unwatch: unwatch0;
unwatch1: UNWATCH2;
UNWATCH2: 'unwatch';
unwatch0: unwatch1;

// WAIT numreplicas timeout
wait: wait0;
wait1: WAIT2;
WAIT2: 'wait';
wait3: numreplicas;
wait4: timeout;
wait0: wait1 wait3 wait4;

// WATCH key [key ...]
watch: watch0;
watch1: WATCH2;
WATCH2: 'watch';
watch3: key;
watch6: key;
watch5: watch6;
watch4: watch5 | watch4 watch5 | ;
watch0: watch1 watch3 watch4;

// XACK key group id [id ...]
xack: xack0;
xack1: XACK2;
XACK2: 'xack';
xack3: key;
xack4: group;
xack5: id;
xack8: id;
xack7: xack8;
xack6: xack7 | xack6 xack7 | ;
xack0: xack1 elem1=xack3 elem2=xack4 xack5 xack6 #XAckRule1;

// XADD key [NOMKSTREAM] [<MAXLEN | MINID> [= | ~] threshold   [LIMIT count]] <* | id> field value [field value ...]
xadd: xadd0;
xadd1: XADD2;
XADD2: 'xadd';
xadd3: elem=key #XAddRule1;
xadd6: XADD7;
XADD7: 'nomkstream';
xadd5: xadd6;
xadd4: xadd5 | ;
xadd13: LPOS17;
xadd14: XADD15;
XADD15: 'minid';
xadd12: xadd13 | xadd14;
xadd11: xadd12;
xadd10: xadd11;
xadd19: XADD20;
XADD20: '=';
xadd21: XADD22;
XADD22: '~';
xadd18: xadd19 | xadd21;
xadd17: xadd18;
xadd16: xadd17 | ;
xadd23: threshold;
xadd26: FT_DOT_SEARCH193;
xadd27: count;
xadd25: xadd26 xadd27;
xadd24: xadd25 | ;
xadd9: xadd10 xadd16 xadd23 xadd24;
xadd8: xadd9 | ;
xadd31: XADD32;
XADD32: '*';
xadd33: id;
xadd30: xadd31 | xadd33;
xadd29: xadd30;
xadd28: xadd29;
xadd34: field;
xadd35: value;
xadd38: field;
xadd39: value;
xadd37: xadd38 xadd39;
xadd36: xadd37 | xadd36 xadd37 | ;
xadd0: xadd1 xadd3 xadd4 xadd8 xadd28 xadd34 xadd35 xadd36;

// XAUTOCLAIM key group consumer min_idle_time xautoclaim_start [COUNT count]   [JUSTID]
xautoclaim: xautoclaim0;
xautoclaim1: XAUTOCLAIM2;
XAUTOCLAIM2: 'xautoclaim';
xautoclaim3: elem=key #XAutoClaimRule1;
xautoclaim4: group;
xautoclaim5: consumer;
xautoclaim6: min_idle_time;
xautoclaim7: xautoclaim_start;
xautoclaim10: BLMPOP17;
xautoclaim11: count;
xautoclaim9: xautoclaim10 xautoclaim11;
xautoclaim8: xautoclaim9 | ;
xautoclaim14: XAUTOCLAIM15;
XAUTOCLAIM15: 'justid';
xautoclaim13: xautoclaim14;
xautoclaim12: xautoclaim13 | ;
xautoclaim0: xautoclaim1 xautoclaim3 xautoclaim4 xautoclaim5 xautoclaim6 xautoclaim7 xautoclaim8 xautoclaim12;

// XCLAIM key group consumer min_idle_time id [id ...] [IDLE ms]   [TIME unix_time_milliseconds] [RETRYCOUNT count] [FORCE] [JUSTID]   [LASTID id]
xclaim: xclaim0;
xclaim1: XCLAIM2;
XCLAIM2: 'xclaim';
xclaim3: elem=key #XClaimRule1;
xclaim4: group;
xclaim5: consumer;
xclaim6: min_idle_time;
xclaim7: id;
xclaim10: id;
xclaim9: xclaim10;
xclaim8: xclaim9 | xclaim8 xclaim9 | ;
xclaim13: XCLAIM14;
XCLAIM14: 'idle';
xclaim15: ms;
xclaim12: xclaim13 xclaim15;
xclaim11: xclaim12 | ;
xclaim18: TIME2;
xclaim19: unix_time_milliseconds;
xclaim17: xclaim18 xclaim19;
xclaim16: xclaim17 | ;
xclaim22: XCLAIM23;
XCLAIM23: 'retrycount';
xclaim24: count;
xclaim21: xclaim22 xclaim24;
xclaim20: xclaim21 | ;
xclaim27: CLUSTER_SP_FAILOVER8;
xclaim26: xclaim27;
xclaim25: xclaim26 | ;
xclaim30: XAUTOCLAIM15;
xclaim29: xclaim30;
xclaim28: xclaim29 | ;
xclaim33: XCLAIM34;
XCLAIM34: 'lastid';
xclaim35: id;
xclaim32: xclaim33 xclaim35;
xclaim31: xclaim32 | ;
xclaim0: xclaim1 xclaim3 xclaim4 xclaim5 xclaim6 xclaim7 xclaim8 xclaim11 xclaim16 xclaim20 xclaim25 xclaim28 xclaim31;

// XDEL key id [id ...]
xdel: xdel0;
xdel1: XDEL2;
XDEL2: 'xdel';
xdel3: elem=key #XDelRule1;
xdel4: id;
xdel7: id;
xdel6: xdel7;
xdel5: xdel6 | xdel5 xdel6 | ;
xdel0: xdel1 xdel3 xdel4 xdel5;

// XGROUP CREATE key groupname <id | $> [MKSTREAM]   [ENTRIESREAD entries_read]
xgroup_sp_create: xgroup_sp_create0;
xgroup_sp_create1: XGROUP_SP_CREATE2;
XGROUP_SP_CREATE2: 'xgroup';
xgroup_sp_create3: XGROUP_SP_CREATE4;
XGROUP_SP_CREATE4: 'create';
xgroup_sp_create5: elem=key #XGroupCreateRule1;
xgroup_sp_create6: elem=groupname #XGroupCreateRule2;
xgroup_sp_create10: id;
xgroup_sp_create11: XGROUP_SP_CREATE12;
XGROUP_SP_CREATE12: '$';
xgroup_sp_create9: xgroup_sp_create10 | xgroup_sp_create11;
xgroup_sp_create8: xgroup_sp_create9;
xgroup_sp_create7: xgroup_sp_create8;
xgroup_sp_create15: XGROUP_SP_CREATE16;
XGROUP_SP_CREATE16: 'mkstream';
xgroup_sp_create14: xgroup_sp_create15;
xgroup_sp_create13: xgroup_sp_create14 | ;
xgroup_sp_create19: XGROUP_SP_CREATE20;
XGROUP_SP_CREATE20: 'entriesread';
xgroup_sp_create21: entries_read;
xgroup_sp_create18: xgroup_sp_create19 xgroup_sp_create21;
xgroup_sp_create17: xgroup_sp_create18 | ;
xgroup_sp_create0: xgroup_sp_create1 xgroup_sp_create3 xgroup_sp_create5 xgroup_sp_create6 xgroup_sp_create7 xgroup_sp_create13 xgroup_sp_create17;

// XGROUP CREATECONSUMER key groupname consumername
xgroup_sp_createconsumer: xgroup_sp_createconsumer0;
xgroup_sp_createconsumer1: XGROUP_SP_CREATE2;
xgroup_sp_createconsumer2: XGROUP_SP_CREATECONSUMER3;
XGROUP_SP_CREATECONSUMER3: 'createconsumer';
xgroup_sp_createconsumer4: key;
xgroup_sp_createconsumer5: groupname;
xgroup_sp_createconsumer6: consumername;
xgroup_sp_createconsumer0: xgroup_sp_createconsumer1 xgroup_sp_createconsumer2 elem1=xgroup_sp_createconsumer4 elem2=xgroup_sp_createconsumer5 elem3=xgroup_sp_createconsumer6 #XGroupCreateconsumerRule1 ;

// XGROUP DELCONSUMER key groupname consumername
xgroup_sp_delconsumer: xgroup_sp_delconsumer0;
xgroup_sp_delconsumer1: XGROUP_SP_CREATE2;
xgroup_sp_delconsumer2: XGROUP_SP_DELCONSUMER3;
XGROUP_SP_DELCONSUMER3: 'delconsumer';
xgroup_sp_delconsumer4: key;
xgroup_sp_delconsumer5: groupname;
xgroup_sp_delconsumer6: consumername;
xgroup_sp_delconsumer0: xgroup_sp_delconsumer1 xgroup_sp_delconsumer2 elem1=xgroup_sp_delconsumer4 elem2=xgroup_sp_delconsumer5 elem3=xgroup_sp_delconsumer6 #XGroupDelconsumerRule1;

// XGROUP DESTROY key groupname
xgroup_sp_destroy: xgroup_sp_destroy0;
xgroup_sp_destroy1: XGROUP_SP_CREATE2;
xgroup_sp_destroy2: XGROUP_SP_DESTROY3;
XGROUP_SP_DESTROY3: 'destroy';
xgroup_sp_destroy4: elem=key #XGroupDestroyRule1;
xgroup_sp_destroy5: elem=groupname #XGroupDestroyRule2;
xgroup_sp_destroy0: xgroup_sp_destroy1 xgroup_sp_destroy2 xgroup_sp_destroy4 xgroup_sp_destroy5;

// XGROUP SETID key groupname <id | $> [ENTRIESREAD entries_read]
xgroup_sp_setid: xgroup_sp_setid0;
xgroup_sp_setid1: XGROUP_SP_CREATE2;
xgroup_sp_setid2: XGROUP_SP_SETID3;
XGROUP_SP_SETID3: 'setid';
xgroup_sp_setid4: key;
xgroup_sp_setid5: groupname;
xgroup_sp_setid9: id;
xgroup_sp_setid10: XGROUP_SP_CREATE12;
xgroup_sp_setid8: xgroup_sp_setid9 | xgroup_sp_setid10;
xgroup_sp_setid7: xgroup_sp_setid8;
xgroup_sp_setid6: xgroup_sp_setid7;
xgroup_sp_setid13: XGROUP_SP_CREATE20;
xgroup_sp_setid14: entries_read;
xgroup_sp_setid12: xgroup_sp_setid13 xgroup_sp_setid14;
xgroup_sp_setid11: xgroup_sp_setid12 | ;
xgroup_sp_setid0: xgroup_sp_setid1 xgroup_sp_setid2 elem1=xgroup_sp_setid4 elem2=xgroup_sp_setid5 xgroup_sp_setid6 xgroup_sp_setid11 #XGroupSetidRule1;

// XINFO CONSUMERS key groupname
xinfo_sp_consumers: xinfo_sp_consumers0;
xinfo_sp_consumers1: XINFO_SP_CONSUMERS2;
XINFO_SP_CONSUMERS2: 'xinfo';
xinfo_sp_consumers3: XINFO_SP_CONSUMERS4;
XINFO_SP_CONSUMERS4: 'consumers';
xinfo_sp_consumers5: key;
xinfo_sp_consumers6: groupname;
xinfo_sp_consumers0: xinfo_sp_consumers1 xinfo_sp_consumers3 elem1=xinfo_sp_consumers5 elem2=xinfo_sp_consumers6 #XInfoConsumersRule1;

// XINFO GROUPS key
xinfo_sp_groups: xinfo_sp_groups0;
xinfo_sp_groups1: XINFO_SP_CONSUMERS2;
xinfo_sp_groups2: XINFO_SP_GROUPS3;
XINFO_SP_GROUPS3: 'groups';
xinfo_sp_groups4: elem=key #XInfoGroupsRule1;
xinfo_sp_groups0: xinfo_sp_groups1 xinfo_sp_groups2 xinfo_sp_groups4;

// XINFO STREAM key [FULL [COUNT count]]
xinfo_sp_stream: xinfo_sp_stream0;
xinfo_sp_stream1: XINFO_SP_CONSUMERS2;
xinfo_sp_stream2: XINFO_SP_STREAM3;
XINFO_SP_STREAM3: 'stream';
xinfo_sp_stream4: elem=key #XInfoStreamRule1;
xinfo_sp_stream7: XINFO_SP_STREAM8;
XINFO_SP_STREAM8: 'full';
xinfo_sp_stream11: BLMPOP17;
xinfo_sp_stream12: count;
xinfo_sp_stream10: xinfo_sp_stream11 xinfo_sp_stream12;
xinfo_sp_stream9: xinfo_sp_stream10 | ;
xinfo_sp_stream6: xinfo_sp_stream7 xinfo_sp_stream9;
xinfo_sp_stream5: xinfo_sp_stream6 | ;
xinfo_sp_stream0: xinfo_sp_stream1 xinfo_sp_stream2 xinfo_sp_stream4 xinfo_sp_stream5;

// XLEN key
xlen: xlen0;
xlen1: XLEN2;
XLEN2: 'xlen';
xlen3: elem=key #XLenRule1;
xlen0: xlen1 xlen3;

// XPENDING key group [[IDLE min_idle_time] start end count [consumer]]
xpending: xpending0;
xpending1: XPENDING2;
XPENDING2: 'xpending';
xpending3: key;
xpending4: group;
xpending9: XCLAIM14;
xpending10: min_idle_time;
xpending8: xpending9 xpending10;
xpending7: xpending8 | ;
xpending11: xrange_start;
xpending12: xrange_end;
xpending13: count;
xpending16: consumer;
xpending15: xpending16;
xpending14: xpending15 | ;
xpending6: xpending7 xpending11 xpending12 xpending13 xpending14;
xpending5: xpending6 | ;
xpending0: xpending1 elem1=xpending3 elem2=xpending4 xpending5 #XPendingRule1;

// XRANGE key start end [COUNT count]
xrange: xrange0;
xrange1: XRANGE2;
XRANGE2: 'xrange';
xrange3: elem=key #XRangeRule1;
xrange4: xrange_start;
xrange5: xrange_end;
xrange8: BLMPOP17;
xrange9: count;
xrange7: xrange8 xrange9;
xrange6: xrange7 | ;
xrange0: xrange1 xrange3 xrange4 xrange5 xrange6;

xrange_start: start | PLUS | MINUS;
xrange_end: end | PLUS | MINUS;

// XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] id   [id ...]
xread: xread0;
xread1: XREAD2;
XREAD2: 'xread';
xread5: BLMPOP17;
xread6: count;
xread4: xread5 xread6;
xread3: xread4 | ;
xread9: XREAD10;
XREAD10: 'block';
xread11: milliseconds;
xread8: xread9 xread11;
xread7: xread8 | ;
xread12: XREAD13;
XREAD13: 'streams';
xread14: elem=key #XReadRule1;
xread17: elem=key #XReadRule2;
xread16: xread17;
xread15: xread16 | xread15 xread16 | ;
xread18: id;
xread21: id;
xread20: xread21;
xread19: xread20 | xread19 xread20 | ;
xread0: xread1 xread3 xread7 xread12 xread14 xread15 xread18 xread19;

// XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds]   [NOACK] STREAMS key [key ...] id [id ...]
xreadgroup: xreadgroup0;
xreadgroup1: XREADGROUP2;
XREADGROUP2: 'xreadgroup';
xreadgroup3: XREADGROUP4;
XREADGROUP4: 'group';
xreadgroup5: group;
xreadgroup6: consumer;
xreadgroup9: BLMPOP17;
xreadgroup10: count;
xreadgroup8: xreadgroup9 xreadgroup10;
xreadgroup7: xreadgroup8 | ;
xreadgroup13: XREAD10;
xreadgroup14: milliseconds;
xreadgroup12: xreadgroup13 xreadgroup14;
xreadgroup11: xreadgroup12 | ;
xreadgroup17: XREADGROUP18;
XREADGROUP18: 'noack';
xreadgroup16: xreadgroup17;
xreadgroup15: xreadgroup16 | ;
xreadgroup19: XREAD13;
xreadgroup20: elem=key #XReadGroupRule1;
xreadgroup23: elem=key #XReadGroupRule2;
xreadgroup22: xreadgroup23;
xreadgroup21: xreadgroup22 | xreadgroup21 xreadgroup22 | ;
xreadgroup24: id;
xreadgroup27: id;
xreadgroup26: xreadgroup27;
xreadgroup25: xreadgroup26 | xreadgroup25 xreadgroup26 | ;
xreadgroup0: xreadgroup1 xreadgroup3 xreadgroup5 xreadgroup6 xreadgroup7 xreadgroup11 xreadgroup15 xreadgroup19 xreadgroup20 xreadgroup21 xreadgroup24 xreadgroup25;

// XREVRANGE key end start [COUNT count]
xrevrange: xrevrange0;
xrevrange1: XREVRANGE2;
XREVRANGE2: 'xrevrange';
xrevrange3: elem=key #XRevRangeRule1;
xrevrange4: xrange_end;
xrevrange5: xrange_start;
xrevrange8: BLMPOP17;
xrevrange9: count;
xrevrange7: xrevrange8 xrevrange9;
xrevrange6: xrevrange7 | ;
xrevrange0: xrevrange1 xrevrange3 xrevrange4 xrevrange5 xrevrange6;

// XSETID key last_id [ENTRIESADDED entries_added]   [MAXDELETEDID max_deleted_entry_id]
// xsetid: xsetid0;
// todo: {'last_id', 'entries_added', 'max_deleted_entry_id'}
/*
xsetid1: XSETID2;
XSETID2: 'xsetid';
xsetid3: key;
xsetid4: xsetid5;
xsetid5: 'last_id.TODO';
xsetid8: XSETID9;
XSETID9: 'entriesadded';
xsetid10: xsetid11;
xsetid11: 'entries_added.TODO';
xsetid7: xsetid8 xsetid10;
xsetid6: xsetid7 | ;
xsetid14: XSETID15;
XSETID15: 'maxdeletedid';
xsetid16: xsetid17;
xsetid17: 'max_deleted_entry_id.TODO';
xsetid13: xsetid14 xsetid16;
xsetid12: xsetid13 | ;
xsetid0: xsetid1 xsetid3 xsetid4 xsetid6 xsetid12;

*/
// XTRIM key <MAXLEN | MINID> [= | ~] threshold [LIMIT count]
xtrim: xtrim0;
xtrim1: XTRIM2;
XTRIM2: 'xtrim';
xtrim3: elem=key #XTrimRule1;
xtrim7: LPOS17;
xtrim8: XADD15;
xtrim6: xtrim7 | xtrim8;
xtrim5: xtrim6;
xtrim4: xtrim5;
xtrim12: XADD20;
xtrim13: XADD22;
xtrim11: xtrim12 | xtrim13;
xtrim10: xtrim11;
xtrim9: xtrim10 | ;
xtrim14: threshold;
xtrim17: FT_DOT_SEARCH193;
xtrim18: count;
xtrim16: xtrim17 xtrim18;
xtrim15: xtrim16 | ;
xtrim0: xtrim1 xtrim3 xtrim4 xtrim9 xtrim14 xtrim15;

// ZADD key [NX | XX] [GT | LT] [CH] [INCR] score member [score member ...]
zadd: zadd0;
zadd1: ZADD2;
ZADD2: 'zadd';
zadd3: key;
zadd7: EXPIRE11;
zadd8: EXPIRE13;
zadd6: zadd7 | zadd8;
zadd5: zadd6;
zadd4: zadd5 | ;
zadd12: EXPIRE15;
zadd13: EXPIRE17;
zadd11: zadd12 | zadd13;
zadd10: zadd11;
zadd9: zadd10 | ;
zadd16: GEOADD12;
zadd15: zadd16;
zadd14: zadd15 | ;
zadd19: FT_DOT_SUGADD9;
zadd18: zadd19;
zadd17: zadd18 | ;
zadd20: score;
zadd21: elem=member #ZAddRule2;
zadd24: score;
zadd25: elem=member #ZAddRule3;
zadd23: zadd24 zadd25;
zadd22: zadd23 | zadd22 zadd23 | ;
zadd0: zadd1 elem=zadd3 zadd4 zadd9 zadd14 zadd17 zadd20 zadd21 zadd22 #ZAddRule;

// ZCARD key
zcard: zcard0;
zcard1: ZCARD2;
ZCARD2: 'zcard';
zcard3: key;
zcard0: zcard1 elem=zcard3 #ZCardRule;

// ZCOUNT key min max
zcount: zcount0;
zcount1: ZCOUNT2;
ZCOUNT2: 'zcount';
zcount3: key;
zcount4: min;
zcount5: max;
zcount0: zcount1 elem=zcount3 zcount4 zcount5 #ZCountRule;

// ZDIFF numkeys key [key ...] [WITHSCORES]
zdiff: zdiff0;
zdiff1: ZDIFF2;
ZDIFF2: 'zdiff';
zdiff3: numkeys;
zdiff4: elem=key #ZDiffRule1;
zdiff7: elem=key #ZDiffRule2;
zdiff6: zdiff7;
zdiff5: zdiff6 | zdiff5 zdiff6 | ;
zdiff10: FT_DOT_SEARCH20;
zdiff9: zdiff10;
zdiff8: zdiff9 | ;
zdiff0: zdiff1 zdiff3 zdiff4 zdiff5 zdiff8;

// ZDIFFSTORE destination numkeys key [key ...]
zdiffstore: zdiffstore0;
zdiffstore1: ZDIFFSTORE2;
ZDIFFSTORE2: 'zdiffstore';
zdiffstore3: dest=destination #ZStoreRule1;
zdiffstore4: numkeys;
zdiffstore5: elem=key #ZStoreRule2;
zdiffstore8: elem=key #ZStoreRule3;
zdiffstore7: zdiffstore8;
zdiffstore6: zdiffstore7 | zdiffstore6 zdiffstore7 | ;
zdiffstore0: zdiffstore1 zdiffstore3 zdiffstore4 zdiffstore5 zdiffstore6;

// ZINCRBY key increment member
zincrby: zincrby0;
zincrby1: ZINCRBY2;
ZINCRBY2: 'zincrby';
zincrby3: elem=key #ZIncrBy;
zincrby4: increment;
zincrby5: member;
zincrby0: zincrby1 zincrby3 zincrby4 zincrby5;

// ZINTER numkeys key [key ...] [WEIGHTS weight [weight ...]]   [AGGREGATE <SUM | MIN | MAX>] [WITHSCORES]
zinter: zinter0;
zinter1: ZINTER2;
ZINTER2: 'zinter';
zinter3: numkeys;
zinter4: elem=key #ZInter1;
zinter7: elem=key #ZInter2;
zinter6: zinter7;
zinter5: zinter6 | zinter5 zinter6 | ;
zinter10: ZINTER11;
ZINTER11: 'weights';
zinter12: weight;
zinter15: weight;
zinter14: zinter15;
zinter13: zinter14 | zinter13 zinter14 | ;
zinter9: zinter10 zinter12 zinter13;
zinter8: zinter9 | ;
zinter18: FT_DOT_PROFILE8;
zinter23: ZINTER24;
ZINTER24: 'sum';
zinter25: BZMPOP13;
zinter22: zinter23 | zinter25;
zinter26: BZMPOP15;
zinter21: zinter22 | zinter26;
zinter20: zinter21;
zinter19: zinter20;
zinter17: zinter18 zinter19;
zinter16: zinter17 | ;
zinter29: FT_DOT_SEARCH20;
zinter28: zinter29;
zinter27: zinter28 | ;
zinter0: zinter1 zinter3 zinter4 zinter5 zinter8 zinter16 zinter27;

// ZINTERCARD numkeys key [key ...] [LIMIT limit]
zintercard: zintercard0;
zintercard1: ZINTERCARD2;
ZINTERCARD2: 'zintercard';
zintercard3: numkeys;
zintercard4: elem=key #ZInterCard1;
zintercard7: elem=key #ZInterCard2;
zintercard6: zintercard7;
zintercard5: zintercard6 | zintercard5 zintercard6 | ;
zintercard10: FT_DOT_SEARCH193;
zintercard11: limit;
zintercard9: zintercard10 zintercard11;
zintercard8: zintercard9 | ;
zintercard0: zintercard1 zintercard3 zintercard4 zintercard5 zintercard8;

// ZINTERSTORE destination numkeys key [key ...] [WEIGHTS weight   [weight ...]] [AGGREGATE <SUM | MIN | MAX>]
zinterstore: zinterstore0;
zinterstore1: ZINTERSTORE2;
ZINTERSTORE2: 'zinterstore';
zinterstore3: dest=destination #ZInterStore3;
zinterstore4: numkeys;
zinterstore5: elem=key #ZInterStore1;
zinterstore8: elem=key #ZInterStore2;
zinterstore7: zinterstore8;
zinterstore6: zinterstore7 | zinterstore6 zinterstore7 | ;
zinterstore11: ZINTER11;
zinterstore12: weight;
zinterstore15: weight;
zinterstore14: zinterstore15;
zinterstore13: zinterstore14 | zinterstore13 zinterstore14 | ;
zinterstore10: zinterstore11 zinterstore12 zinterstore13;
zinterstore9: zinterstore10 | ;
zinterstore18: FT_DOT_PROFILE8;
zinterstore23: ZINTER24;
zinterstore24: BZMPOP13;
zinterstore22: zinterstore23 | zinterstore24;
zinterstore25: BZMPOP15;
zinterstore21: zinterstore22 | zinterstore25;
zinterstore20: zinterstore21;
zinterstore19: zinterstore20;
zinterstore17: zinterstore18 zinterstore19;
zinterstore16: zinterstore17 | ;
zinterstore0: zinterstore1 zinterstore3 zinterstore4 zinterstore5 zinterstore6 zinterstore9 zinterstore16;

// ZLEXCOUNT key min max
zlexcount: zlexcount0;
zlexcount1: ZLEXCOUNT2;
ZLEXCOUNT2: 'zlexcount';
zlexcount3: elem=key #ZLexCount;
zlexcount4: zlexcount_minmax;
zlexcount5: zlexcount_minmax;
zlexcount0: zlexcount1 zlexcount3 zlexcount4 zlexcount5;

zlexcount_minmax: ('[' | '(') IDENT | '+' | '-' | INTEGER;

// ZMPOP numkeys key [key ...] <MIN | MAX> [COUNT count]
zmpop: zmpop0;
zmpop1: ZMPOP2;
ZMPOP2: 'zmpop';
zmpop3: numkeys;
zmpop4: elem=key #ZMPop1;
zmpop7: elem=key #ZMPop2;
zmpop6: zmpop7;
zmpop5: zmpop6 | zmpop5 zmpop6 | ;
zmpop11: BZMPOP13;
zmpop12: BZMPOP15;
zmpop10: zmpop11 | zmpop12;
zmpop9: zmpop10;
zmpop8: zmpop9;
zmpop15: BLMPOP17;
zmpop16: count;
zmpop14: zmpop15 zmpop16;
zmpop13: zmpop14 | ;
zmpop0: zmpop1 zmpop3 zmpop4 zmpop5 zmpop8 zmpop13;

// ZMSCORE key member [member ...]
zmscore: zmscore0;
zmscore1: ZMSCORE2;
ZMSCORE2: 'zmscore';
zmscore3: elem=key #ZMScore;
zmscore4: member;
zmscore7: member;
zmscore6: zmscore7;
zmscore5: zmscore6 | zmscore5 zmscore6 | ;
zmscore0: zmscore1 zmscore3 zmscore4 zmscore5;

// ZPOPMAX key [count]
zpopmax: zpopmax0;
zpopmax1: ZPOPMAX2;
ZPOPMAX2: 'zpopmax';
zpopmax3: elem=key #ZPopMax;
zpopmax6: count;
zpopmax5: zpopmax6;
zpopmax4: zpopmax5 | ;
zpopmax0: zpopmax1 zpopmax3 zpopmax4;

// ZPOPMIN key [count]
zpopmin: zpopmin0;
zpopmin1: ZPOPMIN2;
ZPOPMIN2: 'zpopmin';
zpopmin3: elem=key #ZPopMin;
zpopmin6: count;
zpopmin5: zpopmin6;
zpopmin4: zpopmin5 | ;
zpopmin0: zpopmin1 zpopmin3 zpopmin4;

// ZRANDMEMBER key [count [WITHSCORES]]
zrandmember: zrandmember0;
zrandmember1: ZRANDMEMBER2;
ZRANDMEMBER2: 'zrandmember';
zrandmember3: elem=key #ZRandMember;
zrandmember6: count;
zrandmember9: FT_DOT_SEARCH20;
zrandmember8: zrandmember9;
zrandmember7: zrandmember8 | ;
zrandmember5: zrandmember6 zrandmember7;
zrandmember4: zrandmember5 | ;
zrandmember0: zrandmember1 zrandmember3 zrandmember4;

zrange_start_stop: ('(' | '[' | ) INTEGER | '+' | '-';

// ZRANGE key start stop [BYSCORE | BYLEX] [REV] [LIMIT offset count]   [WITHSCORES]
zrange: zrange0;
zrange1: ZRANGE2;
ZRANGE2: 'zrange';
zrange3: elem=key #ZRange;
zrange4: zrange_start_stop;
zrange5: zrange_start_stop;
zrange9: ZRANGE10;
ZRANGE10: 'byscore';
zrange11: ZRANGE12;
ZRANGE12: 'bylex';
zrange8: zrange9 | zrange11;
zrange7: zrange8;
zrange6: zrange7 | ;
zrange15: ZRANGE16;
ZRANGE16: 'rev';
zrange14: zrange15;
zrange13: zrange14 | ;
zrange19: FT_DOT_SEARCH193;
zrange20: offset;
zrange21: count;
zrange18: zrange19 zrange20 zrange21;
zrange17: zrange18 | ;
zrange24: FT_DOT_SEARCH20;
zrange23: zrange24;
zrange22: zrange23 | ;
zrange0: zrange1 zrange3 zrange4 zrange5 zrange6 zrange13 zrange17 zrange22;

// ZRANGEBYLEX key min max [LIMIT offset count]
zrangebylex: zrangebylex0;
zrangebylex1: ZRANGEBYLEX2;
ZRANGEBYLEX2: 'zrangebylex';
zrangebylex3: elem=key #ZRangeByLex;
zrangebylex4: zlexcount_minmax;
zrangebylex5: zlexcount_minmax;
zrangebylex8: FT_DOT_SEARCH193;
zrangebylex9: offset;
zrangebylex10: count;
zrangebylex7: zrangebylex8 zrangebylex9 zrangebylex10;
zrangebylex6: zrangebylex7 | ;
zrangebylex0: zrangebylex1 zrangebylex3 zrangebylex4 zrangebylex5 zrangebylex6;

// ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
zrangebyscore: zrangebyscore0;
zrangebyscore1: ZRANGEBYSCORE2;
ZRANGEBYSCORE2: 'zrangebyscore';
zrangebyscore3: elem=key #ZRangeByScore;
zrangebyscore4: min;
zrangebyscore5: max;
zrangebyscore8: FT_DOT_SEARCH20;
zrangebyscore7: zrangebyscore8;
zrangebyscore6: zrangebyscore7 | ;
zrangebyscore11: FT_DOT_SEARCH193;
zrangebyscore12: offset;
zrangebyscore13: count;
zrangebyscore10: zrangebyscore11 zrangebyscore12 zrangebyscore13;
zrangebyscore9: zrangebyscore10 | ;
zrangebyscore0: zrangebyscore1 zrangebyscore3 zrangebyscore4 zrangebyscore5 zrangebyscore6 zrangebyscore9;

// ZRANGESTORE dst src min max [BYSCORE | BYLEX] [REV] [LIMIT offset   count]
zrangestore: zrangestore0;
zrangestore1: ZRANGESTORE2;
ZRANGESTORE2: 'zrangestore';
zrangestore3: dest=dst #ZRangeStore1;
zrangestore4: elem=src #ZRangeStore2;
zrangestore5: min;
zrangestore6: max;
zrangestore10: ZRANGE10;
zrangestore11: ZRANGE12;
zrangestore9: zrangestore10 | zrangestore11;
zrangestore8: zrangestore9;
zrangestore7: zrangestore8 | ;
zrangestore14: ZRANGE16;
zrangestore13: zrangestore14;
zrangestore12: zrangestore13 | ;
zrangestore17: FT_DOT_SEARCH193;
zrangestore18: offset;
zrangestore19: count;
zrangestore16: zrangestore17 zrangestore18 zrangestore19;
zrangestore15: zrangestore16 | ;
zrangestore0: zrangestore1 zrangestore3 zrangestore4 zrangestore5 zrangestore6 zrangestore7 zrangestore12 zrangestore15;

// ZRANK key member
zrank: zrank0;
zrank1: ZRANK2;
ZRANK2: 'zrank';
zrank3: elem=key #ZRankRule;
zrank4: member;
zrank0: zrank1 zrank3 zrank4;

// ZREM key member [member ...]
zrem: zrem0;
zrem1: ZREM2;
ZREM2: 'zrem';
zrem3: elem=key #ZRemRule;
zrem4: member;
zrem7: member;
zrem6: zrem7;
zrem5: zrem6 | zrem5 zrem6 | ;
zrem0: zrem1 zrem3 zrem4 zrem5;

// ZREMRANGEBYLEX key min max
zremrangebylex: zremrangebylex0;
zremrangebylex1: ZREMRANGEBYLEX2;
ZREMRANGEBYLEX2: 'zremrangebylex';
zremrangebylex3: elem=key #ZRemRangeByLex;
zremrangebylex4: min;
zremrangebylex5: max;
zremrangebylex0: zremrangebylex1 zremrangebylex3 zremrangebylex4 zremrangebylex5;

// ZREMRANGEBYRANK key start stop
zremrangebyrank: zremrangebyrank0;
zremrangebyrank1: ZREMRANGEBYRANK2;
ZREMRANGEBYRANK2: 'zremrangebyrank';
zremrangebyrank3: elem=key #ZRemRangeByRank;
zremrangebyrank4: start;
zremrangebyrank5: stop;
zremrangebyrank0: zremrangebyrank1 zremrangebyrank3 zremrangebyrank4 zremrangebyrank5;

// ZREMRANGEBYSCORE key min max
zremrangebyscore: zremrangebyscore0;
zremrangebyscore1: ZREMRANGEBYSCORE2;
ZREMRANGEBYSCORE2: 'zremrangebyscore';
zremrangebyscore3: elem=key #ZRemRangeByScore;
zremrangebyscore4: min;
zremrangebyscore5: max;
zremrangebyscore0: zremrangebyscore1 zremrangebyscore3 zremrangebyscore4 zremrangebyscore5;

// ZREVRANGE key start stop [WITHSCORES]
zrevrange: zrevrange0;
zrevrange1: ZREVRANGE2;
ZREVRANGE2: 'zrevrange';
zrevrange3: elem=key #ZRevRange;
zrevrange4: start;
zrevrange5: stop;
zrevrange8: FT_DOT_SEARCH20;
zrevrange7: zrevrange8;
zrevrange6: zrevrange7 | ;
zrevrange0: zrevrange1 zrevrange3 zrevrange4 zrevrange5 zrevrange6;

// ZREVRANGEBYLEX key max min [LIMIT offset count]
zrevrangebylex: zrevrangebylex0;
zrevrangebylex1: ZREVRANGEBYLEX2;
ZREVRANGEBYLEX2: 'zrevrangebylex';
zrevrangebylex3: elem=key #ZRevRangeByLex;
zrevrangebylex4: max;
zrevrangebylex5: min;
zrevrangebylex8: FT_DOT_SEARCH193;
zrevrangebylex9: offset;
zrevrangebylex10: count;
zrevrangebylex7: zrevrangebylex8 zrevrangebylex9 zrevrangebylex10;
zrevrangebylex6: zrevrangebylex7 | ;
zrevrangebylex0: zrevrangebylex1 zrevrangebylex3 zrevrangebylex4 zrevrangebylex5 zrevrangebylex6;

// ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count]
zrevrangebyscore: zrevrangebyscore0;
zrevrangebyscore1: ZREVRANGEBYSCORE2;
ZREVRANGEBYSCORE2: 'zrevrangebyscore';
zrevrangebyscore3: elem=key #ZRevRangeByScore;
zrevrangebyscore4: max;
zrevrangebyscore5: min;
zrevrangebyscore8: FT_DOT_SEARCH20;
zrevrangebyscore7: zrevrangebyscore8;
zrevrangebyscore6: zrevrangebyscore7 | ;
zrevrangebyscore11: FT_DOT_SEARCH193;
zrevrangebyscore12: offset;
zrevrangebyscore13: count;
zrevrangebyscore10: zrevrangebyscore11 zrevrangebyscore12 zrevrangebyscore13;
zrevrangebyscore9: zrevrangebyscore10 | ;
zrevrangebyscore0: zrevrangebyscore1 zrevrangebyscore3 zrevrangebyscore4 zrevrangebyscore5 zrevrangebyscore6 zrevrangebyscore9;

// ZREVRANK key member
zrevrank: zrevrank0;
zrevrank1: ZREVRANK2;
ZREVRANK2: 'zrevrank';
zrevrank3: key;
zrevrank4: member;
zrevrank0: zrevrank1 elemkey=zrevrank3 elemmember=zrevrank4 #ZRevRank;

// ZSCAN key cursor [MATCH pattern] [COUNT count]
zscan: zscan0;
zscan1: ZSCAN2;
ZSCAN2: 'zscan';
zscan3: elem=key #ZScanRule;
zscan4: cursor;
zscan7: HSCAN8;
zscan8: pattern;
zscan6: zscan7 zscan8;
zscan5: zscan6 | ;
zscan11: BLMPOP17;
zscan12: count;
zscan10: zscan11 zscan12;
zscan9: zscan10 | ;
zscan0: zscan1 zscan3 zscan4 zscan5 zscan9;

// ZSCORE key member
zscore: zscore0;
zscore1: ZSCORE2;
ZSCORE2: 'zscore';
zscore3: elem=key #ZScoreRule;
zscore4: member;
zscore0: zscore1 zscore3 zscore4;

// ZUNION numkeys key [key ...] [WEIGHTS weight [weight ...]]   [AGGREGATE <SUM | MIN | MAX>] [WITHSCORES]
zunion: zunion0;
zunion1: ZUNION2;
ZUNION2: 'zunion';
zunion3: numkeys;
zunion4: elem=key #ZUnionRule1;
zunion7: elem=key #ZUnionRule2;
zunion6: zunion7;
zunion5: zunion6 | zunion5 zunion6 | ;
zunion10: ZINTER11;
zunion11: weight;
zunion14: weight;
zunion13: zunion14;
zunion12: zunion13 | zunion12 zunion13 | ;
zunion9: zunion10 zunion11 zunion12;
zunion8: zunion9 | ;
zunion17: FT_DOT_PROFILE8;
zunion22: ZINTER24;
zunion23: BZMPOP13;
zunion21: zunion22 | zunion23;
zunion24: BZMPOP15;
zunion20: zunion21 | zunion24;
zunion19: zunion20;
zunion18: zunion19;
zunion16: zunion17 zunion18;
zunion15: zunion16 | ;
zunion27: FT_DOT_SEARCH20;
zunion26: zunion27;
zunion25: zunion26 | ;
zunion0: zunion1 zunion3 zunion4 zunion5 zunion8 zunion15 zunion25;

// ZUNIONSTORE destination numkeys key [key ...] [WEIGHTS weight   [weight ...]] [AGGREGATE <SUM | MIN | MAX>]
zunionstore: zunionstore0;
zunionstore1: ZUNIONSTORE2;
ZUNIONSTORE2: 'zunionstore';
zunionstore3: dest=destination #ZUnionStoreRule1;
zunionstore4: numkeys;
zunionstore5: elem=key #ZUnionStoreRule2;
zunionstore8: elem=key #ZUnionStoreRule3;
zunionstore7: zunionstore8;
zunionstore6: zunionstore7 | zunionstore6 zunionstore7 | ;
zunionstore11: ZINTER11;
zunionstore12: weight;
zunionstore15: weight;
zunionstore14: zunionstore15;
zunionstore13: zunionstore14 | zunionstore13 zunionstore14 | ;
zunionstore10: zunionstore11 zunionstore12 zunionstore13;
zunionstore9: zunionstore10 | ;
zunionstore18: FT_DOT_PROFILE8;
zunionstore23: ZINTER24;
zunionstore24: BZMPOP13;
zunionstore22: zunionstore23 | zunionstore24;
zunionstore25: BZMPOP15;
zunionstore21: zunionstore22 | zunionstore25;
zunionstore20: zunionstore21;
zunionstore19: zunionstore20;
zunionstore17: zunionstore18 zunionstore19;
zunionstore16: zunionstore17 | ;
zunionstore0: zunionstore1 zunionstore3 zunionstore4 zunionstore5 zunionstore6 zunionstore9 zunionstore16;

prog: acl_sp_cat
| acl_sp_deluser
| acl_sp_dryrun
| acl_sp_genpass
| acl_sp_getuser
| acl_sp_list
| acl_sp_load
| acl_sp_log
| acl_sp_save
| acl_sp_users
| acl_sp_whoami
| append
| asking
| auth
| bf_dot_add
| bf_dot_exists
| bf_dot_info
| bf_dot_madd
| bf_dot_mexists
| bgrewriteaof
| bgsave
| bitcount
| bitfield
| bitfield_ro
| bitop
| bitpos
| blmove
| blmpop
| blpop
| brpop
| brpoplpush
| bzmpop
| bzpopmax
| bzpopmin
| cf_dot_add
| cf_dot_addnx
| cf_dot_count
| cf_dot_del
| cf_dot_exists
| cf_dot_info
| cf_dot_insert
| cf_dot_insertnx
| cf_dot_mexists
| client_sp_caching
| client_sp_getname
| client_sp_getredir
| client_sp_id
| client_sp_info
| client_sp_no_evict
| client_sp_pause
| client_sp_reply
| client_sp_trackinginfo
| client_sp_unpause
| cluster_sp_bumpepoch
| cluster_sp_failover
| cluster_sp_flushslots
| cluster_sp_info
| cluster_sp_keyslot
| cluster_sp_links
| cluster_sp_myid
| cluster_sp_nodes
| cluster_sp_reset
| cluster_sp_saveconfig
| cluster_sp_shards
| cluster_sp_slots
| cms_dot_incrby
| cms_dot_info
| cms_dot_initbydim
| cms_dot_query
| command
| command_sp_count
| command_sp_docs
| command_sp_getkeys
| command_sp_getkeysandflags
| command_sp_info
| command_sp_list
| config_sp_resetstat
| config_sp_rewrite
| copy
| dbsize
| decr
| decrby
| cmd_del
| discard
| dump
| echo
| exec
| exists
| expire
| expireat
| expiretime
| flushall
| flushdb
| ft_dot__list
| ft_dot_aliasadd
| ft_dot_aliasdel
| ft_dot_aliasupdate
| ft_dot_config_sp_get
| ft_dot_config_sp_set
| ft_dot_dropindex
| ft_dot_explain
| ft_dot_explaincli
| ft_dot_info
| ft_dot_profile
| ft_dot_search
| ft_dot_sugadd
| ft_dot_sugdel
| ft_dot_suglen
| ft_dot_syndump
| function_sp_dump
| function_sp_flush
| function_sp_kill
| function_sp_restore
| function_sp_stats
| geoadd
| geodist
| geohash
| geopos
| georadius
| georadius_ro
| georadiusbymember
| georadiusbymember_ro
| geosearch
| geosearchstore
| get
| getbit
| getdel
| getex
| getrange
| getset
| graph_dot_config_sp_get
| graph_dot_config_sp_set
| graph_dot_list
| hdel
| hexists
| hget
| hgetall
| hincrby
| hincrbyfloat
| hkeys
| hlen
| hmget
| hmset
| hrandfield
| hscan
| hset
| hsetnx
| hstrlen
| hvals
| incr
| incrby
| incrbyfloat
| info
| json_dot_debug
| keys
| lastsave
| latency_sp_doctor
| latency_sp_latest
| lcs
| lindex
| linsert
| llen
| lmove
| lmpop
| lpop
| lpos
| lpush
| lpushx
| lrange
| lrem
| lset
| ltrim
| memory_sp_doctor
| memory_sp_malloc_stats
| memory_sp_purge
| memory_sp_stats
| memory_sp_usage
| mget
| module_sp_list
| module_sp_unload
| monitor
| mset
| msetnx
| multi
| object_sp_encoding
| object_sp_freq
| object_sp_idletime
| object_sp_refcount
| persist
| pexpire
| pexpireat
| pexpiretime
| pfadd
| pfcount
| pfmerge
| pfselftest
| ping
| psetex
| psubscribe
| psync
| pttl
| publish
| pubsub_sp_channels
| pubsub_sp_numpat
| pubsub_sp_numsub
| pubsub_sp_shardchannels
| pubsub_sp_shardnumsub
| punsubscribe
| quit
| randomkey
| readonly
| readwrite
| rename
| renamenx
| replconf
| reset_cmd
| restore
| restore_asking
| role
| rpop
| rpoplpush
| rpush
| rpushx
| sadd
| save
| scan
| scard
| script_sp_debug
| script_sp_flush
| script_sp_kill
| sdiff
| sdiffstore
| select
| set
| setbit
| setex
| setnx
| setrange
| shutdown
| sinter
| sintercard
| sinterstore
| sismember
| slowlog_sp_get
| slowlog_sp_len
| slowlog_sp_reset
| smembers
| smismember
| smove
| sort
| sort_ro
| spop
| spublish
| srandmember
| srem
| sscan
| ssubscribe
| strlen
| subscribe
| substr
| sunion
| sunionstore
| sunsubscribe
| swapdb
| sync
| tdigest_dot_add
| tdigest_dot_byrank
| tdigest_dot_cdf
| tdigest_dot_info
| tdigest_dot_max
| tdigest_dot_min
| tdigest_dot_rank
| tdigest_dot_reset
| tdigest_dot_revrank
| time
| topk_dot_count
| topk_dot_incrby
| topk_dot_info
| topk_dot_list
| topk_dot_query
| touch
| ts_dot_get
| ts_dot_info
| ts_dot_madd
| ttl
| type
| unlink
| unsubscribe
| unwatch
| wait
| watch
| xack
| xadd
| xautoclaim
| xclaim
| xdel
| xgroup_sp_create
| xgroup_sp_createconsumer
| xgroup_sp_delconsumer
| xgroup_sp_destroy
| xgroup_sp_setid
| xinfo_sp_consumers
| xinfo_sp_groups
| xinfo_sp_stream
| xlen
| xpending
| xrange
| xread
| xreadgroup
| xrevrange
| xtrim
| zadd
| zcard
| zcount
| zdiff
| zdiffstore
| zincrby
| zinter
| zintercard
| zinterstore
| zlexcount
| zmpop
| zmscore
| zpopmax
| zpopmin
| zrandmember
| zrange
| zrangebylex
| zrangebyscore
| zrangestore
| zrank
| zrem
| zremrangebylex
| zremrangebyrank
| zremrangebyscore
| zrevrange
| zrevrangebylex
| zrevrangebyscore
| zrevrank
| zscan
| zscore
| zunion
| zunionstore
;

value: IDENT | INTEGER | FLOAT | StringLiteral;
timestamp: IDENT;
key: IDENT;
newkey: IDENT;
ttl_arg: INTEGER;
serialized_value: StringLiteral;
frequency: INTEGER;
categoryname: IDENT;
username: IDENT;
scan_type: SCAN_TYPE;
SCAN_TYPE: 'string' | ACL_SP_LIST3 | BITFIELD33 | 'zset' | 'hash' | XINFO_SP_STREAM3;
command_arg: prog;
index1: index;
index2: index;
consumer: IDENT;
xautoclaim_start: id;
ms: INTEGER;
entries_read: INTEGER;
min_idle_time: INTEGER;
numreplicas: INTEGER;
threshold: INTEGER;
group: IDENT;
bits: INTEGER;
count: INTEGER;
item: IDENT;
capacity: INTEGER;
start: INTEGER;
end: INTEGER;
error_rate: FLOAT;
encoding: ENCODING;
offset: PREFIXED_INTEGER | INTEGER;
increment: INTEGER | FLOAT;
bit: INTEGER;
timeout: INTEGER;
numkeys: INTEGER;
bucketsize: INTEGER;
maxiterations: INTEGER;
num: INTEGER | FLOAT;
label: IDENT;
name: IDENT;
longitude: num;
latitude: num;

pivot: member;
element: member;
rank: INTEGER;
num_matches: INTEGER;
stop: INTEGER;
channel: IDENT;
shardchannel: IDENT;

member: StringLiteral | IDENT | INTEGER;
min: INTEGER | PLUS | MINUS;
max: INTEGER | MINUS | PLUS;
lon: FLOAT;
lat: FLOAT;
sourcekey: IDENT;
destKey: IDENT;
open: 'open';
close: 'close';
nargs: INTEGER;
dialect: INTEGER;
sortby: IDENT;
payload: IDENT | StringLiteral;
language: 'Arabic' | 'Basque' | 'Catalan' | 'Danish' | 'Dutch' | 'English' | 'Finnish' | 'French' | 'German' | 'Greek' | 'Hungarian' | 'Indonesian' | 'Irish' | 'Italian' | 'Lithuanian' | 'Nepali' | 'Norwegian' | 'Portuguese' | 'Romanian' | 'Russian' | 'Spanish' | 'Swedish' | 'Tamil' | 'Turkish' | 'Chinese';
query: StringLiteral | '*';
index: IDENT | INTEGER;
numeric_field: IDENT;
geo_field: IDENT;
radius: INTEGER;
m: 'm';
km: 'km';
mi: 'mi';
ft: 'ft';
field: IDENT;
identifier: IDENT;
property: IDENT;
fragsize: INTEGER;
slop: INTEGER;
string: StringLiteral;
cursor: INTEGER;
depth_arg: INTEGER;
probability: FLOAT;
milliseconds: INTEGER;
alias: IDENT;
options: 'SORTABLE' | 'UNF' | 'NOSTEM'
    | 'NOINDEX' | 'PHONETIC' matcher
    | 'WEIGHT' weight
    | 'CASESENSITIVE'
    | 'WITHSUFFIXTRIE';
id: ID | INTEGER;

destination_db: IDENT;

destination: IDENT;

source: IDENT;

decrement: INTEGER;

message: StringLiteral;

unix_time_milliseconds: INTEGER;

unix_time_seconds: INTEGER;

operation: 'and' | 'or' | 'xor' | 'not';

destkey: IDENT;

member1: IDENT;

member2: IDENT;

pattern: GLOB_PATTERN;

key1: IDENT;
key2: IDENT;

matcher: 'dm:en' | 'dm:fr' | 'dm:pt' | 'dm:es';
option: IDENT | '*';
score: INTEGER;
limit: INTEGER;
consumername: IDENT | StringLiteral;
groupname: IDENT | StringLiteral;
align: 'start' | PLUS | 'end' | MINUS;
seconds: INTEGER;
port: INTEGER;
ip: INTEGER '.' INTEGER '.' INTEGER '.' INTEGER;
weight: INTEGER;
command_name: IDENT;
module_name: IDENT;
category: IDENT;
dst: IDENT;
src: IDENT;
replicationid: IDENT;

section: 'server'|'clients'|'memory'|'persistence'|'stats'|'replication'|'cpu'|'commandstats'|'latencystats'|'cluster'|'modules'
    |'keyspace'|'errorstats'|'all'|'default'|'everything';

width: INTEGER;
height: INTEGER;

len: INTEGER;

PLUS: '+';
MINUS: '-';

PREFIXED_INTEGER: '#' INTEGER;
ENCODING: ('i'|'u') Digit+;
WS: [ \t]+ -> skip;
IDENT: [a-zA-Z_][a-zA-Z0-9{}_]*;

NEWLINE: ('\r'? '\n')+ ; // multiple new lines are treated as a single new line

fragment
NonzeroDigit: [1-9];

fragment
Digit: [0-9];

INTEGER: (PLUS|MINUS)? (NonzeroDigit Digit*) | '0' 
    | '-inf' | 'inf' ;

ID: Digit+ ('-' Digit+)?;

password: StringLiteral;
FLOAT: DecimalFloatingConstant;

fragment
DecimalFloatingConstant: FractionalConstant;

fragment
FractionalConstant
    :   DigitSequence? '.' DigitSequence
    |   DigitSequence '.'
    ;

DigitSequence
    :   Digit+
    ;

fragment
EscapeSequence: '\\' ['"?abfnrtv\\];
fragment
SChar:   ~["\\\r\n]
    |   EscapeSequence;
fragment
SCharSequence: SChar+;
StringLiteral: '"' SCharSequence? '"';

GLOB_PATTERN: [a-zA-Z0-9\u002A]+;

progs: prog | prog NEWLINE progs;
program: elem=progs #ProgramRule;

entry_point: NEWLINE* elem=program NEWLINE* EOF #EntryPoint ;