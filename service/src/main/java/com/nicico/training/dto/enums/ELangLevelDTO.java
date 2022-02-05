package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ELangLevel;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ELangLevelDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ELangLevelSpecRs")
    public static class ELangLevelSpecRs {
        private ELangLevelDTO.SpecRs response = new ELangLevelDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ELangLevel[] data = ELangLevel.values();
        private Integer startRow = 0;
        private Integer endRow = ELangLevel.values().length;
        private Integer totalRows = ELangLevel.values().length;
    }

    @Getter
    @Setter
    @ApiModel("ELangLevelInfoTuple")
    public static class ELangLevelInfoTuple {
        private String titleFa;
    }
}