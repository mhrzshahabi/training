
package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_course_passed_or_not_passed_na_report")
public class PersonnelCoursePassedOrNotPaseedNAReportView implements Serializable {


    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "is_passed")
    private Long isPassed;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////



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


    @Column(name = "personnel_company_name")
    private String personnelCompanyName;

    @Column(name = "personnel_emp_no")
    private String personnelPersonnelNo2;

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


    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

}
