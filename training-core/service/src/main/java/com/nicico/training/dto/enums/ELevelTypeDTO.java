package com.nicico.training.dto.enums;/* com.nicico.training.dto
@Author:jafari-h
@Date:6/10/2019
@Time:9:50 AM
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ELevelType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ELevelTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ELevelTypeSpecRs")
    public static class ELevelTypeSpecRs {
        private ELevelTypeDTO.SpecRs response = new ELevelTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ELevelType[] data = ELevelType.values();
        private Integer startRow = 0;
        private Integer endRow = ELevelType.values().length;
        private Integer totalRows = ELevelType.values().length;
    }

}
