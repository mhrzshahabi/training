package com.nicico.training.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;


@Getter
@Setter
@Accessors(chain = true)
public class TimeInterferenceComprehensiveClassesDTO implements Serializable {

    private Long id;
    private Integer countTimeInterference;
    private String studentFullName;
    private String nationalCode;
    private String studentWorkCode;
    private String studentAffairs;
    private String concurrentCourses;
    private String classCode;
    private String addingUser;
    private String lastModifiedBy;
    private String sessionDate;
    private String sessionStartHour;
    private String sessionEndHour;
    private Long session_id;
    private Long student_id;
    private String class_student_d_created_date;
    private String class_student_d_last_modified_date;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TimeInterferenceComprehensiveClassesDTOInfo")
    public static class Info extends TimeInterferenceComprehensiveClassesDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TimeInterferenceComprehensiveClassesDTODTOSpecRs")
    public static class TimeInterferenceComprehensiveClassesDTOSpecRs {
        private  TimeInterferenceComprehensiveClassesDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List< TimeInterferenceComprehensiveClassesDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
