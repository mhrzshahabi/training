package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PageDto;
import response.PaginationDto;
import response.question.dto.ElsQuestionDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsClassListDto  {
    private List<ElsClassDto> list;
    private PaginationDto paginationDto;

}
