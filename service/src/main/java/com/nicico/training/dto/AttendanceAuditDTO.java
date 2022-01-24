package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.util.Date;

@Getter
@Setter
public class AttendanceAuditDTO {
    @ApiModelProperty
    private long sessionId;
    @ApiModelProperty
    private long studentId;
    @ApiModelProperty
    private String state;
    @ApiModelProperty
    private String description;
    @ApiModelProperty
    protected Date createdDate;
    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @ApiModelProperty
    private Date lastModifiedDate;

    @ApiModelProperty
    private String lastModifiedBy;

    @ApiModelProperty
    private Long revType;

    @ApiModelProperty
    private Long deleted;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceAudit - Info")
    public static class Info extends AttendanceAuditDTO {
        private Long id;
        private  ClassSessionDTO session;
    }

}
