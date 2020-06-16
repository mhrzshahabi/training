package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

public class AttendancePerformanceReportDTO implements Serializable {
    private Long instituteId;

    private Long categoryId;

    private Long unknown;

    private Long present;

    private Long overdue;

    private Long absence;

    private Long unjustified;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendancePerformanceReportInfo")
    public static class Info extends AttendancePerformanceReportDTO {
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendancePerformanceReportSpecRs")
    public static class AttendancePerformanceReportSpecRs {
        private AttendancePerformanceReportDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<AttendancePerformanceReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //*********************************
}
