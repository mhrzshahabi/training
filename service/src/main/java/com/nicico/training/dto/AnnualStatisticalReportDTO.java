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

    private Long institute_id;
    private String institute_title_fa;
    private Long category_id;
    private Long finished_class_count;
    private Long canceled_class_count;
    private Long sum_of_duration;
    private Long student_count;
    private Long sum_of_student_hour;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AnnualStatisticalReportInfo")
    public static class Info extends AnnualStatisticalReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AnnualStatisticalReportSpecRs")
    public static class AnnualStatisticalReportDTOSpecRs {
        private AnnualStatisticalReportDTO.SpecRs response;
    }

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
