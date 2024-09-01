std::vector<ir::IR_PTR> GetDependencies(ir::IR_PTR ir) {
  auto key = ir->GetParent().lock()->GetLSib(1);
  return {key};
}

std::vector<std::string> ResolveValues(ResolveContext ctx) {
  auto key = ctx.ir->GetParent().lock()->GetLSib(1);
  
  auto key_type = "hset_key_" + key->ToSource();
  return {
    key_type + "_numtype"
  };
}