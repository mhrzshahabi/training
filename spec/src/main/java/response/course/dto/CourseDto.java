package response.course.dto;

import dto.CategoryDto;
import dto.SubCategoryDto;
import lombok.Getter;
import lombok.Setter;
import dto.LevelType;
import dto.RunType;
import dto.TechnicalType;
import dto.TheoType;

@Getter
@Setter
public class CourseDto {
    private long id;
    private String code;
    private String titleFa;
    private CategoryDto category;
    private SubCategoryDto subCategory;
    private RunType runType;
    private LevelType levelType;
    private TheoType theoType;
    private float duration;
    private TechnicalType technicalType;
    private String workflowStatus;
    private String behavioralLevel;
    private String evaluation;
    private boolean hasGoal;
    private String createdBy;
    private String lastModifiedBy;
    private Integer startEvaluation;
    private String acceptancelimit;
    private String scoringMethod;
    private String workflowStatusCode;
    private String issueTitle;
    private String description;
    private String minTeacherDegree;
    private Long minTeacherExpYears;
    private Float minTeacherEvalScore;

}
