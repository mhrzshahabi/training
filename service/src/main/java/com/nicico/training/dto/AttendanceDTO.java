package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Student;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AttendanceDTO {
    private String description;
    private String state;

    public String statusName(int status) {
        switch (status) {
            case 0:
                return "نامشخص";
            case 1:
                return "حاضر";
            case 2:
                return "حاضر و اضافه کار";
            case 3:
                return "غیبت غیرموجه";
            case 4:
                return "غیبت موجه";
        }
        return new String();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceInfo")
    public static class Info extends AttendanceDTO {
        @Getter(AccessLevel.NONE)
        private Student student;
        @Getter(AccessLevel.NONE)
        private String studentName;
        @Getter(AccessLevel.NONE)
        private String studentFamily;
        @Getter(AccessLevel.NONE)
        private String nationalCode;
        private Long sessionId;
        private Long studentId;
        @Getter(AccessLevel.NONE)
        private ClassSession session;

        public String getStudentName() {
            return student.getFirstName();
        }

        public String getStudentFamily() {
            return student.getLastName();
        }

        public String getNationalCode() {
            return student.getNationalCode();
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceCreateRq")
    public static class Create extends AttendanceDTO {
        private Long tclassId;
        private Long studentId;
        private Long sessionId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceUpdateRq")
    public static class Update extends AttendanceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceDeleteRq")
    public static class permissionDto {
        private String date;
        private boolean hasPermission;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceDtoWithUnSavedData")
    public static class AttendanceDtoWithUnSavedData {
        private List<String> date;
        private Boolean status;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AttendanceSpecRs")
    public static class AttendanceSpecRs {
        private AttendanceDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

