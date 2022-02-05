package request.exam;

import dto.exam.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
@ToString
public class ElsExamQuestionsResponse extends BaseResponse {
    private ExamCreateDTO exam;
    private ImportedCourseCategory category;
    private ImportedCourseDto course;
    private CourseProtocolImportDTO protocol;
    private List<ImportedCourseProgram> programs;
    private List<ImportedQuestionProtocol> questionProtocols;
    private ImportedUser instructor;
}
