package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class AccountInfoDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfo")
    public static class Info{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private String accountNumber;
        private String bank;
        private String bBranch;
        private Long bCode;
        private String cartNumber;
        private String shabaNumber;
        private String description;
    }

    @Getter
	@Setter
	@ApiModel("AccountInfoInfoTuple")
	public static class AccountInfoInfoTuple {
        private String accountNumber;
        private String bank;
        private String bBranch;
        private Long bCode;
        private String cartNumber;
        private String shabaNumber;
        private String description;
	}

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoCreateRq")
    public static class Create{
        private String bank;
        private String bBranch;
        private Long bCode;
        private String cartNumber;
        private String shabaNumber;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AccountInfoUpdateRq")
    public static class Update{
        private String bank;
        private String bBranch;
        private Long bCode;
        private String cartNumber;
        private String shabaNumber;
        private String description;
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

