package response.teacher;

import lombok.experimental.Accessors;
import response.teacher.dto.TeacherInCourseDto;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class TeacherInCourseListResponse extends BaseResponse implements Serializable {
    private static final long serialVersionUID = 1164197577368906351L;
    private List<TeacherInCourseDto> data;
    private int startRow;
    private int endRow;
    private long totalRows;

    @Getter
    @Setter
    public static class Response {
        private TeacherInCourseListResponse response;
    }
}
