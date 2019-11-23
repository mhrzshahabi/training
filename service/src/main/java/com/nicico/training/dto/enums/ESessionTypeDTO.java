package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ESessionType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ESessionTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ESessionTypeSpecRs")
    public static class ESessionTypeSpecRs {
        private ESessionTypeDTO.SpecRs response = new ESessionTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ESessionType[] data = ESessionType.values();
        private Integer startRow = 0;
        private Integer endRow = ESessionType.values().length;
        private Integer totalRows = ESessionType.values().length;
    }
}
