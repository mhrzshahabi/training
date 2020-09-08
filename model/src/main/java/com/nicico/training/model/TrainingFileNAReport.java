
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
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
@Subselect("select * from view_training_file_na_report")
public class TrainingFileNAReport implements Serializable {

    @Id
    private Long id;

    ///////////////////////////////////////////////////na/////////////////////////////////////////////

    @Column(name = "na_priority_id")
    private Long priorityId;

    @Column(name = "is_in_na")
    private Boolean isInNA;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////

    @Column(name = "personnel_id")
    private long personnelId;

    @Column(name = "personnel_personnel_no")
    private String personnelPersonnelNo;

    @Column(name = "personnel_first_name")
    private String personnelFirstName;

    @Column(name = "personnel_last_name")
    private String personnelLastName;

    @Column(name = "personnel_full_name")
    private String personnelFullName;

    @Column(name = "personnel_national_code")
    private String personnelNationalCode;

    @Column(name = "post_title")
    private String personnelPostTitle;

    @Column(name = "post_code")
    private String personnelPostCode;

    @Column(name = "personnel_company_name")
    private String personnelCompanyName;

    @Column(name = "personnel_emp_no")
    private String personnelPersonnelNo2;

    @Column(name = "personnel_hoze_title")
    private String personnelCcpArea;

    @Column(name = "personnel_moavenat_title")
    private String personnelCcpAssistant;

    @Column(name = "personnel_omor_title")
    private String personnelCcpAffairs;

    @Column(name = "personnel_vahed_title")
    private String personnelCcpUnit;

    ///////////////////////////////////////////////////course///////////////////////////////////////

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "course_theory_duration")
    private Float theoryDuration;

    @Column(name = "course_technical_type")
    private Integer technicalType;

    ///////////////////////////////////////////////////skill///////////////////////////////////////

    @Column(name = "skill_id")
    private Long skillId;

    @Column(name = "skill_code")
    private String skillCode;

    @Column(name = "skill_title_fa")
    private String skillTitleFa;

    ///////////////////////////////////////////////////class///////////////////////////////////////

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_location")
    private String location;

    ///////////////////////////////////////////////////class-student///////////////////////////////////////

    @Column(name = "class_student_score")
    private Float score;

    @Column(name = "class_student_scores_state_id")
    private Long scoreStateId;
}
