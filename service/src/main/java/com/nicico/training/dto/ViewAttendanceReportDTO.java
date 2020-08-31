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
public class ViewAttendanceReportDTO {
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
    public static class Info extends ViewAttendanceReportDTO {

        @Getter(AccessLevel.NONE)
        private String fixTime;

        public String getFixTime(){
            return time != null ? time.toString().split(":")[1].equals("0") ? time.toString().split(":")[0] : time.toString() : null;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AttendanceReportDTOSpecRs")
    public static class AttendanceReportDTOSpecRs {
        private ViewAttendanceReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewAttendanceReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
