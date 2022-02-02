package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseTermKey;
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
@Subselect("SELECT * from VIEW_COURSES_PASSED_PERSONNEL_REPORT")

public class ViewCoursesPassedPersonnelReport implements Serializable {

    @EmbeddedId
    private PersonnelCourseTermKey id;

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

    @Column(name = "class_student_scores_state_id")
    private Long classStudentScoresStateId;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_h_duration")
    private Long classHDduration;

    @Column(name = "term_code")
    private String termCode;

    @Column(name = "term_title_fa")
    private String termTitleFa;

    @Column(name = "term_id", insertable = false, updatable = false)
    private Long termId;

    @Column(name = "class_year")
    private String classYear;

    @Column(name = "personnel_post_grade_code")
    private String postGradeCode;

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

    @Column(name = "coursetype")
    private String courseType;

    @Column(name = "na_priority_id")
    private Long naPriorityId;

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "personnel_id", insertable = false, updatable = false)
    private Long personnelId;

    @Column(name = "class_student_score")
    private Float score;
}