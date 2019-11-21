package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClassSessionDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long classId;

    @ApiModelProperty(required = true)
    private String dayCode;

    @ApiModelProperty(required = true)
    private String sessionDate;

    @ApiModelProperty(required = true)
    private String sessionStartHour;

    @ApiModelProperty(required = true)
    private String sessionEndHour;

    @ApiModelProperty(required = true)
    private Integer SessionTypeId;

    @ApiModelProperty(required = true)
    private Integer instituteId;

    @ApiModelProperty(required = true)
    private Integer trainingPlaceId;

    @ApiModelProperty(required = true)
    private Long teacherId;

    @ApiModelProperty(required = true)
    private Integer sessionState;

    @ApiModelProperty(required = true)
    private String description;

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsInfo")
    public static class Info extends ClassSessionDTO {
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
    @ApiModel("ClassSessionsCreateRq")
    public static class Create extends ClassSessionDTO {

    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsUpdateRq")
    public static class Update extends ClassSessionDTO {

    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsIdListRq")
    public static class ClassSessionsIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsSpecRs")
    public static class ClassSessionsSpecRs {
        private ClassSessionDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassSessionDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AutoSessionsRequirement")
    @AllArgsConstructor
    public static class AutoSessionsRequirement {

        @NotNull
        @ApiModelProperty(required = true)
        private Long classId;

        @NotNull
        @ApiModelProperty(required = true)
        private List<String> daysCode;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer trainingType;

        @NotNull
        @ApiModelProperty(required = true)
        private String classStartDate;

        @NotNull
        @ApiModelProperty(required = true)
        private String classEndDate;

        @NotNull
        @ApiModelProperty
        private List<Integer> classHoursRange;

        @ApiModelProperty(required = true)
        private Integer SessionTypeId;

        @ApiModelProperty(required = true)
        private Integer instituteId;

        @ApiModelProperty(required = true)
        private Integer trainingPlaceId;

        @ApiModelProperty(required = true)
        private Long teacherId;

        @ApiModelProperty(required = true)
        private Integer sessionState;

        @ApiModelProperty(required = true)
        private String description;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GeneratedSessions")
    @AllArgsConstructor
    @NoArgsConstructor
    public static class GeneratedSessions {

        @NotNull
        @ApiModelProperty(required = true)
        private Long classId;

        @NotNull
        @ApiModelProperty(required = true)
        private String dayCode;

        @NotNull
        @ApiModelProperty(required = true)
        private String sessionDate;

        @NotNull
        @ApiModelProperty(required = true)
        private String sessionStartHour;

        @NotNull
        @ApiModelProperty(required = true)
        private String sessionEndHour;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer SessionTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer instituteId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer trainingPlaceId;

        @NotNull
        @ApiModelProperty(required = true)
        private Long teacherId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer sessionState;

        @NotNull
        @ApiModelProperty(required = true)
        private String description;

    }

    //*********************************
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ManualSession")
    public static class ManualSession implements Serializable {

        @NotNull
        @ApiModelProperty(required = true)
        private Long classId;

        @NotNull
        @ApiModelProperty(required = true)
        private String sessionDate;

        @NotNull
        @ApiModelProperty(required = true)
        private String sessionTime;


        @NotNull
        @ApiModelProperty(required = true)
        private Integer sessionTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer instituteId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer trainingPlaceId;

        @NotNull
        @ApiModelProperty(required = true)
        private Long teacherId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer sessionState;

        @NotNull
        @ApiModelProperty(required = true)
        private String description;

    }

    //*********************************

}
