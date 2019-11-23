package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ESessionTime;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ESessionTimeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ESessionTimeSpecRs")
    public static class ESessionTimeSpecRs {
        private ESessionTimeDTO.SpecRs response = new ESessionTimeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ESessionTime[] data = ESessionTime.values();
        private Integer startRow = 0;
        private Integer endRow = ESessionTime.values().length;
        private Integer totalRows = ESessionTime.values().length;
    }

}
