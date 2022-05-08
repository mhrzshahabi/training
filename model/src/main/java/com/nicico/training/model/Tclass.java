package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.NotAudited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;
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
@Table(name = "tbl_class")
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
@AuditOverride(forClass =Auditable.class )
public class Tclass extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_seq")
    @SequenceGenerator(name = "class_seq", sequenceName = "seq_class_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "f_course", insertable = false, updatable = false)
    private Course course;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher")
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_supervisor", insertable = false, updatable = false)
    private Personnel supervisor;

    @Column(name = "f_supervisor")
    private Long supervisorId;

    @ManyToOne()
    @JoinColumn(name = "f_planner", insertable = false, updatable = false)
    private Personnel planner;

    @Column(name = "f_planner")
    private Long plannerId;

    @Column(name = "c_reason")
    private String reason;

    @Column(name = "c_status")
    private String classStatus;

    @Column(name = "c_status_date")
    private Date classStatusDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_institute", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "f_institute")
    private Long instituteId;

    @ManyToOne()
    @JoinColumn(name = "f_institute_organizer", insertable = false, updatable = false)
    private Institute organizer;

    @Column(name = "f_institute_organizer")
    private Long organizerId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_class_training_place",
            joinColumns = {@JoinColumn(name = "f_class_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_training_place_id", referencedColumnName = "id")})
    @NotAudited
    private Set<TrainingPlace> trainingPlaceSet;

    @Column(name = "n_group", nullable = false)
    private Long group;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_term", insertable = false, updatable = false)
    private Term term;

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

    @OneToMany(mappedBy = "tclass", cascade = CascadeType.REMOVE)
    @NotAudited
    private Set<ClassStudent> classStudents;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, orphanRemoval = true)
    @NotAudited
    private Set<ClassSession> classSessions;

    @ElementCollection
    @CollectionTable(name = "tbl_class_pre_course_test_question", joinColumns = @JoinColumn(name = "f_class_id"), uniqueConstraints = {@UniqueConstraint(columnNames = {"f_class_id", "c_pre_course_test_question"})})
    @OrderColumn(name = "n_order", nullable = false)
    @Column(name = "c_pre_course_test_question", nullable = false, length = 1000)
    @NotAudited
    private List<String> preCourseTestQuestions;

    @Column(name = "pre_course_test")
    private Boolean preCourseTest;

    @Transient
    public List<Long> getTrainingPlaceIds() {
        List<Long> ids = new ArrayList<>();
        if(trainingPlaceSet != null) {
            trainingPlaceSet.forEach(c -> ids.add(c.getId()));
        }
        return ids;
    }

    @Column(name = "c_has_warning")
    private String hasWarning;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    @NotAudited
    private Set<Alarm> alarms;

    @OneToMany(mappedBy = "tclassConflict", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    @NotAudited
    private Set<Alarm> alarmsConflict;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @NotAudited
    private List<TargetSociety> targetSocietyList;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_cancel_class_reason", insertable = false, updatable = false)
    private ParameterValue classCancelReason;

    @Column(name = "f_cancel_class_reason")
    private Long classCancelReasonId;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "alternativeClass")
    @NotAudited
    private Set<Tclass> canceledClasses;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @NotAudited
    private Set<Evaluation> evaluations;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_alternative_class", insertable = false, updatable = false)
    private Tclass alternativeClass;

    @Column(name = "f_alternative_class")
    private Long alternativeClassId;

    @Column(name = "c_postpone_start_date")
    private String postponeStartDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_targetsociety_type_id", insertable = false, updatable = false)
    private ParameterValue targetSocietyType;

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


    @Column(name = "STUDENT_ONLINE_EVAL_EXECUTION_STATUS")
    private Boolean studentOnlineEvalExecutionStatus;



    @Column(name = "b_has_test")
    private Boolean hasTest;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_target_population_type_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue targetPopulationType;

    @Column(name = "f_target_population_type_id")
    private Long targetPopulationTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_holding_class_type_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue holdingClassType;

    @Column(name = "f_holding_class_type_id")
    private Long holdingClassTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teaching_method_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue teachingMethod;

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

    @Column(name = "C_RELEASE_DATE")
    @NotAudited
    private String releaseDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "educational_calender", insertable = false, updatable = false)
    private EducationalCalender educationalCalender;


    @Column(name = "educational_calender_id")
    private Long educationalCalenderId;
}
