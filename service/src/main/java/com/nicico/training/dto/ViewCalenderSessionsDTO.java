package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.List;
@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class ViewCalenderSessionsDTO implements Serializable {
//    @ApiModelProperty
//    private Long id;

    @ApiModelProperty
    private String classCode;

    @ApiModelProperty
    private String sessionDay;
    @ApiModelProperty
   private String sessionDate;
    @ApiModelProperty
    private Long  calenderId;
    @ApiModelProperty
    private String sessionStartHour;

    @ApiModelProperty
    private String sessionEndHour;
    @ApiModelProperty
    private String  courseCode;

    @ApiModelProperty
    private String  courseName;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCalenderSessionsDTOInfo")
    public static class Info extends ViewCalenderSessionsDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewCalenderSessionsSpecRs")
    public static class ViewCalenderSessionsSpecRs {
        private ViewCalenderSessionsDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewCalenderSessionsDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
