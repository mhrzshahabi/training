package com.nicico.training.dto;

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
public class EducationalDecisionHeaderDTO {

    private String complex;
    private String itemFromDate;
    private String itemToDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationalDecisionHeaderInfo")
    public static class Info extends EducationalDecisionHeaderDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationDecisionHeaderDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationDecisionHeaderSpecRs")
    public static class EducationDecisionHeaderSpecRs {
        private EducationalDecisionHeaderDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationalDecisionHeaderDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
