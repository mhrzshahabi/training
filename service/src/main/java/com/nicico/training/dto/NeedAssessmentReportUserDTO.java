package com.nicico.training.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Data
public class NeedAssessmentReportUserDTO {
    private String assessment;
    private List<CompetenceInfo> competenceInfoList;
    private Integer needAssessmentCount;
    private Long needAssessmentPassCount;
    private Float needAssessmentDurationCount;




    @Getter
    @Setter
    public static class CompetenceInfo {
        private String competence;
        private String competenceTypeName;
        private String needsAssessmentDomainIdName;
        private String skillCode;
        private String skill;
        private String courseCode;
        private String courseName;
        private Float courseDuration;
        private String courseState;
    }
}
