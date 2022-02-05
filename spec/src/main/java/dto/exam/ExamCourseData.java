package dto.exam;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamCourseData {
    private String code;
    private String titleFa;
    private ExamCourseCategoryData category;
}
