package com.nicico.training.dto.enums;/* com.nicico.training.dto*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EInstituteType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class EInstituteTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EInstituteTypeSpecRs")
    public static class EInstituteTypeSpecRs {
        private EInstituteTypeDTO.SpecRs response = new EInstituteTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EInstituteType[] data = EInstituteType.values();
        private Integer startRow=0;
        private Integer endRow= EInstituteType.values().length;
        private Integer totalRows = EInstituteType.values().length;
    }



}