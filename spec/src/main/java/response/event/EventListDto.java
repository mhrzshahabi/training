package response.event;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class EventListDto extends BaseResponse implements Serializable {
    @ApiModelProperty
    private List<EventDto> eventDtoList;
}
