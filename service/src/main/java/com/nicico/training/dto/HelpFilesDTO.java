package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class HelpFilesDTO implements Serializable {
    private String fileName;
    private String description;
    private String group_id;
    private String key;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("HelpFiles - Info")
    public static class Info extends HelpFilesDTO {
        private Long id;
        private Set<FileLabelDTO.Info> fileLabels;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("HelpFiles - Create")
    public static class Create extends HelpFilesDTO {
        private Set<Long> fileLabels;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("HelpFiles - Update")
    public static class Update {
        private Long id;
        private String description;
        private Set<Long> fileLabels;
    }
}
