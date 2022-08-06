package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
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
@Subselect("select * from view_effective_courses_report")
@DiscriminatorValue("ViewEffectiveCoursesReport")
public class ViewEffectiveCoursesReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "EFFECTIVENESS_PASS")
    private Integer effectivenessPass;

    @Column(name = "EFFECTIVENESS_TYPE")
    private String effectivenessType;

    @Column(name = "EFFECTIVENESS_GRADE")
    private Double effectivenessGrade;

    @Column(name = "TERM_ID")
    private Long termId;

    @Column(name = "TERM_TITLE")
    private String termTitle;

    @Column(name = "CLASS_START_DATE")
    private String classStartDate;

    @Column(name = "CLASS_END_DATE")
    private String classEndDate;

    @Column(name = "CLASS_YEAR")
    private String classYear;

    @Column(name = "STUDENT_ID")
    private Long studentId;

    @Column(name = "STUDENT_FULL_NAME")
    private String studentFullName;

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

    @Column(name = "COURSE_CATEGORY_ID")
    private Long courseCategoryId;

    @Column(name = "STUDENT_COMPLEX")
    private String studentComplex;

    @Column(name = "STUDENT_ASSISTANT")
    private String studentAssistant;

    @Column(name = "STUDENT_AFFAIR")
    private String studentAffair;

    @Column(name = "CLASS_EVALUATION_CODE")
    private String classEvaluationCode;

    @Column(name = "EVALUATION_TYPE")
    private String evaluationType;

}
