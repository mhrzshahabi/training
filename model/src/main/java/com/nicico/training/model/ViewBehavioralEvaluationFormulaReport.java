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
@Subselect("select * from VIEW_BEHAVIORAL_EVALUATION_FORMULA_REPORT")
@DiscriminatorValue("ViewBehavioralEvaluationFormulaReport")
public class ViewBehavioralEvaluationFormulaReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "evaluation_id")
    private Long evaluationId;

    @Column(name = "evaluation_score")
    private Double evaluationScore;

    @Column(name = "evaluation_avg_per_student")
    private Double evaluationAverage;

    @Column(name = "students_count")
    private Integer studentsCount;

    @Column(name = "evaluator_name")
    private String evaluatorName;

    @Column(name = "evaluated_name")
    private String evaluatedName;

    @Column(name = "evaluator_personnel_no")
    private String evaluatorPersonnelNo;

    @Column(name = "evaluated_personnel_no")
    private String evaluatedPersonnelNo;

    @Column(name = "evaluator_post_code")
    private String evaluatorPostCode;

    @Column(name = "evaluated_post_code")
    private String evaluatedPostCode;

    @Column(name = "evaluator_post_title")
    private String evaluatorPostTitle;

    @Column(name = "evaluated_post_title")
    private String evaluatedPostTitle;

    @Column(name = "evaluator_hoze")
    private String evaluatorArea;

    @Column(name = "evaluator_omoor")
    private String evaluatorAffairs;

    @Column(name = "evaluated_hoze")
    private String evaluatedArea;

    @Column(name = "evaluated_omoor")
    private String evaluatedAffairs;

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "complex_title")
    private String complexTitle;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "teacher_name")
    private String teacherName;

    @Column(name = "teacher_national_code")
    private String teacherNationalCode;

    @Column(name = "teacher_type")
    private String teacherType;

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title")
    private String courseTitle;

    @Column(name = "category_id")
    private Long categoryId;

    @Column(name = "course_category_title")
    private String courseCategoryTitle;

    @Column(name = "sub_category_id")
    private Long subCategoryId;

    @Column(name = "course_sub_category_title")
    private String courseSubCategoryTitle;

    @Column(name = "evaluator_national_code")
    private String evaluatorNationalCode;

    @Column(name = "evaluator_type")
    private String evaluatorType;

    @Column(name = "evaluated_national_code")
    private String evaluatedNationalCode;

    @Column(name = "class_supervisor")
    private String classSupervisor;

    @Column(name = "acceptance_score_limit")
    private Double acceptanceScoreLimit;

}
