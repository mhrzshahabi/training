package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ETheoType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ETheoTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ETheoTypeSpecRs")
    public static class ETheoTypeSpecRs {
        private ETheoTypeDTO.SpecRs response = new ETheoTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ETheoType[] data = ETheoType.values();
        private Integer startRow = 0;
        private Integer endRow = ETheoType.values().length;
        private Integer totalRows = ETheoType.values().length;
    }
}