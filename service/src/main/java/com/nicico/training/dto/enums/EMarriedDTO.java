package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EMarried;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EMarriedDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EMarriedSpecRs")
    public static class EMarriedSpecRs {
        private EMarriedDTO.SpecRs response = new EMarriedDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EMarried[] data = EMarried.values();
        private Integer startRow = 0;
        private Integer endRow = EMarried.values().length;
        private Integer totalRows = EMarried.values().length;
    }

    @Getter
    @Setter
    @ApiModel("EMarriedInfoTuple")
    public static class EMarriedInfoTuple {
        private String titleFa;
    }
}