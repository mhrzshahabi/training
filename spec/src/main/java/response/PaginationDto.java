package response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaginationDto {
    private long total;
    private long current;
    private int size;
    private int last;
    private long totalItems;

}
