package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;
import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClassSessionsDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long idClass;

    @ApiModelProperty(required = true)
    private Integer dayCode;

    @ApiModelProperty(required = true)
    private String sessionDate;

    @ApiModelProperty(required = true)
    private String startHour;

    @ApiModelProperty(required = true)
    private String endHour;

    @ApiModelProperty(required = true)
    private Integer idSessionType;

    @ApiModelProperty(required = true)
    private Integer idLocation;

    @ApiModelProperty(required = true)
    private Long idTeacher;

    @ApiModelProperty(required = true)
    private Integer sessionState;

    @ApiModelProperty(required = true)
    private String description;

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsInfo")
    public static class Info extends ClassSessionsDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AutoSessionsRequirement")
    public static class AutoSessionsRequirement {

        @NotNull
        @ApiModelProperty(required = true)
        private List<Integer> daysCode;

        @NotNull
        @ApiModelProperty(required = true)
        private String trainingType;

        @NotNull
        @ApiModelProperty(required = true)
        private String startDate;

        @NotNull
        @ApiModelProperty(required = true)
        private String endDate;

        @NotNull
        @ApiModelProperty(required = true)
        private String startHour;

        @NotNull
        @ApiModelProperty(required = true)
        private String endHour;
    }

    //*********************************

}
