package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EMilitary;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EMilitaryDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EMilitarySpecRs")
    public static class EMilitarySpecRs {
        private EMilitaryDTO.SpecRs response = new EMilitaryDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EMilitary[] data = EMilitary.values();
        private Integer startRow = 0;
        private Integer endRow = EMilitary.values().length;
        private Integer totalRows = EMilitary.values().length;
    }

    @Getter
    @Setter
    @ApiModel("EMilitaryInfoTuple")
    public static class EMilitaryInfoTuple {
        private String titleFa;
    }
}