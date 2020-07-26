package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class EvaluationDTO implements Serializable {

    private Long questionnaireTypeId;
    private Long classId;
    private Long evaluatorId;
    private Long evaluatorTypeId;
    private Long evaluatedId;
    private Long evaluatedTypeId;
    private Long evaluationLevelId;
    private String description;
    private Boolean evaluationFull;
    private Boolean status;
    private String returnDate;
    private String sendDate;
    private Long questionnaireId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Info")
    public static class Info extends EvaluationDTO {
        private List<EvaluationAnswerDTO.Info> evaluationAnswerList;
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Create")
    public static class Create extends EvaluationDTO {
        private List<EvaluationAnswerDTO.Info> evaluationAnswerList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Update")
    public static class Update {
        private Boolean evaluationFull;
        private String description;
        private Boolean status;
        private String returnDate;
        private List<EvaluationAnswerDTO.Update> evaluationAnswerList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EvaluationSpecRs")
    public static class EvaluationSpecRs {
        private EvaluationDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //-----------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationLearningResult")
    public static class EvaluationLearningResult{
        private String preTestMeanScore;
        private String postTestMeanScore;
        private String havePreTest;
        private String havePostTest;
        private String felgrade;
        private String limit;
        private String felpass;
        private String feclgrade;
        private String feclpass;
        private String tstudent;
        private Float studentCount;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BehavioralForms")
    public static class BehavioralForms {
        private Long evaluatorTypeId;
        private String evaluatorName;
        private Boolean status;
        private Long id;
        private Long evaluatorId;
        private String returnDate;
        private String evaluatorTypeTitle;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentEvaluationForm - Info")
    public static class StudentEvaluationForm {
        private Long evaluationLevel;
        private Long questionnarieType;
        private String classCode;
        private String classStartDate;
        private String courseCode;
        private String courseTitle;
        private String teacherName;
        private Boolean hasWarning;
        private Long studentId;
        private Long classId;
        private String studentName;
    }

}
