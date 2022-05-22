package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Objects;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class AnnualStatisticalReportDTO implements Serializable {
    private DecimalFormat numberFormat = new DecimalFormat("#.00");
    private Long institute_id;
    private String institute_title_fa;
    private Long category_id;
    private Long finished_class_count;
    private Long canceled_class_count;
    private Long sum_of_duration;
    private Long student_count;
    private Long sum_of_student_hour;
    private Long barnamerizi_class_count;
    private Long ejra_class_count;
    private Long ekhtetam_class_count;
    private Long student_count_ghabool;
    private Long sum_of_omomi;
    private Long sum_of_takhasosi;
    private Long student_contractor_personal;
    private Long student_personal;
    private Long student_sayer;
    @Getter(AccessLevel.NONE)
    private Double sarane_omomi;
    @Getter(AccessLevel.NONE)
    private Double sarane_takhasosi;
    private Long class_count;
    @Getter(AccessLevel.NONE)
    private Double darsad_ostad_dakheli;
    private Long ostad_count_dakheli;
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

    public Double getSarane_omomi() {
        if (sarane_omomi!=null)
        return sarane_omomi;
        else return 0.0;
    }

    public Double getSarane_takhasosi() {
        if (sarane_takhasosi!=null)
            return sarane_takhasosi;
        else return 0.0;
    }

    public Double getDarsad_ostad_dakheli() {
        return Objects.requireNonNullElse(darsad_ostad_dakheli, 0.0);
    }
}
