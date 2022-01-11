package dto.bpms;


import dto.BpmsCompetenceDTO;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;

@Setter
@Getter
public class BpmsStartParamsDto {
    private Map<String,Object> data;
    private BpmsCompetenceDTO rq;

}
