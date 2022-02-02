package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EJobCompetenceType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EJobCompetenceTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EJobCompetenceTypeSpecRs")
    public static class EJobCompetenceTypeSpecRs {
        private EJobCompetenceTypeDTO.SpecRs response = new EJobCompetenceTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EJobCompetenceType[] data = EJobCompetenceType.values();
        private Integer startRow = 0;
        private Integer endRow = EJobCompetenceType.values().length;
        private Integer totalRows = EJobCompetenceType.values().length;
    }
}
