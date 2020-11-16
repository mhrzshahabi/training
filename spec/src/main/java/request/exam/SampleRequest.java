package request.exam;

import com.google.gson.JsonObject;
import dto.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class SampleRequest implements Serializable {

    private ExamData examItem;
    private List<QuestionData> questions;



//
//    private EvalCourse course;
//    private EvalCourseProtocol courseProtocol;

}
