#ifndef SRC_REDIS_FRONTEND_H_
#define SRC_REDIS_FRONTEND_H_
#include "src/core/ir.h"
#include "src/core/symbol_analysis.h"
#include "src/core/mutator.h"

using InsertableType = frontend::InsertableType;
using RemovableType = frontend::RemovableType;

namespace ##grammar##_frontend {
ir::IR_PTR ParseSourceToIR(std::string source);

##ExposeRuleTypeAPIDeclPlaceholder##

std::string GetSymInfo();

std::vector<RemovableType> GetRemovableTypes();

uint64_t GetReplaceBoundaryType();

std::vector<InsertableType> GetInsertableTypes();

CUSTOM_TYPE_RESOLVER_MAP_TYPE GetCustomTypeResolverMap();

CUSTOM_ACTION_SELECTOR_MAP_TYPE GetCustomActionSelectorMap();

absl::flat_hash_map<uint64_t, double> GetWeightMap();

MUTATION_CANDIDATE_MAP_TYPE GetMutationCandidateMap();

size_t GetNumOfTerminalIRTypes();

size_t GetNumOfRuleIRTypes();

std::string GetIRTypeNameFromGrammar(uint64_t ir_type);

class ##Grammar##Interface: public frontend::Interface {
    virtual std::function<ir::IR_PTR(std::string)> GetParserFunc() override {
        return ##grammar##_frontend::ParseSourceToIR;
    }

    virtual std::string GetSymInfo() override {
        return ##grammar##_frontend::GetSymInfo();
    }

    virtual MUTATION_CANDIDATE_MAP_TYPE GetMutationCandidateMap() override {
        return ##grammar##_frontend::GetMutationCandidateMap();
    }

    virtual std::vector<RemovableType> GetRemovableTypes() override {
        return ##grammar##_frontend::GetRemovableTypes();
    }

    virtual uint64_t GetReplaceBoundaryType() override {
        return ##grammar##_frontend::GetReplaceBoundaryType();
    }

    virtual std::vector<InsertableType> GetInsertableTypes() override {
        return ##grammar##_frontend::GetInsertableTypes();
    }

    virtual CUSTOM_TYPE_RESOLVER_MAP_TYPE GetCustomTypeResolverMap() override {
        return ##grammar##_frontend::GetCustomTypeResolverMap();
    }

    virtual CUSTOM_ACTION_SELECTOR_MAP_TYPE GetCustomActionSelectorMap() override {
        return ##grammar##_frontend::GetCustomActionSelectorMap();
    }

    virtual size_t GetNumOfTerminalIRTypes() override {
        return ##grammar##_frontend::GetNumOfTerminalIRTypes();
    }

    virtual size_t GetNumOfRuleIRTypes() override {
        return ##grammar##_frontend::GetNumOfRuleIRTypes();
    }

    virtual std::string GetIRTypeNameFromGrammar(uint64_t ir_type) override {
        return ##grammar##_frontend::GetIRTypeNameFromGrammar(ir_type);
    }

    virtual std::string GetTokenSep() override {
        return ##TokenSepPlaceHolder##;
    }

    virtual absl::flat_hash_map<uint64_t, double> GetWeightMap() override {
        return ##grammar##_frontend::GetWeightMap();
    }

};

extern "C" {
    extern std::shared_ptr<##Grammar##Interface> interface;
}


}  // namespace ##grammar##_frontend

#endif  // SRC_REDIS_FRONTEND_H_