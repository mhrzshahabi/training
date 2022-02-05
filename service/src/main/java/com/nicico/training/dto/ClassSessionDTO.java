package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.util.date.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ClassSessionDTO implements Serializable {
    @ApiModelProperty(required = true)
    private Long classId;
    @ApiModelProperty(required = true)
    private String dayCode;
    @ApiModelProperty(required = true)
    private String dayName;
    @ApiModelProperty(required = true)
    private String sessionDate;
    @ApiModelProperty(required = true)
    private String sessionStartHour;
    @ApiModelProperty(required = true)
    private String sessionEndHour;
    @ApiModelProperty(required = true)
    private Integer SessionTypeId;
    @ApiModelProperty(required = true)
    private String sessionType;
    @ApiModelProperty(required = true)
    private Integer instituteId;
    @ApiModelProperty(required = true)
    private Integer trainingPlaceId;
    @ApiModelProperty(required = true)
    private Long teacherId;
    @ApiModelProperty(required = true)
    private Integer sessionState;
    @ApiModelProperty(required = true)
    private String sessionStateFa;
    @ApiModelProperty(required = true)
    private Boolean teacherAttendancePermission;
    @ApiModelProperty(required = true)
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsInfo")
    @EqualsAndHashCode(of = {"id"}, callSuper = false)
    public static class Info extends ClassSessionDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private InstituteDTO.InstituteTitle institute;
        private TrainingPlaceDTO.TrainingPlaceTitle trainingPlace;
        private TeacherDTO.TeacherFullNameTuple teacher;
        @Getter(AccessLevel.NONE)
        private boolean readOnly;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else
                return " ";
        }

        public boolean getReadOnly() {
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date();
            String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));
            String startingDate = getSessionDate();

            return todayDate.compareTo(startingDate) >= 0 ? false : true;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassSessionsDetail")
    public static class TClassSessionsDetail {
        private String classCode;
        private String courseCode;
        private String courseTitleFa;
        private Long group;
        private String sessionDate;
        private String sessionStartHour;
        private String sessionEndHour;
        private Long studentsCount;
        private TeacherDTO.TeacherInfo teacherInfo;
        private String supervisorName;
        private String plannerName;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionWeeklySchedule")
    public static class WeeklySchedule {
        private Long id;
        private TclassDTO.WeeklySchedule tclass;
        private String sessionDate;
        private String dayName;
        private String sessionHour;
        private Integer sessionState;
        private String sessionStateFa;
        private String sessionStartHour;
        private String sessionEndHour;
        private String studentStatus;
        private String studentPresentStatus;

        public String getSessionHour() {
            String result = "";
            if (sessionStartHour != null) {
                result += sessionStartHour;
            }
            if (sessionEndHour != null) {
                result += " تا ";
                result += sessionEndHour;
            }
            return result;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassSessionWeeklyScheduleSpecRs")
    public static class ClassSessionWeeklyScheduleSpecRs {
        private WeeklyScheduleSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class WeeklyScheduleSpecRs {
        private List<ClassSessionDTO.WeeklySchedule> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    public static class DeleteStatus {
        private Integer sucesses;
        private Integer totalSizes;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsCreateRq")
    public static class Create extends ClassSessionDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsUpdateRq")
    public static class Update extends ClassSessionDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsIdListRq")
    public static class ClassSessionsIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsDateForOneClass")
    public static class ClassSessionsDateForOneClass {
        private String dayName;
        private String sessionDate;
        private String hasWarning = "";
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceClearForm")
    public static class AttendanceClearForm {
        private String dayName;
        private String sessionDate;
        private String sessionStartHour;
        private String sessionEndHour;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassSessionsSpecRs")
    public static class ClassSessionsSpecRs {
        private ClassSessionDTO.SpecRs response;
    }

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
        @NotNull
        @ApiModelProperty(required = true)
        private Boolean teacherAttendancePermission = true;
    }

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
        private String dayName;
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
        private String sessionType;
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
        private String sessionStateFa;
        @NotNull
        @ApiModelProperty(required = true)
        private String description;
        @NotNull
        @ApiModelProperty(required = true)
        private Boolean teacherAttendancePermission = true;
    }

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
        private String sessionStartHour;
        @NotNull
        @ApiModelProperty(required = true)
        private String sessionEndHour;
        @NotNull
        @ApiModelProperty(required = true)
        private Integer sessionTypeId;
        @NotNull
        @ApiModelProperty(required = true)
        private String sessionType;
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
        private String sessionStateFa;
        @NotNull
        @ApiModelProperty(required = true)
        private String description;
        @NotNull
        @ApiModelProperty(required = true)
        private Boolean teacherAttendancePermission = true;
    }
}
