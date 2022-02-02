package request.course;

import dto.*;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class CourseUpdateRequest implements Serializable {
    private static final long serialVersionUID = -9206070659075221058L;
    private String code;
    private String titleFa;
    private CategoryDto category;
    private SubCategoryDto subCategory;
    private int runType;
    private int levelType;
    private int theoType;
    private float duration;
    private int technicalType;
    private String workflowStatus;
    private String behavioralLevel;
    private String evaluation;
    private boolean hasGoal;
    private Integer startEvaluation;
    private String acceptancelimit;
    private String scoringMethod;
    private String workflowStatusCode;
    private String issueTitle;
    private String description;
    private String minTeacherDegree;
    private Long minTeacherExpYears;
    private Float minTeacherEvalScore;
    private List<SkillDto> mainSkills;
}
