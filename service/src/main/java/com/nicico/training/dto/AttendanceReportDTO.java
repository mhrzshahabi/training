package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class AttendanceReportDTO {
    String personalNum;
    String personalNum2;
    String nationalCode;
    String name;
    String ccpArea;
    String ccpAffairs;
    String classCode;
    String className;
    String date;
    String attendanceStatus;
    String time;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceReportDTOInfo")
    public static class Info extends AttendanceReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AttendanceReportDTOSpecRs")
    public static class AttendanceReportDTOSpecRs {
        private AttendanceReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<AttendanceReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
