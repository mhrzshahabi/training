package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ECompetenceInputType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ECompetenceInputTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ECompetenceInputTypeSpecRs")
    public static class ECompetenceInputTypeSpecRs {
        private ECompetenceInputTypeDTO.SpecRs response = new ECompetenceInputTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ECompetenceInputType[] data = ECompetenceInputType.values();
        private Integer startRow = 0;
        private Integer endRow = ECompetenceInputType.values().length;
        private Integer totalRows = ECompetenceInputType.values().length;
    }
}
