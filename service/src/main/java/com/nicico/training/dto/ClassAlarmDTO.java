package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
public class ClassAlarmDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long targetRecordId; //target_record_id

    @ApiModelProperty(required = true)
    private String tabName; //tab_name

    @ApiModelProperty(required = true)
    private String pageAddress; //page_address

    @ApiModelProperty(required = true)
    private String alarmType; //alarm_type

    @ApiModelProperty(required = true)
    private String alarm; //alarm

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassAlarmSpecRs")
    public static class ClassAlarmSpecRs {
        private ClassAlarmDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassAlarmDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //*********************************

}