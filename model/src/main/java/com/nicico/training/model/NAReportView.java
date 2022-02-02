package com.nicico.training.model;

import com.nicico.training.model.compositeKey.NASkillKey;
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
@EqualsAndHashCode(of = {"NAId", "skillId"}, callSuper = false)
@Entity
@Subselect("select * from view_na_report")
public class NAReportView implements Serializable {

    @EmbeddedId
    private NASkillKey id;

    ////////////////////////////////////////////////////NA/////////////////////////////////////////////

    @Column(name = "na_id", insertable = false, updatable = false)
    private Long NAId;

    @Column(name = "na_priority_id")
    private Long NAPriorityId;

    @Column(name = "na_domain_id")
    private Long NADomainId;

    ////////////////////////////////////////////////////competence/////////////////////////////////////////////

    @Column(name = "competence_id")
    private Long competenceId;

    @Column(name = "competence_title")
    private String competenceTitle;

    @Column(name = "competence_type_id")
    private Long competenceTypeId;

    ////////////////////////////////////////////////////skill/////////////////////////////////////////////

    @Column(name = "skill_id", insertable = false, updatable = false)
    private Long skillId;

    @Column(name = "skill_code")
    private String skillCode;

    @Column(name = "skill_title_fa")
    private String skillTitleFa;

    ///////////////////////////////////////////////////course///////////////////////////////////////

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    ///////////////////////////////////////////////////post///////////////////////////////////////

    @Column(name = "post_id")
    private Long postId;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "post_fa")
    private String postTitleFa;

    @Column(name = "post_cost_center_title")
    private String postCostCenterTitle;

    @Column(name = "post_area")
    private String postArea;

    @Column(name = "post_assistant")
    private String postAssistant;

    @Column(name = "post_affairs")
    private String postAffairs;

    @Column(name = "post_section")
    private String postSection;

    @Column(name = "post_unit")
    private String postUnit;

    @Column(name = "post_cost_center_code_title")
    private String postCostCenterCode;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////

    @Column(name = "personnel_id")
    private long personnelId;

    @Column(name = "personnel_active")
    private Boolean personnelActive;

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

    ///////////////////////////////////////////////////postGroup///////////////////////////////////////

    @Column(name = "post_group_id")
    private Long postGroupId;

    @Column(name = "post_group_title_fa")
    private String postGroupTitleFa;

    ///////////////////////////////////////////////////job///////////////////////////////////////

    @Column(name = "job_id")
    private Long jobId;

    @Column(name = "job_code")
    private String jobCode;

    @Column(name = "job_title_fa")
    private String jobTitleFa;

    ///////////////////////////////////////////////////jobGroup///////////////////////////////////////

    @Column(name = "job_group_id")
    private Long jobGroupId;

    @Column(name = "job_group_title_fa")
    private String jobGroupTitleFa;

    ///////////////////////////////////////////////////postGrade///////////////////////////////////////

    @Column(name = "post_grade_id")
    private Long postGradeId;

    @Column(name = "post_grade_code")
    private String postGradeCode;

    @Column(name = "post_grade_title_fa")
    private String postGradeTitleFa;

    ///////////////////////////////////////////////////postGradeGroup///////////////////////////////////////

    @Column(name = "post_grade_group_id")
    private Long postGradeGroupId;

    @Column(name = "post_grade_group_title_fa")
    private String postGradeGroupTitleFa;
}
