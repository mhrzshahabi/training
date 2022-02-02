package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.compositeKey.TrainingFileNAReportKey;
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
public class TrainingFileNAReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info {
        private TrainingFileNAReportKey reportId;
        private Long id;
        private long personnelId;
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private Float theoryDuration;
        private Integer technicalType;
        private Long referenceCourse;
        private Long skillId;
        private String skillCode;
        private String skillTitleFa;
        private Long priorityId;
        private String priority;
        private Boolean isInNA;
        private Long classId;
        private String classCode;
        private String classStartDate;
        private String classEndDate;
        private String location;
        private Float score;
        private Long scoreStateId;
        private String scoreState;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GenerateReport")
    public static class GenerateReport {
        private List<List<Cell>> headers;
        private List<String> titlesOfGrid;
        private List<List<String>> dataOfGrid;
        private List<String> titlesOfSummaryGrid;
        private List<List<String>> dataOfSummaryGrid;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Cell")
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Cell {
        private String title;
        private boolean bold;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingFileNAReportSpecRs")
    public static class TrainingFileNAReportSpecRs {
        private TrainingFileNAReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TrainingFileNAReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
