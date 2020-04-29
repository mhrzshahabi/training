package com.nicico.training.dto;

import com.nicico.training.ClassContractCostDTO;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CityInfo")
    public static class Info extends ClassContractDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;

        private Set<ClassContractCostDTO.Info> classSet;

        private PersonnelDTO.Info accountable;

        private CompanyDTO.Info firstPartyCompany;

        private CompanyDTO.Info secondPartyCompany;

        private PersonalInfoDTO.contractInfo secondPartyPerson;

    }

}

