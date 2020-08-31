package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_class_detail")
@DiscriminatorValue("ViewClassDetail")
public class ViewClassDetail extends Auditable {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "TERM_ID")
    private Long termId;

    @Column(name = "INSTITUTE_ID")
    private Long instituteId;

    @Column(name = "COURSE_ID")
    private Long courseId;

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

    @Column(name = "COURSE_CATEGORY_ID")
    private Long courseCategory;

    @Column(name = "COURSE_SUBCATEGORY_ID")
    private Long courseSubCategory;

    @Column(name = "COURSE_C_TITLE_FA")
    private String courseTitleFa;

    @Column(name = "COURSE_C_EVALUATION")
    private String courseEvaluationType;

    @Column(name = "tclass_n_duration")
    private Long tclassDuration;

   @Column(name = "tclass_organizer")
   private Long tclassOrganizerId;

   @Column(name = "tclass_status")
   private String tclassStatus;

    @Column(name = "tclass_ending_status")
    private String tclassEndingStatus;

    @Column(name = "tclass_planner")
   private Long tclassPlanner;

   @Column(name = "tclass_supervisor")
   private Long tclassSupervisor;

   @Column(name = "TERM_TITLEFA")
   private String termTitleFa;

   @Column(name = "tclass_institute")
   private String instituteTitleFa;

   @Column(name = "tclass_scoring_method")
   private String classScoringMethod;

   @Column(name = "tclass_has_pre_test")
   private Boolean classPreCourseTest;

    @Column(name = "TEACHER_EVAL_STATUS")
    private Integer teacherEvalStatus;

    @Column(name = "TRAINING_EVAL_STATUS")
    private Integer trainingEvalStatus;

    @Column(name = "start_evaluation")
    private Integer startEvaluation;

    @Column(name = "c_evaluation")
    private String evaluation;

    @Column(name = "c_behavioral_level")
    private String behavioralLevel;

    @Column(name = "CANCEL_REASON_ID")
    private Long cancelReasonId;

    @Column(name = "POSTPONE_DATE")
    private String postPoneDate;

    @Column(name = "ALTERNATIVE_CLASS_CODE")
    private String alternativeClassCode;

    @Column(name = "RE_HOLIDING_STATUS")
    private Boolean reHoldingStatus;

    @Column(name = "TEACHER_FIRST_NAME")
    private String teacherFirstName;

    @Column(name="TEACHER_LAST_NAME")
    private String teacherLastName;

    @Column(name = "BEHAVIORAL_DUE_DATE")
    private Date behavioralDueDate;

}
