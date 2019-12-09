package com.nicico.training.dto.enums;/* com.nicico.training.dto
@Author:jafari-h
@Date:6/10/2019
@Time:10:06 AM
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ETechnicalType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)

public class ETechnicalTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ETechnicalTypeSpecRs")
    public static class ETechnicalTypeSpecRs {
        private ETechnicalTypeDTO.SpecRs response = new ETechnicalTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ETechnicalType[] data = ETechnicalType.values();
        private Integer startRow = 0;
        private Integer endRow = ETechnicalType.values().length;
        private Integer totalRows = ETechnicalType.values().length;
    }

}
