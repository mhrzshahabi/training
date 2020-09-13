package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseTermKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("SELECT * from VIEW_CONTINUOUS_STATUS_REPORT")

public class ContinuousStatusReportView {
    @EmbeddedId
    private PersonnelCourseTermKey id;

    @Column(name = "personnel_id", insertable = false, updatable = false)
    private Long personnelId;

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

    //////////////////////////////////////////////////////////////////////
    @Column(name = "class_id")
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_h_duration")
    private Long classHDduration;

    @Column(name = "class_year")
    private String classYear;

    ////////////////////////////////////////////////////////////////////////
    @Column(name = "term_code")
    private String termCode;

    @Column(name = "term_title_fa")
    private String termTitleFa;

    @Column(name = "term_id", insertable = false, updatable = false)
    private Long termId;

    ////////////////////////////////////////////////////////////////////////
    @Column(name = "personnel_post_title")
    private String postTitle;

    @Column(name = "personnel_post_grade_id")
    private Long pgId;

    @Column(name = "personnel_post_grade_title")
    private String postGradeTitle;

    @Column(name = "personnel_ccp_affairs")
    private String affairs;

    @Column(name = "personnel_ccp_area")
    private String area;

    @Column(name = "personnel_ccp_assistant")
    private String assistant;

    @Column(name = "personnel_ccp_section")
    private String section;

    @Column(name = "personnel_ccp_unit")
    private String unit;

    @Column(name = "personnel_company_name")
    private String companyName;

    @Column(name = "personnel_complex_title")
    private String complexTitle;

    ////////////////////////////////////////////////////////////////////////
    @Column(name = "coursetype")
    private String courseType;

    @Column(name = "na_priority_id")
    private Long naPriorityId;
}

