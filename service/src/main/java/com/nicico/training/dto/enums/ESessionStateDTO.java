package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ESessionState;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ESessionStateDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ESessionStateSpecRs")
    public static class ESessionStateSpecRs {
        private ESessionStateDTO.SpecRs response = new ESessionStateDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ESessionState[] data = ESessionState.values();
        private Integer startRow = 0;
        private Integer endRow = ESessionState.values().length;
        private Integer totalRows = ESessionState.values().length;
    }

}
