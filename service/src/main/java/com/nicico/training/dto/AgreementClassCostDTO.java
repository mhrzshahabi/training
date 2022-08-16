package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AgreementClassCostDTO implements Serializable {

    private Double teachingCostPerHour;
    private Double teachingCostPerHourAuto;
    private Long classId;
    private Long agreementId;
    private Long basisCalculateId;
    private Long teacherId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AgreementClassCost - Info")
    public static class Info extends AgreementClassCostDTO {
        private Long id;
        private String titleClass;
        private String code;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AgreementClassCost - Create")
    public static class Create extends AgreementClassCostDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AgreementClassCost - Update")
    public static class Update extends AgreementClassCostDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AgreementClassCost - CalcTeachingCostList")
    public static class CalcTeachingCostList {
        private String fromDate;
        private List<AgreementClassCostDTO.Info> calcTeachingCost;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AgreementClassCostSpecRs")
    public static class AgreementClassCostSpecRs {
        private AgreementClassCostDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
