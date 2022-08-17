package com.nicico.training.model;

import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
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
@Subselect("select * from view_evaluation_statical_report")
@DiscriminatorValue("ViewEvaluationStaticalReport")
public class ViewEvaluationStaticalReport extends Auditable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "UNIT_ID")
    private Long unitId;

    @Column(name = "TCLASS_ID")
    private Long tclassId;

    @Column(name = "EVALUATIONANALYSIS_ID")
    private Long evaluationAnalysisId;

    @Column(name = "TERM_ID")
    private Long termId;

    @Column(name = "INSTITUTE_ID")
    private Long instituteId;

    @Column(name = "TEACHER_ID")
    private Long teacherId;

    @Column(name = "TCLASS_STUDENTS_COUNT")
    private Integer tclassStudentsCount;

    @Column(name = "TCLASS_C_CODE")
    private String tclassCode;

    @Column(name = "TCLASS_C_START_DATE")
    private String tclassStartDate;

    @Column(name = "TCLASS_C_END_DATE")
    private String tclassEndDate;

    @Column(name = "TCLASS_YEAR")
    private String tclassYear;

    @Column(name = "COURSE_C_CODE")
    private String courseCode;

    @Column(name = "COURSE_TECHNICAL_TYPE")
    private ETechnicalType courseTechnicalType;

    @Column(name = "COURSE_RUN_TYPE")
    private ERunType courseRunType;

    @Column(name = "COURSE_THEO_TYPE")
    private ETheoType courseTheoType;

    @Column(name = "course_level_type")
    private ELevelType courseLevelType;

    @Column(name = "COURSE_CATEGORY_ID")
    private Long courseCategory;

    @Column(name = "COURSE_SUBCATEGORY_ID")
    private Long courseSubCategory;

    @Column(name = "COURSE_C_TITLE_FA")
    private String courseTitleFa;

    @Column(name = "COURSE_C_EVALUATION")
    private String courseEvaluation;

    @Column(name = "TCLASS_EVALUATION")
    private String classEvaluation;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_GRADE")
    private String evaluationBehavioralGrade;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_PASS")
    private Boolean evaluationBehavioralPass;

    @Column(name = "EVALUATIONANALYSIS_B_BEHAVIORAL_STATUS")
    private Boolean evaluationBehavioralStatus;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_GRADE")
    private String evaluationEffectivenessGrade;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_PASS")
    private Boolean evaluationEffectivenessPass;

    @Column(name = "EVALUATIONANALYSIS_B_EFFECTIVENESS_STATUS")
    private Boolean evaluationEffectivenessStatus;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_GRADE")
    private String evaluationLearningGrade;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_PASS")
    private Boolean evaluationLearningPass;

    @Column(name = "EVALUATIONANALYSIS_B_LEARNING_STATUS")
    private Boolean evaluationLearningStatus;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_GRADE")
    private String evaluationReactionGrade;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_PASS")
    private Boolean evaluationReactionPass;

    @Column(name = "EVALUATIONANALYSIS_B_REACTION_STATUS")
    private Boolean evaluationReactionStatus;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_GRADE")
    private String evaluationResultsGrade;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_PASS")
    private Boolean evaluationResultsPass;

    @Column(name = "EVALUATIONANALYSIS_B_RESULTS_STATUS")
    private Boolean evaluationResultsStatus;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_GRADE")
    private String evaluationTeacherGrade;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_PASS")
    private Boolean evaluationTeacherPass;

    @Column(name = "EVALUATIONANALYSIS_B_TEACHER_STATUS")
    private Boolean evaluationTeacherStatus;

    @Column(name = "tclass_n_duration")
    private Long tclassDuration;

   @Column(name = "tclass_organizer")
   private Long tclassOrganizerId;

   @Column(name = "tclass_status")
   private String tclassStatus;

   @Column(name = "class_cancel_reason_id")
   private String classCancelReasonId;

   @Column(name = "class_cancel_reason_title")
   private String classCancelReasonTitle;

   @Column(name = "tclass_planner")
   private Long tclassPlanner;

   @Column(name = "tclass_supervisor")
   private Long tclassSupervisor;

   @Column(name = "TERM_TITLEFA")
   private String termTitleFa;

   @Column(name = "TEACHER_FIRSTNAME")
   private String teacherFirstName;

   @Column(name = "TEACHER_LASTNAME")
   private String teacherLastName;

    @Column(name = "TEACHER_FULLNAME")
    private String teacherFullName;

    @Column(name = "tclass_reason")
    private String tclassReason;

    @Column(name = "tclass_teaching_type")
    private String tclassTeachingType;

    @Column(name = "planner_complex")
    private String plannerComplex;

    @Column(name = "planner_assistant")
    private String plannerAssistant;

    @Column(name = "planner_affairs")
    private String plannerAffairs;

    @Column(name = "planner_section")
    private String plannerSection;

    @Column(name = "planner_unit")
    private String plannerUnit;

    @Column(name = "planner_name")
    private String plannerName;

    @Column(name = "institute_name")
    private String instituteName;

    @Column(name = "PRESENCE")
    private String presenceManHour;

    @Column(name = "ABSENCE")
    private String absenceManHour;

    @Column(name = "UNKNOWN")
    private String unknownManHour;

    @Column(name = "holding_class_type_id")
    private String holdingClassTypeId;

    @Column(name = "holding_class_type_title")
    private String holdingClassTypeTitle;

    @Column(name = "teaching_method_id")
    private String teachingMethodId;

    @Column(name = "teaching_method_title")
    private String teachingMethodTitle;

    @Column(name = "supervisor")
    private String supervisor;

    @Column(name = "percent_reaction")
    private String percentReaction;
}
