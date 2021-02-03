
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@Entity
@Subselect("select * from view_student_classstudent_class_term_course")
public class StudentClassReportView implements Serializable {

//    ///////////////////////////////////////////////////student///////////////////////////////////////
//    @Column(name = "student_id")
//    private Long studentId;
//
//    @Column(name = "student_personnel_no")
//    private String studentPersonnelNo;
//
//    @Column(name = "student_first_name")
//    private String studentFirstName;
//
//    @Column(name = "student_last_name")
//    private String studentLastName;
//
//    @Column(name = "student_national_code")
//    private String studentNationalCode;
//
//    @Column(name = "student_active")
//    private Integer studentActive;
//
//    @Column(name = "student_post_title")
//    private String studentPostTitle;
//
//    @Column(name = "student_post_code")
//    private String studentPostCode;
//
//    @Column(name = "student_complex_title")
//    private String studentComplexTitle;
//
//    @Column(name = "student_education_level_title")
//    private String studentEducationLevelTitle;
//
//    @Column(name = "student_job_no")
//    private String studentJobNo;
//
//    @Column(name = "student_job_title")
//    private String studentJobTitle;
//
//    @Column(name = "student_company_name")
//    private String studentCompanyName;
//
//    @Column(name = "student_emp_no")
//    private String studentPersonnelNo2;
//
//    @Column(name = "student_post_grade_title")
//    private String studentPostGradeTitle;
//
//    @Column(name = "student_post_grade_code")
//    private String studentPostGradeCode;
//
//    @Column(name = "student_cpp_code")
//    private String studentCcpCode;
//
//    @Column(name = "student_cpp_area")
//    private String studentCcpArea;
//
//    @Column(name = "student_cpp_assistant")
//    private String studentCcpAssistant;
//
//    @Column(name = "student_cpp_affairs")
//    private String studentCcpAffairs;
//
//    @Column(name = "student_cpp_section")
//    private String studentCcpSection;
//
//    @Column(name = "student_cpp_unit")
//    private String studentCcpUnit;
//
//    @Column(name = "student_cpp_title")
//    private String studentCcpTitle;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////
    @Column(name = "personnel_id")
    private Long studentId;

    @Column(name = "personnel_personnel_no")
    private String studentPersonnelNo;

    @Column(name = "personnel_first_name")
    private String studentFirstName;

    @Column(name = "personnel_last_name")
    private String studentLastName;

    @Column(name = "personnel_national_code")
    private String studentNationalCode;

    @Column(name = "personnel_active")
    private Integer studentActive;

    @Column(name = "personnel_post_title")
    private String studentPostTitle;

    @Column(name = "personnel_post_code")
    private String studentPostCode;

    @Column(name = "personnel_complex_title")
    private String studentComplexTitle;

    @Column(name = "personnel_education_level_title")
    private String studentEducationLevelTitle;

    @Column(name = "personnel_job_no")
    private String studentJobNo;

    @Column(name = "personnel_job_title")
    private String studentJobTitle;

    @Column(name = "personnel_company_name")
    private String studentCompanyName;

    @Column(name = "personnel_emp_no")
    private String studentPersonnelNo2;

    @Column(name = "personnel_post_grade_title")
    private String studentPostGradeTitle;

    @Column(name = "personnel_post_grade_code")
    private String studentPostGradeCode;

    @Column(name = "personnel_cpp_code")
    private String studentCcpCode;

    @Column(name = "personnel_cpp_area")
    private String studentCcpArea;

    @Column(name = "personnel_cpp_assistant")
    private String studentCcpAssistant;

    @Column(name = "personnel_cpp_affairs")
    private String studentCcpAffairs;

    @Column(name = "personnel_cpp_section")
    private String studentCcpSection;

    @Column(name = "personnel_cpp_unit")
    private String studentCcpUnit;

    @Column(name = "personnel_cpp_title")
    private String studentCcpTitle;

    ///////////////////////////////////////////////////term///////////////////////////////////////
    @Column(name = "term_id")
    private Long termId;

    @Column(name = "term_code")
    private String termCode;

    @Column(name = "term_title_fa")
    private String termTitleFa;

    ///////////////////////////////////////////////////classStudent///////////////////////////////////////
    @Id
    @Column(name = "class_student_id")
    private Long classStudentId;

    @Column(name = "class_student_scores_state_id")
    private Long classStudentScoresState;

    @Column(name = "class_student_failure_reason_id")
    private Long classStudentFailureReason;

    @Column(name = "class_student_score")
    private Float classStudentScore;

    @Column(name = "class_student_applicant_company_name")
    private String classStudentApplicantCompanyName;

    @Column(name = "class_student_presence_type_id")
    private Long classStudentPresenceTypeId;

    ///////////////////////////////////////////////////class///////////////////////////////////////
    @Column(name = "class_id")
    private long classId;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_h_duration")
    private Long classHDuration;

    @Column(name = "class_d_duration")
    private Long classDDuration;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_title_class")
    private String classTitle;

    @Column(name = "class_group")
    private Long classGroup;

    ///////////////////////////////////////////////////course///////////////////////////////////////
    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    ///////////////////////////////////////////////////category///////////////////////////////////////
    @Column(name = "category_id")
    private Long categoryId;

    @Column(name = "category_title_fa")
    private String categoryTitleFa;

    @Column(name = "category_code")
    private String categoryCode;

    @Column(name = "planner_complex")
    private String plannerComplex;

    @Column(name = "planner_name")
    private String plannerName;

    @Column(name = "institute_name")
    private String instituteName;
}
