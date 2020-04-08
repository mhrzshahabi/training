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
@NoArgsConstructor
public class CalenderCurrentTermDTO implements Serializable {
  @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Tclass")
    @AllArgsConstructor
    public static class tclass {
        private String corseCode;
        private String titleClass;
        private String code;
        private String startDate;
        private String endDate;
        private Long hDuration;
        private String classStatus;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CalenderCurrentTermSpecRs")
    public static class  CalenderCurrentTermSpecRs {
        private  CalenderCurrentTermDTO.SpecRs response;
    }

     @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<tclass> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
