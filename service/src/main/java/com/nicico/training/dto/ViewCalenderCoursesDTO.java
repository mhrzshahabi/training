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
public class ViewCalenderCoursesDTO implements Serializable {

    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private Long  calenderId;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String mahalBarghozari;

    @ApiModelProperty
    private String nomreh;

    @ApiModelProperty
    private String hazinehDore;

    @ApiModelProperty
    private String nahveBargozari;

    @ApiModelProperty
    private String darkhastAmouzeshi;

    @ApiModelProperty
    private String tarikhBargozari;

    @ApiModelProperty
    private String modatDore;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCalenderCoursesDTOInfo")
    public static class Info extends ViewCalenderCoursesDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewCalenderCoursesSpecRs")
    public static class ViewCalenderCoursesSpecRs {
        private ViewCalenderCoursesDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewCalenderCoursesDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
