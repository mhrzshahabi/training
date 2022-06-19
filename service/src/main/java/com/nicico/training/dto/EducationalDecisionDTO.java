package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class EducationalDecisionDTO {

    private Long educationalDecisionHeaderId;
    private String ref;
    private String itemFromDate;
    private String itemToDate;
    private Double educationalHistoryCoefficient;
    private String educationalHistoryFrom;
    private String educationalHistoryTo;
    private String baseTuitionFee;
    private String professorTuitionFee;
    private String knowledgeAssistantTuitionFee;
    private String teacherAssistantTuitionFee;
    private String instructorTuitionFee;
    private String educationalAssistantTuitionFee;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationalDecisionInfo")
    public static class Info extends EducationalDecisionDTO {
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
    @ApiModel("EducationDecisionDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationDecisionSpecRs")
    public static class EducationDecisionSpecRs {
        private EducationalDecisionDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationalDecisionDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
