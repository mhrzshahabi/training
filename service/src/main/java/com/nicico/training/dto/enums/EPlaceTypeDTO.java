package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EPlaceType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EPlaceTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EPlaceTypeSpecRs")
    public static class EPlaceTypeSpecRs {
        private EPlaceTypeDTO.SpecRs response = new EPlaceTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EPlaceType[] data = EPlaceType.values();
        private Integer startRow = 0;
        private Integer endRow = EPlaceType.values().length;
        private Integer totalRows = EPlaceType.values().length;
    }
}
