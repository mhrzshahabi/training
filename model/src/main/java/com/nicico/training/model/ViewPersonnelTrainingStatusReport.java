package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;

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

    @Column(name = "na_priority_id")
    private Long naPriorityId;

    @Column(name = "na_is_in_na")
    private Long naIsInNa;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_student_scores_state_id")
    private Long classStudentScoresStateId;

    @Column(name = "class_student_score")
    private Long classStudentScore;

    @Column(name = "class_id", insertable = false, updatable = false)
    private Long classId;

    @Column(name = "personnel_is_personnel")
    private Long personnelIsPersonnel;

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "personnel_personnel_no")
    private String personnelPersonnelNo;

    @Column(name = "personnel_first_name")
    private String personnelFirstName;

    @Column(name = "personnel_last_name")
    private String personnelLastName;

    @Column(name = "personnel_national_code")
    private String personnelNationalCode;

    @Column(name = "personnel_cpp_affairs")
    private String personnelCppAffairs;

    @Column(name = "personnel_cpp_area")
    private String personnelCppArea;

    @Column(name = "personnel_cpp_assistant")
    private String personnelCppAssistant;

    @Column(name = "personnel_cpp_code")
    private String personnelCppCode;

    @Column(name = "personnel_cpp_section")
    private String personnelCppSection;

    @Column(name = "personnel_cpp_title")
    private String personnelCppTitle;

    @Column(name = "personnel_cpp_unit")
    private String personnelCppUnit;

    @Column(name = "personnel_company_name")
    private String personnelCompanyName;

    @Column(name = "personnel_complex_title")
    private String personnelComplexTitle;

    @Column(name = "personnel_id", insertable = false, updatable = false)
    private Long personnelId;

    @Column(name = "personnel_job_no")
    private String personnelJobNo;

    @Column(name = "personnel_job_title")
    private String personnelJobTitle;

    @Column(name = "personnel_emp_no")
    private String personnelEmpNo;

    @Column(name = "personnel_post_code")
    private String personnelPostCode;

    @Column(name = "personnel_post_grade_code")
    private String personnelPostGradeCode;

    @Column(name = "personnel_post_grade_title")
    private String personnelPostGradeTitle;

    @Column(name = "personnel_post_title")
    private String personnelPostTitle;

    @Column(name = "personnel_f_department_id")
    private Long personnelDepartmentId;

    @Column(name = "personnel_f_post_id")
    private Long personnelPostId;
}
