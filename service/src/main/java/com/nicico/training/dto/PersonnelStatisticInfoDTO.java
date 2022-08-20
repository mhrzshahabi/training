package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Data
public class PersonnelStatisticInfoDTO {
    private String complexTitle;
    private String assistance;
    private String affairs;
    private String section;
    private String unit;
    private String totalNumber;
    private String managerNumber;
    private String bossNumber;
    private String supervisorNumber;
    private String expertsNumber;
    private String attendantsNumber;
    private String workersNumber;
    private String unrankedNumber;
    private String empStatus;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingOverTimeReportDTOInfo")
    public static class Info extends PersonnelStatisticInfoDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingPersonnelStatisticInfo")
    public static class TrainingPersonnelStatisticInfo extends ViewTrainingOverTimeReportDTO {
        private PersonnelStatisticInfoDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<PersonnelStatisticInfoDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

