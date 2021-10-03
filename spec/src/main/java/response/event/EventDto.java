package response.event;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.question.dto.ElsQuestionTargetDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class EventDto  {


    private String startTime;
    private String endTime;
    private String date;
    private String title;
    private String location;


}
