/*
ghazanfari_f, 9/7/2019, 10:50 AM
*/
package com.nicico.training.dto;

import com.nicico.training.model.enums.ECompetenceInputType;
import com.nicico.training.model.enums.ETechnicalType;
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
public class CompetenceDTOOld implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer etechnicalTypeId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer ecompetenceInputTypeId;

    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceOld - Create")
    public static class Create extends CompetenceDTOOld {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceOld - Update")
    public static class Update extends CompetenceDTOOld {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceOld - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceOld - Info")
    public static class Info extends CompetenceDTOOld {
        private Long id;
        private ETechnicalType eTechnicalType;
        private ECompetenceInputType eCompetenceInputType;
    }
}
