package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NeedAssessmentGroupJobPromotionResponse {
    private Long id;
    private CompetenceDTO.NeedsAssessmentReportInfo competence;
    private SkillDTO.NeedsAssessmentReportInfo skill;
    private Long needsAssessmentDomainId;
    private Long needsAssessmentPriorityId;
    private String competenceTypeTitle;
    private String needsAssessmentPriorityTitle;
    private String scoresStateTitle;
    private String firstName;
    private String lastName;
    private String personnelNo;
    private String personnelCcpAffairs;
    private String trainingPostCode;
}
