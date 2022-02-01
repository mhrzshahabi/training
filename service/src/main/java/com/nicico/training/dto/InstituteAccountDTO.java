package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class InstituteAccountDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long instituteId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long bankBranchId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long bankId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String accountNumber;
    @ApiModelProperty
    private String cartNumber;
    @ApiModelProperty
    private String shabaNumber;
    @ApiModelProperty
    private String accountOwnerName;
    @NotEmpty
    @ApiModelProperty
    private Integer isEnable;
    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteAccount")
    public static class Info extends InstituteAccountDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private BankDTO bank;
        private BankBranchDTO bankBranch;
        private InstituteDTO institute;
    }

    @Getter
    @Setter
    @ApiModel("AccountInfoTuple")
    public static class InstituteAccountInfoTuple extends InstituteAccountDTO {
        private BankDTO bank;
        private BankBranchDTO bankBranch;
        private InstituteDTO institute;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountCreateRq")
    public static class Create extends InstituteAccountDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountUpdateRq")
    public static class Update extends InstituteAccountDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AccountSpecRs")
    public static class AccountSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<InstituteAccountDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
