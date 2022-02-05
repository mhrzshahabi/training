package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AttachmentDTO {
    private String fileName;
    private Long fileTypeId;
    private String description;
    private Long objectId;
    private String objectType;
    private String key;
    private String group_id;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Attachment")
    public static class Info extends AttachmentDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttachmentCreateRq")
    public static class Create extends AttachmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttachmentUpdateRq")
    public static class Update extends AttachmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttachmentDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}

