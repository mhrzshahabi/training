package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class TrainingOverTimeDTO implements Serializable {
    String personalNum;
    String personalNum2;
    String nationalCode;
    String name;
    String ccpArea;
    String classCode;
    String className;
    String date;
    String time;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingOverTimeInfo")
    public static class Info extends TrainingOverTimeDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingOverTimeSpecRs")
    public static class TrainingOverTimeSpecRs {
        private TrainingOverTimeDTO.SpecRs response;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TrainingOverTimeDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
