package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
public class CalenderCurrentTermDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Tclass")
    @AllArgsConstructor
    public static class tclass {
        private Long id;
        private String corseCode;
        private String titleClass;
        private String code;
        private String startDate;
        private String endDate;
        private Long hDuration;
        private String classStatus;
        private String statusRegister;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CalenderCurrentTermSpecRs")
    public static class CalenderCurrentTermSpecRs {
        private CalenderCurrentTermDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<tclass> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CalenderCurrentTermCourseInfo")
    public static class CourseInfo {
        private Long courseId;
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private TermDTO term;
        @Getter(AccessLevel.NONE)
        private TeacherDTO.TeacherFullNameTuple teacher;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else
                return " ";
        }
    }
}
