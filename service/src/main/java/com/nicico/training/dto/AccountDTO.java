package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.Bank;
import com.nicico.training.model.BankBranch;
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
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class AccountDTO {

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

    @ApiModelProperty
    private String description;
    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Account")
    public static class Info extends AccountDTO{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private BankDTO bank;
        private BankBranchDTO bankBranch;
    }

    @Getter
    @Setter
    @ApiModel("AccountInfoTuple")
    public static class AccountInfoTuple extends AccountDTO{
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountCreateRq")
    public static class Create extends AccountDTO{
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountUpdateRq")
    public static class Update extends AccountDTO{
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
        private List<AccountDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
