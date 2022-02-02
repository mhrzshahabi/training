package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EArrangementType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EArrangementTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EArrangementTypeSpecRs")
    public static class EArrangementTypeSpecRs {
        private EArrangementTypeDTO.SpecRs response = new EArrangementTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EArrangementType[] data = EArrangementType.values();
        private Integer startRow = 0;
        private Integer endRow = EArrangementType.values().length;
        private Integer totalRows = EArrangementType.values().length;
    }
}
