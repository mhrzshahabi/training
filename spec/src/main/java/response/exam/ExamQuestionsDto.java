package response.exam;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.question.QuestionsDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ExamQuestionsDto extends BaseResponse implements Serializable {

    private List<QuestionsDto> data;


}
