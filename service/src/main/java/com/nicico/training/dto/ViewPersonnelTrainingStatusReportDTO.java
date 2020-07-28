package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ViewPersonnelTrainingStatusReportDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewPersonnelTrainingStatusReportInfo")
    public static class Info extends ViewPersonnelTrainingStatusReportDTO{
        private Long id;
    }
}
