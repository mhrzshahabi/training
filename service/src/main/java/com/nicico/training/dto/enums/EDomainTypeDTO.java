package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EDomainType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EDomainTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EDomainTypeSpecRs")
    public static class EDomainTypeSpecRs {
        private EDomainTypeDTO.SpecRs response = new EDomainTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EDomainType[] data = EDomainType.values();
        private Integer startRow = 0;
        private Integer endRow = EDomainType.values().length;
        private Integer totalRows = EDomainType.values().length;
    }
}
