package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseNaKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("SELECT * from VIEW_PERSONNEL_COURSE_NA_REPORT")

public class ViewPersonnelCourseNaReport implements Serializable {
    @EmbeddedId
    private PersonnelCourseNaKey id;

    //personnel_personnel_no

    @Column(name = "na_priority_id")
    private String priorityId;

    @Column(name = "personnel_emp_no")
    private String empNo;

    @Column(name = "personnel_personnel_no")
    private String personnelNo;

    @Column(name = "personnel_national_code")
    private String nationalCode;

    @Column(name = "personnel_first_name")
    private String firstName;

    @Column(name = "personnel_last_name")
    private String lastName;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "personnel_post_grade_code")
    private String postGradeCode;

    @Column(name = "personnel_cpp_affairs")
    private String affairs;

    @Column(name = "personnel_education_level_title")
    private String educationLevelTitle;

    @Column(name = "personnel_cpp_area")
    private String area;

    @Column(name = "personnel_cpp_assistant")
    private String assistant;

    @Column(name = "personnel_cpp_code")
    private String ccpCode;

    @Column(name = "personnel_cpp_title")
    private String ccpTitle;

    @Column(name = "personnel_cpp_section")
    private String section;

    @Column(name = "personnel_cpp_unit")
    private String unit;

    @Column(name = "personnel_company_name")
    private String companyName;

    @Column(name = "personnel_complex_title")
    private String complexTitle;

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "personnel_id", insertable = false, updatable = false)
    private Long personnelId;

    @Column(name = "personnel_job_no")
    private String jobNo;

    @Column(name = "personnel_job_title")
    private String jobTitle;

    @Column(name = "personnel_post_code")
    private String postCode;

    @Column(name = "personnel_post_grade_title")
    private String postGradeTitle;

    @Column(name = "personnel_post_title")
    private String postTitle;

    @Column(name = "personnel_post_id")
    private Long postId;

    @Column(name = "personnel_post_grade_id")
    private Long postGradeId;
}