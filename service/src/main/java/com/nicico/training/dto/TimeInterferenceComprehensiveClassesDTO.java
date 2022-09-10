package com.nicico.training.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;



@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
public class TimeInterferenceComprehensiveClassesDTO {

    private Integer count_TimeInterference;
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

    public TimeInterferenceComprehensiveClassesDTO() {

    }

//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @JsonInclude(JsonInclude.Include.NON_NULL)
//    public static class SpecRs {
//        private List<TimeInterferenceComprehensiveClassesDTO> data;
//        private Integer status;
//        private Integer startRow;
//        private Integer endRow;
//        private Integer totalRows;
//    }


}
