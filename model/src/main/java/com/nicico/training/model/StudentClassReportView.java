/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Getter
@Entity
@Immutable
@EqualsAndHashCode(of = {"classStudentId"}, callSuper = false)
@Table(name = "view_student_classstudent_class_term_course")
@DiscriminatorValue("StudentClassReportView")
public class StudentClassReportView extends Auditable {

    ///////////////////////////////////////////////////student///////////////////////////////////////
    @Column(name = "studentid", precision = 10)
    private Long studentId;

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

    @Column(name = "student_gob_title")
    private String studentJobTitle;

    @Column(name = "student_company_name")
    private String studentCompanyName;

    @Column(name = "student_emp_no")
    private String studentPersonnelNo2;

    @Column(name = "student_post_gtade_title")
    private String studentPostGradeTitle;

    @Column(name = "student_post_grade_code")
    private String studentPostGradeCode;

    @Column(name = "student_code")
    private String studentCcpCode;

    @Column(name = "student_area")
    private String studentCcpArea;

    @Column(name = "student_assistant")
    private String studentCcpAssistant;

    @Column(name = "student_affairs")
    private String studentCcpAffairs;

    @Column(name = "student_section")
    private String studentCcpSection;

    @Column(name = "student_unit")
    private String studentCcpUnit;

    @Column(name = "student_cpp_title")
    private String studentCcpTitle;

    ///////////////////////////////////////////////////term///////////////////////////////////////
    @Column(name = "termid")
    private Long termId;

    @Column(name = "term_code")
    private String termCode;

    @Column(name = "term_title_fa",nullable = false)
    private String termTitleFa;

    ///////////////////////////////////////////////////classStudent///////////////////////////////////////
    @Id
    @Column(name = "classstudentid")
    private Long classStudentId;

    @Column(name = "classstudent_scores_state")
    private String classStudentScoresState;

    @Column(name = "classstudent_failure_reason")
    private String classStudentFailureReason;

    @Column(name = "classstudent_score")
    private Float classStudentScore;

    @Column(name = "classstudent_applicant_company_name")
    private String classStudentApplicantCompanyName;

    @Column(name = "classstudent_presence_type_id")
    private Long classStudentPresenceTypeId;

    ///////////////////////////////////////////////////class///////////////////////////////////////
    @Column(name = "classid")
    private long classid;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_code", nullable = false)
    private String classCode;

    @Column(name = "class_h_duration")
    private Long classHDuration;

    @Column(name = "class_d_duration")
    private Long classDDuration;

    @Column(name = "class_start_date", nullable = false)
    private String classStartDate;

    @Column(name = "class_end_date", nullable = false)
    private String classEndDate;

    @Column(name = "class_title")
    private String classTitle;

    @Column(name = "class_group", nullable = false)
    private Long classGroup;

    ///////////////////////////////////////////////////course///////////////////////////////////////
    @Column(name = "courseid")
    private Long courseid;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title")
    private String courseTitle;

    ///////////////////////////////////////////////////category///////////////////////////////////////
    @Column(name = "categoryid")
    private Long categoryId;

    @Column(name = "category_title", nullable = false)
    private String categoryTitle;

    @Column(name = "category_code", length = 2, nullable = false, unique = true)
    private String categoryCode;

}
