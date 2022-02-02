package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EPublicationSubjectType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EPublicationSubjectTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EPublicationSubjectTypeSpecRs")
    public static class EPublicationSubjectTypeSpecRs {
        private EPublicationSubjectTypeDTO.SpecRs response = new EPublicationSubjectTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EPublicationSubjectType[] data = EPublicationSubjectType.values();
        private Integer startRow = 0;
        private Integer endRow = EPublicationSubjectType.values().length;
        private Integer totalRows = EPublicationSubjectType.values().length;
    }

    @Getter
    @Setter
    @ApiModel("EPublicationSubjectTypeInfoTuple")
    public static class EPublicationSubjectTypeInfoTuple {
        private String titleFa;
    }
}