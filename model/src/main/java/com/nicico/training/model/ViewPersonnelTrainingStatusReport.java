package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_Personnel_Training_Status_Report")
@DiscriminatorValue("ViewPersonnelTrainingStatusReport")
public class ViewPersonnelTrainingStatusReport {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "personnel_personnel_no")
    private String personnelNo;

    @Column(name = "personnel_national_code")
    private String personnelNationalCode;

    @Column(name = "personnel_first_name")
    private String personnelFirstName;

    @Column(name = "personnel_last_name")
    private String personnelLastName;

    @Column(name = "personnel_job_title")
    private String PersonnelJobTitle;

    @Column(name = "personnel_post_code")
    private String personnel_Post_code;

    @Column(name = "personnel_post_grade_code")
    private String personnelPostGradeCode;

    @Column(name = "personnel_post_grade_title")
    private String personnelPostGradeTitle;

    @Column(name = "personnel_post_title")
    private String personnelPostTitle;

    @Column(name = "personnel_cpp_affairs")
    private String personnelCppAffairs;

    @Column(name = "personnel_cpp_area")
    private String personnelCpp;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "skill_code")
    private String skillCode;

    @Column(name = "skill_title")
    private String skillTitle;

    @Column(name = "c_title")
    private String Title;

    @Column(name = "coursetype")
    private String courseType;

    @Column(name = "c_title1")
    private String title1;

}
