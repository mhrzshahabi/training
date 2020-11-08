package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_class_student",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"student_id", "class_id"})})
public class ClassStudent extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_student_seq")
    @SequenceGenerator(name = "class_student_seq", sequenceName = "seq_class_student_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scores_state_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue scoresState;

    @Column(name = "scores_state_id", nullable = false)
    private Long scoresStateId = 410L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "failure_reason_id", insertable = false, updatable = false)
    private ParameterValue failureReason;

    @Column(name = "failure_reason_id")
    private Long failureReasonId;

    @Column(name = "score")
    private Float score;

    @Column(name = "c_valence")
    private String valence;

    @Column(name = "applicant_company_name", nullable = false)
    private String applicantCompanyName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "presence_type_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue presenceType;

    @Column(name = "presence_type_id")
    private Long presenceTypeId;

    //DO NOT TOUCH
    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "student_id", insertable = false, updatable = false)
    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", nullable = false)
    private Tclass tclass;

    @Column(name = "class_id", insertable = false, updatable = false)
    private Long tclassId;

    @Column(name = "evaluation_status_reaction")
    private Integer evaluationStatusReaction;

    @Column(name = "evaluation_status_learning")
    private Integer evaluationStatusLearning;

    @Column(name = "evaluation_status_behavior")
    private Integer evaluationStatusBehavior;

    @Column(name = "evaluation_status_results")
    private Integer evaluationStatusResults;

    @Column(name = "pre_test_score")
    private Float preTestScore;

    @OneToMany(mappedBy = "classStudent", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    private Set<Alarm> alarms;

    @Column(name = "number_of_sended_behavioral_forms")
    private Integer numberOfSendedBehavioralForms;

    @Column(name = "number_of_registered_behavioral_forms")
    private Integer numberOfRegisteredBehavioralForms;
}
