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
@Subselect("select * from VIEW_COURSES_EVALUATION_STATISTICAL_REPORT")
@DiscriminatorValue("ViewCoursesEvaluationStatisticalReport")
public class ViewCoursesEvaluationStatisticalReport {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "CLASS_ID")
    private Long classId;

    @Column(name = "CLASS_CODE")
    private String classCode;

    @Column(name = "CLASS_START_DATE")
    private String classStartDate;

    @Column(name = "CLASS_END_DATE")
    private String classEndDate;

    @Column(name = "TOTAL_STD")
    private Integer totalStudent;

    @Column(name = "COURSE_ID")
    private Long courseId;

    @Column(name = "COURSE_CODE")
    private String courseCode;

    @Column(name = "COURSE_TITLE_FA")
    private String courseTitleFa;

    @Column(name = "CLASS_YEAR")
    private String classYear;

    @Column(name = "TERM_ID")
    private Long termId;

    @Column(name = "CATEGORY_ID")
    private Long categoryId;

    @Column(name = "CATEGORY_TITLE_FA")
    private String categoryTitleFa;

    @Column(name = "SUB_CATEGORY_ID")
    private Long subCategoryId;

    @Column(name = "SUB_CATEGORY_TITLE_FA")
    private String subCategoryTitleFa;

    @Column(name = "TEACHER_ID")
    private Long teacherId;

    @Column(name = "TEACHER_NATIONAL_CODE")
    private String teacherNationalCode;

    @Column(name = "TEACHER_FULL_NAME")
    private String teacherFullName;

    @Column(name = "STD_COMPLEX")
    private String studentComplex;

    @Column(name = "STD_ASSISTANT")
    private String studentAssistant;

    @Column(name = "STD_AFFAIRS")
    private String studentAffairs;

    @Column(name = "c_reaction_grade")
    private String hasReactionEval;

    @Column(name = "miangin_pre")
    private String hasLearningEval;


    @Column(name = "c_behavioral_grade")
    private String hasBehavioralEval;


    @Column(name = "c_results_grade")
    private String hasResultEval;

    @Column(name = "b_effectiveness_pass")
    private String effective;
}