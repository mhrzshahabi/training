/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.dto;

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

        private Long id;

        private long personnelId;

        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private Float theoryDuration;
        private Integer technicalType;

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
}
