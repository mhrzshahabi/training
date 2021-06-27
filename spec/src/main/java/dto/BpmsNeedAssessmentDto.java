package dto;


import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import response.teacher.dto.TeacherInCourseDto;

@Setter
@Getter
public class BpmsNeedAssessmentDto {

    private Long id;
    @Getter(AccessLevel.NONE)
    private CompetenceDTO competence;
//    private BpmsSkillDTO skill;
    private Long needsAssessmentDomainId;
    private Long needsAssessmentPriorityId;



    private TeacherInCourseDto teacher;

    public CompetenceDTO getCompetence() {
        return null;
    }

}
