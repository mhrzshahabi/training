
package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Entity
@Immutable
@EqualsAndHashCode(of = {"personnelId", "courseId"}, callSuper = false)
@Table(name = "view_personnel_course_not_passed_report")
@DiscriminatorValue("PersonnelCourseNotPassedReportView")
public class PersonnelCourseNotPassedReportView implements Serializable {

    ///////////////////////////////////////////////////personnel///////////////////////////////////////
    @Id
    @Column(name = "personnel_id")
    private long personnelId;

    @Column(name = "personnel_personnel_no")
    private String personnelPersonnelNo;

    @Column(name = "personnel_first_name")
    private String personnelFirstName;

    @Column(name = "personnel_last_name")
    private String personnelLastName;

    @Column(name = "personnel_national_code")
    private String personnelNationalCode;

    @Column(name = "personnel_post_title")
    private String personnelPostTitle;

    @Column(name = "personnel_post_code")
    private String personnelPostCode;

    @Column(name = "personnel_complex_title")
    private String personnelComplexTitle;

    @Column(name = "personnel_education_level_title")
    private String personnelEducationLevelTitle;

    @Column(name = "personnel_job_no")
    private String personnelJobNo;

    @Column(name = "personnel_job_title")
    private String personnelJobTitle;

    @Column(name = "personnel_company_name")
    private String personnelCompanyName;

    @Column(name = "personnel_emp_no")
    private String personnelPersonnelNo2;

    @Column(name = "personnel_post_grade_title")
    private String personnelPostGradeTitle;

    @Column(name = "personnel_post_grade_code")
    private String personnelPostGradeCode;

    @Column(name = "personnel_cpp_code")
    private String personnelCcpCode;

    @Column(name = "personnel_cpp_area")
    private String personnelCcpArea;

    @Column(name = "personnel_cpp_assistant")
    private String personnelCcpAssistant;

    @Column(name = "personnel_cpp_affairs")
    private String personnelCcpAffairs;

    @Column(name = "personnel_cpp_section")
    private String personnelCcpSection;

    @Column(name = "personnel_cpp_unit")
    private String personnelCcpUnit;

    @Column(name = "personnel_cpp_title")
    private String personnelCcpTitle;

    ///////////////////////////////////////////////////course///////////////////////////////////////
    @Id
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

}
