package com.nicico.training.dto;

import com.nicico.training.model.ParameterValue;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

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

    @Getter(AccessLevel.NONE)
    private ParameterValue pEnabled;

    public ParameterValue getpEnabled() {
        return pEnabled;
    }


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
}
