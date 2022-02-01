package dto.bpms;

import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashMap;
import java.util.List;

@Setter
@Getter
public class BpmsDefinitionDto {
    private List<BpmsContent> content;
    private Integer total;
    private Boolean last;
    private Boolean first;
    private Boolean empty;
    private LinkedHashMap<String, Object> pageable;
}
