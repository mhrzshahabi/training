package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)


public class PersonnelDurationNAReportDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info extends PersonnelDurationNAReportDTO {

        private long personnelId;
        private Float duration;
        private Float passed;
        private Float essential;
        private Float essentialPassed;
        private Float improving;
        private Float improvingPassed;
        private Float developmental;
        private Float developmentalPassed;
    }
}
