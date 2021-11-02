package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PageDto;
import response.question.dto.ElsQuestionDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsClassListDto extends PageDto implements Serializable {
    private List<ElsClassDto> list;
}
