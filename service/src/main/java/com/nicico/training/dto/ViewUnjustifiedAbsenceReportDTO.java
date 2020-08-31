package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.*;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class ViewUnjustifiedAbsenceReportDTO {
    private String sessionDate;
    private String lastName;
    private String firstName;
    private String titleClass;
    private String startDate;
    private String endDate;
    private String code;
    private String endHour;
    private String startHour;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewUnjustifiedAbsenceReportDTOInfo")
    public static class Info extends ViewUnjustifiedAbsenceReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewUnjustifiedAbsenceReportDTOSpecRs")
    public static class ViewUnjustifiedAbsenceReportDTOSpecRs {
        private ViewUnjustifiedAbsenceReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewUnjustifiedAbsenceReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
