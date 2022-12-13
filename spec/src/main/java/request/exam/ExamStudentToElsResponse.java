package request.exam;

import dto.exam.ExamStudentDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
@ToString
public class ExamStudentToElsResponse extends BaseResponse {
    private List<ExamStudentDTO.Info> data;
}
