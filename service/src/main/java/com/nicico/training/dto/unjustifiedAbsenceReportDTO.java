package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
public class unjustifiedAbsenceReportDTO {
    private String sessionDate;
    private String lastName;
    private String firstName;
    private String titleClass;
    private String startDate;
    private String endDate;
    private String endHour;
    private String startHour;
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("preTestScoreReportSpecRs")
    public static class unjustifiedAbsenceReporSpecRs {
        private PreTestScoreReportDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<unjustifiedAbsenceReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
