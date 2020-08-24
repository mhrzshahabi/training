package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.enums.EArrangementType;
import com.nicico.training.model.enums.EPlaceType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class TrainingPostDTO {

    @ApiModelProperty(required = true)
    private String code;

    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty()
    private String peopleType;

    @ApiModelProperty()
    private Long departmentId;

    @ApiModelProperty()
    private Long jobId;

    @ApiModelProperty()
    private Long postGradeId;

    @ApiModelProperty()
    private Long enabled;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPostInfo")
    public static class Info extends TrainingPostDTO {
        private Long id;

        private String code;
        private String titleFa;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
        private String area;
        private String assistance;
        private String affairs;
        private String section;
        private String unit;
        private String costCenterCode;
        private String costCenterTitleFa;
        private String peopleType;
        private Long enabled;

    }

    //-------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupCreateRq")
    public static class Create extends TrainingPostDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupCreateRq")
    public static class Update extends Create {
        private Long id;
        private Integer version;
    }

    // ------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingPostSpecRs")
    public static class TrainingPostSpecRs {
        private TrainingPostDTO.SpecRs response;
    }

    // ---------------

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
}
