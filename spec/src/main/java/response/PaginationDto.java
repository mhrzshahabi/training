package response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaginationDto {
    private Long total;
    private Long current;
    private Integer size;
    private Integer last;
    private Long totalItems;

}
