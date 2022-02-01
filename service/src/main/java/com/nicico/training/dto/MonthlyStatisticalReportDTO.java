package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class MonthlyStatisticalReportDTO implements Serializable {
    private String ccp_unit;
    private String ccp_assistant;
    private String ccp_affairs;
    private String ccp_section;
    private String complex_title;
    private String Present;
    private String Overtime;
    private String UnjustifiedAbsence;
    private String AcceptableAbsence;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MonthlyStatisticalInfo")
    public static class Info extends MonthlyStatisticalReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MonthlyStatisticalSpecRs")
    public static class MonthlyStatisticalSpecRs {
        private MonthlyStatisticalReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<MonthlyStatisticalReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
