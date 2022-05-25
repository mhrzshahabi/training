package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EServiceType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Accessors(chain = true)
public class AgreementDTO implements Serializable {

    private Long firstPartyId;
    private Long secondPartyTeacherId;
    private Long secondPartyInstituteId;
    private Long currencyId;
    private Long finalCost;
    private String subject;
    private Boolean teacherEvaluation;
    private Long maxPaymentHours;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Info")
    public static class Info extends AgreementDTO {
        private Long id;
        private InstituteDTO.Info firstParty;
        private TeacherDTO.Info secondPartyTeacher;
        private InstituteDTO.Info secondPartyInstitute;
        private ParameterValueDTO.MinInfo currency;
        private EServiceType serviceType;
        private String fileName;
        private String group_id;
        private String key;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Create")
    public static class Create extends AgreementDTO {
        private Long serviceTypeId;
        private List<AgreementClassCostDTO.Create> classCostList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Update")
    public static class Update extends AgreementDTO {
        private Long id;
        private boolean changed;
        private Long serviceTypeId;
        private List<AgreementClassCostDTO.Create> classCostList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Upload")
    public static class Upload {
        private Long id;
        private String fileName;
        private String group_id;
        private String key;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Download")
    public static class Download {
        private Long id;
        private String fileName;
        private String group_id;
        private String key;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - PrintInfo")
    public static class PrintInfo {
        private Long id;
        private Map<String, String> firstParty;
        private Map<String, String> secondParty;
        private Map<String, String> secondPartyTeacher;
        private Map<String, String> secondPartyInstitute;
        private Long finalCost;
        private String currency;
        private String subject;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AgreementSpecRs")
    public static class CourseSpecRs {
        private AgreementDTO.SpecRs response;
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
