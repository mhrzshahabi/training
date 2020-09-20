package response.course;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.course.dto.CourseDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class CourseListResponse extends BaseResponse implements Serializable {

    private static final long serialVersionUID = 1164197577368906351L;
    private List<CourseDto> data;

    private int startRow;
    private int endRow;
    private long totalRows;
    @Getter
    @Setter
    public static class Response {
        private CourseListResponse response;
    }
}

