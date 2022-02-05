package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
@Accessors(chain = true)
public class ClassContractCostDTO {
    private Long teacherCostPerHour;
    private Long classId;
    private Long classContractId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info extends ClassContractCostDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        private TclassDTO.Info tclass;
    }
}

