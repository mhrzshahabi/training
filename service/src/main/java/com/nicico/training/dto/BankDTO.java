package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EBankType;
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
public class BankDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String titleEn;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer eBankTypeId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankInfo")
    public static class Info extends BankDTO {
        private Long id;
        private EBankType eBankType;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("BankInfoTuple")
    public static class BankInfoTuple {
        private Long id;
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankCreateRq")
    public static class Create extends BankDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankUpdateRq")
    public static class Update extends BankDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("BankSpecRs")
    public static class BankSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
