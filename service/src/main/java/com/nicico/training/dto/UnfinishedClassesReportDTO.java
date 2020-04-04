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
public class UnfinishedClassesReportDTO implements Serializable {

    private Long id;
    private String classCode;
    private Long courseId;
    private String courseCode;
    private String courseName;
    private Long duration;
    private String startDate;
    private String endDate;
    private String firstSession;
    private String instituteName;
    private Integer sessionCount;
    private Integer heldSessions;
    private String teacher;
    private Long studentId;
    private String nationalCode;
    private String firstName;
    private String lastName;

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("UnfinishedClassesInfo")
    public static class Info extends UnfinishedClassesReportDTO {
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("UnfinishedClassesSpecRs")
    public static class  UnfinishedClassesSpecRs {
        private  UnfinishedClassesReportDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<UnfinishedClassesReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //*********************************
}
