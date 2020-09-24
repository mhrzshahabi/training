package response.course;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.course.dto.CourseDto;

@Getter
@Setter
public class CourseUpdateResponse extends BaseResponse {
    private CourseDto record;
}
