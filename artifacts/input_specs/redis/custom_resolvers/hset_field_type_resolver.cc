ir::IR_PTR GetHSet0Node(ir::IR_PTR node) {
    // hset0: hset1 hset3 hset4 hset5 hset6;
    // `node` is in a subtree of hset6, whereas the depth is unknown.
    // Therefore, to locate `hset3` (which is `key`), we use this util func
    //   to get to hset0 first.
    const char* target = "hset0";
    if(node->GetParent().lock()->GetName().starts_with("hsetnx")) {
      target = "hsetnx0";
    }
    auto cur = node;
    while(cur) {
        if(cur->GetName()==target) {
            return cur;
        }
        cur = cur->GetParent().lock();
    }
    MYLOG(FATAL, "Unable to find "<<target);
    return nullptr;
}

std::vector<ir::IR_PTR> GetDependencies(ir::IR_PTR ir) {
  auto key = GetHSet0Node(ir)->GetChildren()[1];
  auto value = ir->GetParent().lock()->GetRSib(1);
  return {key, value};
}


bool HsetFieldValueIsNum(std::string s) {
    // "123"->true
    if(s.size()>2 && s[0]=='"' && s.back() == '"') {
      return HsetFieldValueIsNum(s.substr(1, s.size()-2));
    }
    std::string::const_iterator it = s.begin();
    while (it != s.end() && (std::isdigit(*it) || *it=='.' || *it=='e' || *it =='-' ) ) ++it;
    return it == s.end();
}

std::vector<std::string> ResolveValues(ResolveContext ctx) {
  auto key = GetHSet0Node(ctx.ir)->GetChildren()[1];
  auto value = ctx.ir->GetParent().lock()->GetRSib(1);
  const char* type_suffix = nullptr;
  if(HsetFieldValueIsNum(value->ToSource())) {
    type_suffix = "_numtype";
  } else {
    type_suffix = "_strtype";
  }
  // e.g., hset_key_key1_type_num
  return {"hset_key_" + key->ToSource() + type_suffix};

}