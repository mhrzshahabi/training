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
public class ClassPerformanceReportDTO implements Serializable {
    private String institute;
    private String category;
    private Integer planingClasses;
    private Integer processingClasses;
    private Integer finishedClasses;
    private Integer endedClasses;
    private Long instituteId;
    private Long categoryId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassPerformanceReportInfo")
    public static class Info extends ClassPerformanceReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassPerformanceReportSpecRs")
    public static class ClassPerformanceReportSpecRs {
        private ClassPerformanceReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassPerformanceReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
