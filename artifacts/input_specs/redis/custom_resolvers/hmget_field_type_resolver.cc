ir::IR_PTR GetHmget0Node(ir::IR_PTR node) {
    auto cur = node;
    while(cur) {
        if(cur->GetName()=="hmget0") {
            return cur;
        }
        cur = cur->GetParent().lock();
    }
    return nullptr;
}

std::vector<ir::IR_PTR> GetDependencies(ir::IR_PTR ir) {
  auto key = GetHmget0Node(ir)->GetChildren()[1];
  return {key};
}

std::vector<std::string> ResolveValues(ResolveContext ctx) {
  auto key = GetHmget0Node(ctx.ir)->GetChildren()[1];
  
  auto key_type = "hset_key_" + key->ToSource();
  return {
    key_type + "_numtype", 
    key_type + "_strtype"
  };
}