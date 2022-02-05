package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ERunType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ERunTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ERunTypeSpecRs")
    public static class ERunTypeSpecRs {
        private ERunTypeDTO.SpecRs response = new ERunTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ERunType[] data = ERunType.values();
        private Integer startRow = 0;
        private Integer endRow = ERunType.values().length;
        private Integer totalRows = ERunType.values().length;
    }
}
