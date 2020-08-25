
package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseKey;
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
@Subselect("select * from view_personnel_course_passed_na_report")
public class PersonnelCoursePassedNAReportView implements Serializable {

    @EmbeddedId
    private PersonnelCourseKey id;

    @Column(name = "na_priority_id")
    private Long priorityId;

    @Column(name = "is_passed")
    private Long isPassed;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////

    @Column(name = "personnel_id", insertable = false, updatable = false)
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

    @Column(name = "personnel_post_grade_id")
    private Long postGradeId;

    ///////////////////////////////////////////////////course///////////////////////////////////////

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

}
