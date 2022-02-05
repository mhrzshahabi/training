package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EGender;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EGenderDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EGenderSpecRs")
    public static class EGenderSpecRs {
        private EGenderDTO.SpecRs response = new EGenderDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EGender[] data = EGender.values();
        private Integer startRow = 0;
        private Integer endRow = EGender.values().length;
        private Integer totalRows = EGender.values().length;
    }

    @Getter
    @Setter
    @ApiModel("EGenderInfoTuple")
    public static class EGenderInfoTuple {
        private String titleFa;
    }
}