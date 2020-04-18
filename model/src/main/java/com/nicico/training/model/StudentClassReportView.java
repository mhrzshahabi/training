
package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Entity
@Immutable
@EqualsAndHashCode(of = {"classStudentId"}, callSuper = false)
@Table(name = "view_student_classstudent_class_term_course")
@DiscriminatorValue("StudentClassReportView")
public class StudentClassReportView implements Serializable {

    ///////////////////////////////////////////////////student///////////////////////////////////////
    @Column(name = "student_id")
    private long studentId;

    @Column(name = "student_personnel_no")
    private String studentPersonnelNo;

    @Column(name = "student_first_name")
    private String studentFirstName;

    @Column(name = "student_last_name")
    private String studentLastName;

    @Column(name = "student_national_code")
    private String studentNationalCode;

    @Column(name = "student_active")
    private Integer studentActive;

    @Column(name = "student_post_title")
    private String studentPostTitle;

    @Column(name = "student_post_code")
    private String studentPostCode;

    @Column(name = "student_complex_title")
    private String studentComplexTitle;

    @Column(name = "student_education_level_title")
    private String studentEducationLevelTitle;

    @Column(name = "student_job_no")
    private String studentJobNo;

    @Column(name = "student_job_title")
    private String studentJobTitle;

    @Column(name = "student_company_name")
    private String studentCompanyName;

    @Column(name = "student_emp_no")
    private String studentPersonnelNo2;

    @Column(name = "student_post_grade_title")
    private String studentPostGradeTitle;

    @Column(name = "student_post_grade_code")
    private String studentPostGradeCode;

    @Column(name = "student_cpp_code")
    private String studentCcpCode;

    @Column(name = "student_cpp_area")
    private String studentCcpArea;

    @Column(name = "student_cpp_assistant")
    private String studentCcpAssistant;

    @Column(name = "student_cpp_affairs")
    private String studentCcpAffairs;

    @Column(name = "student_cpp_section")
    private String studentCcpSection;

    @Column(name = "student_cpp_unit")
    private String studentCcpUnit;

    @Column(name = "student_cpp_title")
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

    @Column(name = "class_student_scores_state")
    private String classStudentScoresState;

    @Column(name = "class_student_failure_reason")
    private String classStudentFailureReason;

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
    private Long courseid;

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

}
