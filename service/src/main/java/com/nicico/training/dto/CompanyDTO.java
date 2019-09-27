package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.AccountInfo;
import com.nicico.training.model.Company;
import com.nicico.training.model.ContactInfo;
import com.nicico.training.model.PersonalInfo;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class CompanyDTO implements Serializable {

    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String email;
    @ApiModelProperty(required = true)
    private String workDomain;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyInfo")
    public static class Info extends CompanyDTO {
        private Long id;
      //  private PersonalInfoDTO.PersonalInfoInfoTuple manager;
      //  private AccountInfoDTO.AccountInfoInfoTuple accountInfoInfoTuple;
      //  private AddressDTO.AddressInfoTuple addressInfoTuple;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyCreateRq")
    public static class Create extends CompanyDTO {
        private Long managerId;

        private Long contactInfoId;

        private Set<Long> accountInfoIdSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyUpdateRq")
    public static class Update extends CompanyDTO.Create {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyIdListRq")
    public static class CompanyIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CompanySpecRs")
    public static class CompanySpecRs {
        private CompanyDTO.SpecRs response;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CompanyDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
