package request.exam;

import dto.evaluuation.EvalTargetUser;
import dto.exam.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Setter
@Getter
@ToString
public class ElsExamRequest {
    private ExamCreateDTO exam;
    private ImportedCourseCategory category;
    private ImportedCourseDto course;
    private CourseProtocolImportDTO protocol;
    private List<ImportedCourseProgram> programs;
    private List<ImportedQuestionProtocol> questionProtocols;
    private ImportedUser instructor;
    private List<EvalTargetUser> users;
}
