package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EClassAttachmentType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class EClassAttachmentTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EClassAttachmentTypeSpecRs")
    public static class EClassAttachmentTypeSpecRs {
        private EClassAttachmentTypeDTO.SpecRs response = new EClassAttachmentTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private EClassAttachmentType[] data = EClassAttachmentType.values();
        private Integer startRow = 0;
        private Integer endRow = EClassAttachmentType.values().length;
        private Integer totalRows = EClassAttachmentType.values().length;
    }
}