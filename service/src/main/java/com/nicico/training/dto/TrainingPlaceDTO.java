package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EArrangementType;
import com.nicico.training.model.enums.EPlaceType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class TrainingPlaceDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String capacity;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer eplaceTypeId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer earrangementTypeId;
    @ApiModelProperty(required = true)
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceInfo")
    public static class Info extends TrainingPlaceDTO {
        private Long id;
        private InstituteDTO.InstituteTitle institute;
        private EPlaceType ePlaceType;
        private EArrangementType eArrangementType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceCreateRq")
    public static class Create extends TrainingPlaceDTO {
        Set<Long> equipmentIds;
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long instituteId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceUpdateRq")
    public static class Update extends TrainingPlaceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingPlaceSpecRs")
    public static class TrainingPlaceSpecRs {
        private TrainingPlaceDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class TrainingPlaceTitle {
        private Long id;
        private String titleFa;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class TrainingPlaceWithInstitute {
        private Long id;
        private Long instituteId;
        private String capacity;
        private String titleFa;
        private String instituteTitleFa;
    }
}
