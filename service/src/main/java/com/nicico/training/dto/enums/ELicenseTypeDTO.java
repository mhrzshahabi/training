package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ELicenseType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ELicenseTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ELicenseTypeSpecRs")
    public static class ELicenseTypeSpecRs {
        private ELicenseTypeDTO.SpecRs response = new ELicenseTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ELicenseType[] data = ELicenseType.values();
        private Integer startRow = 0;
        private Integer endRow = ELicenseType.values().length;
        private Integer totalRows = ELicenseType.values().length;
    }

    @Getter
    @Setter
    @ApiModel("ELicenseTypeInfoTuple")
    public static class ELicenseTypeInfoTuple {
        private String titleFa;
    }
}