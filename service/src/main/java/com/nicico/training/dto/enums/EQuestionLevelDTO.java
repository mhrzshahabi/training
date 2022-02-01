package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EQuestionLevel;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EQuestionLevelDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EQuestionLevelSpecRs")
    public static class EQuestionLevelSpecRs {
        private EQuestionLevelDTO.SpecRs response = new EQuestionLevelDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EQuestionLevel[] data = EQuestionLevel.values();
        private Integer startRow = 0;
        private Integer endRow = EQuestionLevel.values().length;
        private Integer totalRows = EQuestionLevel.values().length;
    }
}
