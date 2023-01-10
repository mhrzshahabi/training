package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

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
        private String classStartDate;
        private String classEndDate;
        private String studentFirstName;
        private String studentLastName;
        private String studentNationalCode;
        private String studentComplex;
        private String studentAssistant;
        private String studentAffairs;
        private String studentSection;
        private String studentUnit;
        private String postTitle;
        private String postCode;
        private String personnelNo2;
        private String studentAcceptanceStatus;
        private Double score;
        private Long evaluationId;
        private Double evaluationAverage;
        private Long evaluationFieldId;
        private String evaluationField;
        private Double evaluationFieldAverage;
        @Getter(AccessLevel.NONE)
        private String fullName;

        public String getFullName() {
            return (studentFirstName + " " + studentLastName).compareTo("null null") == 0 ? null : studentFirstName + " " + studentLastName;
        }

    }
}
