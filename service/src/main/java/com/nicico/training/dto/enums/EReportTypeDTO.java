package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EReportType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EReportTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EReportTypeSpecRs")
    public static class EReportTypeSpecRs {
        private EReportTypeDTO.SpecRs response = new EReportTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EReportType[] data = EReportType.values();
        private Integer startRow = 0;
        private Integer endRow = EReportType.values().length;
        private Integer totalRows = EReportType.values().length;
    }
}
