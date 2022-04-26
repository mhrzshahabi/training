package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EServiceType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EServiceTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EServiceTypeSpecRs")
    public static class EServiceTypeSpecRs {
        private EServiceTypeDTO.SpecRs response = new EServiceTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EServiceType[] data = EServiceType.values();
        private Integer startRow = 0;
        private Integer endRow = EServiceType.values().length;
        private Integer totalRows = EServiceType.values().length;
    }
}
