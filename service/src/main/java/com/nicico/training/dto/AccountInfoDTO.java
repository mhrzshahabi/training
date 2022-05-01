package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AccountInfoDTO {

    private String accountNumber;
    private String bank;
    private String bankBranch;
    private Long bankBranchCode;
    private String cartNumber;
    private String shabaNumber;
    private Long instituteId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfo")
    public static class Info extends AccountInfoDTO {
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoCreateOrUpdateRq")
    public static class CreateOrUpdate extends AccountInfoDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoCreateRq")
    public static class Create extends AccountInfoDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoUpdateRq")
    public static class Update extends AccountInfoDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ShabaInfo")
    public static class ShabaInfo {
        private String shabaNumber;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AccountInfoSpecRs")
    public static class AccountInfoSpecRs {
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

