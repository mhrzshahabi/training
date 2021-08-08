package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.util.date.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewUnAssigneeNeedsAssessmentsReportDTO implements Serializable {

    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String code;

    @ApiModelProperty
    private String createdBy;

    @Getter(AccessLevel.NONE)
    @ApiModelProperty
    private String type;

    @ApiModelProperty
    private String title;

    @ApiModelProperty
    private String object;

    @ApiModelProperty
    private Date time;

    public String getType() {
        switch (type) {
            case "TrainingPost":
                return "پست";
            case "Post":
                return "پست انفرادی";
            case "PostGroup":
                return "پست گروهی";
            case "Job":
                return "شغل";
            default:
                return type;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("UnAssigneeNeedsAssessmentsReportDTOInfo")
    public static class Info extends ViewUnAssigneeNeedsAssessmentsReportDTO {
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingUnAssigneeNeedAssessmentDTOSpecRs")
    public static class TrainingNeedAssessmentDTOSpecRs {
        private ViewUnAssigneeNeedsAssessmentsReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewUnAssigneeNeedsAssessmentsReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
