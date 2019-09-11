/*
ghazanfari_f, 9/7/2019, 10:50 AM
*/
package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class CompetenceDTO implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence - Create")
    public static class Create extends CompetenceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence - Update")
    public static class Update extends CompetenceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence - Info")
    public static class Info extends CompetenceDTO {
        private Long id;
        private String titleFa;
        private String titleEn;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence - Info")
    public static class MinInfo extends CompetenceDTO {
        private Long id;
        private String titleFa;
    }
}
