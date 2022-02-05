package response.requestItem;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class RequestItemDto {
    private List<RequestItemWithDiff> list;
    private int wrongCount;
}
