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
@Subselect("select * from view_class_student_final_status")
@DiscriminatorValue("ViewClassStudentFinalStatus")
public class ViewClassStudentFinalStatusReport {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "CLASS_CODE")
    private String classCode;

    @Column(name = "COURSE_CODE")
    private String courseCode;

    @Column(name = "CLASS_TITLE")
    private String classTitle;

    @Column(name = "TEACHER_ID")
    private Long teacherId;

    @Column(name = "TEACHER_FULL_NAME")
    private String teacherFullName;

    @Column(name = "STUDENT_NATIONAL_CODE")
    private String studentNationalCode;

    @Column(name = "STUDENT_ID")
    private Long studentId;

    @Column(name = "STUDENT_FULL_NAME")
    private String studentFullName;

    @Column(name = "STUDENT_COMPLEX")
    private String studentComplex;

    @Column(name = "STUDENT_ASSISTANT")
    private String studentAssistant;

    @Column(name = "STUDENT_AFFAIR")
    private String studentAffair;

    @Column(name = "CLASS_SCORING_METHOD_CODE")
    private Long classScoringMethodCode;

    @Column(name = "CLASS_SCORING_METHOD_TITLE")
    private String classScoringMethodTitle;

    @Column(name = "STUDENT_SCORE")
    private Integer studentScore;

    @Column(name = "ACCEPTANCE_LIMIT")
    private Integer acceptanceLimit;

    @Column(name = "ACCEPTANCE_STATUS")
    private String acceptanceStatus;

    @Column(name = "CLASS_START_DATE")
    private String classStartDate;

    @Column(name = "CLASS_END_DATE")
    private String classEndDate;

    @Column(name = "CLASS_YEAR")
    private String tclassYear;

    @Column(name = "TERM_TITLE")
    private String termTitle;

    @Column(name = "INSTITUTE_TITLE")
    private String instituteTitle;

    @Column(name = "COURSE_CATEGORY_ID")
    private Long courseCategoryId;

    @Column(name = "COURSE_TITLE")
    private String courseTitle;


}
