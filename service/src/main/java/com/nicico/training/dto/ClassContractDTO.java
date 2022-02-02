package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class ClassContractDTO {
    private String contractNumber;
    private String date;
    private Boolean isSigned = false;
    private Long categoryId;
    private Long subCategoryId;
    private String accountableId;
    private Long firstPartyCompanyId;
    private Long secondPartyCompanyId;
    private Long secondPartyPersonId;
    private Long contractFileId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info extends ClassContractDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        private Set<ClassContractCostDTO.Info> classSet;
        private PersonnelDTO.Info accountable;
        private CompanyDTO.Info firstPartyCompany;
        private InstituteDTO.ContractInfo secondPartyInstitute;
        private PersonalInfoDTO.contractInfo secondPartyPerson;
    }
}

