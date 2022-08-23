package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
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
public class ViewCalenderPrerequisiteDTO implements Serializable {
    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String classCode;

    @ApiModelProperty
    private String prerequisite;

    @ApiModelProperty
    private Long  calenderId;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCalenderPrerequisiteDTOInfo")
    public static class Info extends ViewCalenderPrerequisiteDTO{
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewCalenderPrerequisiteSpecRs")
    public static class ViewCalenderPrerequisiteSpecRs {
        private ViewCalenderPrerequisiteDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewCalenderPrerequisiteDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}


