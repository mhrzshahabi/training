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
public class ControlReportDTO {
    Long idClass;
    String codeClass;
    String nameCourse;
    String yearClass;
    String termClass;
    String instituteClass;
    String categoryClass;
    String subCategoryClass;
    String startDateClass;
    String endDateClass;
    String statusClass;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ControlReportDTOInfo")
    public static class Info extends ControlReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ControlReportDTOSpecRs")
    public static class ControlReportDTOSpecRs {
        private ControlReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ControlReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
