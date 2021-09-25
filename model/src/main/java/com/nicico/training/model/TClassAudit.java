package com.nicico.training.model;

import com.nicico.training.model.compositeKey.AnnualStatisticalReportKey;
import com.nicico.training.model.compositeKey.AuditClassId;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;
import org.hibernate.envers.NotAudited;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from tbl_class_aud")
@DiscriminatorValue("TClassAudit")
public class TClassAudit implements Serializable {

    @EmbeddedId
    private AuditClassId id;


    @Column(name = "f_course")
    private Long courseId;

    @Column(name = "n_min_capacity")
    private Long minCapacity;

    @Column(name = "n_max_capacity")
    private Long maxCapacity;

    @Column(name = "c_code", nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_class")
    private String titleClass;

    @Column(name = "c_teaching_type")
    private String teachingType;//روش آموزش

    @Column(name = "n_h_duration")
    private Long hDuration;

    @Column(name = "n_d_duration")
    private Long dDuration;


    @Column(name = "f_teacher")
    private Long teacherId;


    @Column(name = "f_supervisor")
    private Long supervisorId;

    @Column(name = "f_planner")
    private Long plannerId;

    @Column(name = "c_reason")
    private String reason;

    @Column(name = "c_status")
    private String classStatus;

    @Column(name = "c_status_date")
    private Date classStatusDate;


    @Column(name = "f_institute")
    private Long instituteId;


    @Column(name = "f_institute_organizer")
    private Long organizerId;


    @Column(name = "n_group", nullable = false)
    private Long group;

    @Column(name = "f_term")
    private Long termId;

    @Column(name = "c_teaching_brand")
    private String teachingBrand;//نحوه آموزش
    @Column(name = "c_start_date", nullable = false)
    private String startDate;
    @Column(name = "c_end_date", nullable = false)
    private String endDate;
    @Column(name = "b_saturday")
    private Boolean saturday;
    @Column(name = "b_sunday")
    private Boolean sunday;
    @Column(name = "b_monday")
    private Boolean monday;
    @Column(name = "b_tuesday")
    private Boolean tuesday;
    @Column(name = "b_wednesday")
    private Boolean wednesday;
    @Column(name = "b_thursday")
    private Boolean thursday;
    @Column(name = "b_friday")
    private Boolean friday;
    @Column(name = "b_first")
    private Boolean first;
    @Column(name = "b_second")
    private Boolean second;
    @Column(name = "b_third")
    private Boolean third;
    @Column(name = "b_fourth")
    private Boolean fourth;
    @Column(name = "b_fifth")
    private Boolean fifth;
    @Column(name = "c_topology")
    private String topology;

    @Column(name = "c_scoring_method")
    private String scoringMethod;

    @Column(name = "c_acceptance_limit")
    private String acceptancelimit;

    @Column(name = "c_workflow_ending_status")
    private String workflowEndingStatus;

    @Column(name = "c_workflow_ending_status_code")
    private Integer workflowEndingStatusCode;

    @Column(name = "pre_course_test")
    private Boolean preCourseTest;

    @Column(name = "c_has_warning")
    private String hasWarning;


    @Column(name = "evaluation_reaction_teacher")
    private Integer evaluationStatusReactionTeacher;

    @Column(name = "evaluation_reaction_training")
    private Integer evaluationStatusReactionTraining;

    @Column(name = "start_evaluation")
    private Integer startEvaluation;

    @Column(name = "c_evaluation")
    private String evaluation;

    @Column(name = "c_behavioral_level")
    private String behavioralLevel;

    @Column(name = "f_cancel_class_reason")
    private Long classCancelReasonId;


    @Column(name = "f_alternative_class")
    private Long alternativeClassId;

    @Column(name = "c_postpone_start_date")
    private String postponeStartDate;

    @Column(name = "f_targetsociety_type_id")
    private Long targetSocietyTypeId;

    @Column(name = "c_student_cost")
    private String studentCost;

    @Column(name = "f_student_cost_currency")
    private Long studentCostCurrency;

    @Column(name = "TEACHER_ONLINE_EVAL_STATUS")
    private Boolean teacherOnlineEvalStatus;

    @Column(name = "STUDENT_ONLINE_EVAL_STATUS")
    private Boolean studentOnlineEvalStatus;

    @Column(name = "b_has_test")
    private Boolean hasTest;

    @Column(name = "f_target_population_type_id")
    private Long targetPopulationTypeId;

    @Column(name = "f_holding_class_type_id")
    private Long holdingClassTypeId;

    @Column(name = "f_teaching_method_id")
    private Long teachingMethodId;

    @Column(name = "b_class_to_online_status")
    private Boolean classToOnlineStatus;

    @Column(name = "complex_id")
    private Long complexId;

    @Column(name = "assistant_id")
    private Long assistantId;

    @Column(name = "affairs_id")
    private Long affairsId;


    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @Column(name = "C_LAST_MODIFIED_BY")
    private String modifiedBy;
}
