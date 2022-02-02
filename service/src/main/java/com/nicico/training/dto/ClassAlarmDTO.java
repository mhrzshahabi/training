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
public class ClassAlarmDTO implements Serializable {
    @ApiModelProperty(required = true)
    private String alarmTypeTitleFa;
    @ApiModelProperty(required = true)
    private String alarmTypeTitleEn;
    private Long classId;
    private Long sessionId;
    private Long teacherId;
    private Long studentId;
    private Long instituteId;
    private Long trainingPlaceId;
    private Long reservationId;
    private Long targetRecordId;
    private String tabName;
    private String pageAddress;
    @ApiModelProperty(required = true)
    private String alarm;
    private Long detailRecordId;
    private String sortField;
    private Long classIdConflict;
    private Long sessionIdConflict;
    private Long instituteIdConflict;
    private Long trainingPlaceIdConflict;
    private Long reservationIdConflict;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassAlarmInfo")
    public static class Info extends ClassAlarmDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassAlarmCreate")
    @AllArgsConstructor
    public static class Create extends ClassAlarmDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassAlarmSpecRs")
    public static class ClassAlarmSpecRs {
        private ClassAlarmDTO.SpecRs response;
    }

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

}