package com.nicico.training.dto;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)

public class TrainingPlaceDTO {


    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer capacity;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer eplaceTypeId;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer earrangementTypeId;

    @ApiModelProperty(required = true)
    private String description;

    // ------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceInfo")
    public static class Info extends TrainingPlaceDTO {

        private Long id;
//        private InstituteDTO.Info institute;
        private EPlaceType ePlaceType;
        private EArrangementType eArrangementType;

    }
    //-------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceCreateRq")
    public static class Create extends TrainingPlaceDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long instituteId;

        Set<Long> equipmentIds;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceUpdateRq")
    public static class Update extends TrainingPlaceDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPlaceDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingPlaceSpecRs")
    public static class TrainingPlaceSpecRs {
        private TrainingPlaceDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TrainingPlaceDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //----------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class TrainingPlaceTitle {
        private Long id;
        private String titleFa;

    }

    //----------------------




}
