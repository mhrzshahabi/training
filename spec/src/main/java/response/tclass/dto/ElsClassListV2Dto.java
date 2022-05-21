package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.PaginationDto;

import java.util.List;

@Getter
@Setter
public class ElsClassListV2Dto {
    private List<ElsClassV2Dto> list;
    private PaginationDto paginationDto;
}
