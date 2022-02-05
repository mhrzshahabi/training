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
public class AttendancePerformanceReportDTO implements Serializable {
    private String institute;
    private String category;
    private Long instituteId;
    private Long categoryId;
    private Long unknownStudents;
    private Long presentStudents;
    private Long overdueStudents;
    private Long absentStudents;
    private Long unjustifiedStudents;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendancePerformanceReportInfo")
    public static class Info extends AttendancePerformanceReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendancePerformanceReportSpecRs")
    public static class AttendancePerformanceReportSpecRs {
        private AttendancePerformanceReportDTO.SpecRs response;
    }

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
}
