package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ENeedAssessmentPriority;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ENeedAssessmentPriorityDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ENeedAssessmentPrioritySpecRs")
    public static class ENeedAssessmentPrioritySpecRs {
        private ENeedAssessmentPriorityDTO.SpecRs response = new ENeedAssessmentPriorityDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ENeedAssessmentPriority[] data = ENeedAssessmentPriority.values();
        private Integer startRow = 0;
        private Integer endRow = ENeedAssessmentPriority.values().length;
        private Integer totalRows = ENeedAssessmentPriority.values().length;
    }
}
