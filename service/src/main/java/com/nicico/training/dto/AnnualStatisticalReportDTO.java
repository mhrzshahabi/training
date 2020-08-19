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
public class AnnualStatisticalReportDTO implements Serializable {
    Long instituteId;
    String instituteTitle;
    Long categoryId;
    String categoryTitle;
    String classStatus;
    Long countCourses;
    Long countStudents;
    Float sumHours;
    Float sumHoursPerPerson;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AnnualStatisticalReportInfo")
    public static class Info extends AnnualStatisticalReportDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AnnualStatisticalReportSpecRs")
    public static class AnnualStatisticalReportDTOSpecRs {
        private AnnualStatisticalReportDTO.SpecRs response;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<AnnualStatisticalReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
