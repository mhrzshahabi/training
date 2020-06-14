package com.nicico.training.model;


import com.nicico.training.model.compositeKey.EvaluationStaticalReportKey;
import com.nicico.training.model.compositeKey.NASkillKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"UnitId","TclassId","EvaluationAnalysisId"}, callSuper = false)
@Entity
@Subselect("select * from view_evaluation_statical_report")
@DiscriminatorValue("ViewEvaluationStaticalReport")
public class ViewEvaluationStaticalReport extends Auditable {
    @EmbeddedId
    private EvaluationStaticalReportKey id;

    @Column(name = "TERM_ID")
    private Long TermId;

    @Column(name = "INSTITUTE_ID")
    private Long InstituteId;

    @Column(name = "TEACHER_ID")
    private Long TeacherId;

    @Column(name = "TCLASS_STUDENTS_COUNT")
    private Integer TclassStudentsCount;

    @Column(name = "TCLASS_C_CODE")
    private String TclassCode;

    @Column(name = "TCLASS_C_START_DATE")
    private String TclassStartDate;

    @Column(name = "TCLASS_C_END_DATE")
    private String TclassEndDate;

    @Column(name = "TCLASS_YEAR")
    private String TclassYear;

    @Column(name = "COURSE_C_CODE")
    private String CourseCode;

    @Column(name = "COURSE_CATEGORY_ID")
    private Long CourseCategory;

    @Column(name = "COURSE_SUBCATEGORY_ID")
    private Long CourseSubCategory;

    @Column(name = "COURSE_C_TITLE_FA")
    private String CourseTitleFa;

    @Column(name = "COURSE_C_EVALUATION")
    private String Evaluation;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_GRADE")
    private String EvaluationBehavioralGrade;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_PASS")
    private Boolean EvaluationBehavioralPass;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_GRADE")
    private String EvaluationEffectivenessGrade;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_PASS")
    private Boolean EvaluationEffectivenessPass;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_GRADE")
    private String EvaluationLearningGrade;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_PASS")
    private Boolean EvaluationLearningPass;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_GRADE")
    private String EvaluationReactionGrade;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_PASS")
    private Boolean EvaluationReactionPass;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_GRADE")
    private String EvaluationResultsGrade;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_PASS")
    private Boolean EvaluationResultsPass;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_GRADE")
    private String EvaluationTeacherGrade;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_PASS")
    private Boolean EvaluationTeacherPass;
}
