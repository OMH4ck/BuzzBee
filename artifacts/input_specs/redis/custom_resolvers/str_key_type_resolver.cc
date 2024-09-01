
std::vector<ir::IR_PTR> GetDependencies(ir::IR_PTR ir) {
  auto value_ir = ir->GetParent().lock()->GetRSib(1);
  return {value_ir};
}

bool StrKeyIsNum(std::string s) {
    // "123"->true
    if(s.size()>2 && s[0]=='"' && s.back() == '"') {
      return StrKeyIsNum(s.substr(1, s.size()-2));
    }
    std::string::const_iterator it = s.begin();
    while (it != s.end() && (std::isdigit(*it) || *it=='.' || *it=='e' || *it =='-' ) ) ++it;
    return it == s.end();
}

std::vector<std::string> ResolveValues(ResolveContext ctx) {
  auto value_ir = ctx.ir->GetParent().lock()->GetRSib(1);
  if(StrKeyIsNum(value_ir->ToSource())) {
    return {"str_key_type_num"};
  }

  return {"str_key"};

}