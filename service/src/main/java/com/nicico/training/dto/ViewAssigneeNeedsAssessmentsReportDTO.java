package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewAssigneeNeedsAssessmentsReportDTO implements Serializable {

    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String code;

    @ApiModelProperty
    private String des;

    @ApiModelProperty
    private String assignee;

    @ApiModelProperty
    private Date time;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AssigneeNeedsAssessmentsReportDTOInfo")
    public static class Info extends ViewAssigneeNeedsAssessmentsReportDTO {
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingNeedAssessmentDTOSpecRs")
    public static class TrainingNeedAssessmentDTOSpecRs {
        private ViewAssigneeNeedsAssessmentsReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewAssigneeNeedsAssessmentsReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
