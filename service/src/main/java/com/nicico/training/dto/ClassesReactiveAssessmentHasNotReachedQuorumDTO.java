package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import java.io.Serializable;
import java.util.Date;
import java.util.List;


@Getter
@Setter
@Accessors(chain = true)
public class ClassesReactiveAssessmentHasNotReachedQuorumDTO  implements Serializable {

    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private Integer reactionPercent;

    @ApiModelProperty
    private Integer reactiveLimit;

    @ApiModelProperty
    private String mojtameTitle;

    @ApiModelProperty
    private String classCode;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String courseTitle;

    @ApiModelProperty
    private String teacherName;

    @ApiModelProperty
    private Date classStartDate;

    @ApiModelProperty
    private Date classEndDate;

    @ApiModelProperty
    private Integer classDuration;

    @ApiModelProperty
    private String supervisorName;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassesReactiveAssessmentHasNotReachedQuorumDTOInfo")
    public static class Info extends ClassesReactiveAssessmentHasNotReachedQuorumDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassesReactiveAssessmentHasNotReachedQuorumDTOSpecRs")
    public static class ClassesReactiveAssessmentHasNotReachedQuorumDTOSpecRs {
        private  ClassesReactiveAssessmentHasNotReachedQuorumDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List< ClassesReactiveAssessmentHasNotReachedQuorumDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
