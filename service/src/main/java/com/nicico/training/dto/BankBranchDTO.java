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
public class BankBranchDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String titleEn;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer eBankTypeId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long bankId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long addressId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankBranchInfo")
    public static class Info extends BankBranchDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private BankDTO bank;
        private AddressDTO address;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("BankBranchInfoTuple")
    public static class BankBranchInfoTuple {
        private Long id;
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankBranchCreateRq")
    public static class Create extends BankBranchDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankBranchUpdateRq")
    public static class Update extends BankBranchDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankBranchDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("BankBranchSpecRs")
    public static class BankBranchSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<BankBranchDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
