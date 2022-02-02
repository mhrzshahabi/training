package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ETeacherAttachmentType;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ETeacherAttachmentTypeDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ETeacherAttachmentTypeSpecRs")
    public static class ETeacherAttachmentTypeSpecRs {
        private ETeacherAttachmentTypeDTO.SpecRs response = new ETeacherAttachmentTypeDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private ETeacherAttachmentType[] data = ETeacherAttachmentType.values();
        private Integer startRow = 0;
        private Integer endRow = ETeacherAttachmentType.values().length;
        private Integer totalRows = ETeacherAttachmentType.values().length;
    }
}