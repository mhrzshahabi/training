package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
public class ViewEvaluationIndexByFieldReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewClassDetailInfo")
    public static class Info {
        private Long id;
        private String courseCode;
        private String classCode;
        private String teacherFirstName;
        private String teacherLastName;
        private String teacherNationalCode;
        private String evaluationAffairs;
        private String postTitle;
        private String postCode;
        private String personnelNo2;
        private String studentAcceptanceStatus;
        private String score;
        private BigDecimal evaluationId;
        private BigDecimal evaluationAverage;
        private String evaluationField;
    }
}
