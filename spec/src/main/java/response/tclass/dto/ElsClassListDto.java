package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.PaginationDto;

import java.util.List;

@Getter
@Setter
public class ElsClassListDto {
    private List<ElsClassDto> list;
    private PaginationDto paginationDto;
}
