package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class RequestItemDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String personnelNumber;
    private String personnelNo2;
    private String name;
    private String lastName;
    private String affairs;
    private String post;
    private String postTitle;
    private String currentPostTitle;
    private String educationLevel;
    private String educationMajor;
    private String state;
    private long competenceReqId;
//    private String workGroupCode;
//    private List<Long> operationalRoleIds;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemInfo")
    public static class Info extends RequestItemDTO {
        private Long id;
        private String nationalCode;
        private List<String> operationalRoleTitles;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemRq")
    public static class Create extends RequestItemDTO {
        private String nationalCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("RequestItemSpecRs")
    public static class RequestItemSpecRs {
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
