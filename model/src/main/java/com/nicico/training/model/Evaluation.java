package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_evaluation")
public class Evaluation extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_evaluation_id")
    @SequenceGenerator(name = "seq_evaluation_id", sequenceName = "seq_evaluation_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_questionnaire_type_id", insertable = false, updatable = false)
    private ParameterValue questionnaireType;

    @Column(name = "f_questionnaire_type_id")
    private Long questionnaireTypeId;

    @ManyToOne()
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @NotNull
    @Column(name = "f_class_id")
    private Long classId;

    @Column(name = "f_evaluator_id")
    private Long evaluatorId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_evaluator_type_id", insertable = false, updatable = false)
    private ParameterValue evaluatorType;

    @Column(name = "f_evaluator_type_id")
    private Long evaluatorTypeId;

    @Column(name = "f_evaluated_id")
    private Long evaluatedId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_evaluated_type_id", insertable = false, updatable = false)
    private ParameterValue evaluatedType;

    @Column(name = "f_evaluated_type_id")
    private Long evaluatedTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_evaluation_level_id", insertable = false, updatable = false)
    private ParameterValue evaluationLevel;

    @Column(name = "f_evaluation_level_id")
    private Long evaluationLevelId;

    @Column(name = "c_description")
    private String description;

    @Column(name = "b_evaluation_full")
    private Boolean evaluationFull;

    @OneToMany(mappedBy = "evaluation", cascade = CascadeType.ALL)
    private List<EvaluationAnswer> evaluationAnswerList;

    @Column(name = "b_status")
    private Boolean status;

    @Column(name = "c_return_date")
    private String returnDate;

    @Column(name = "c_send_date")
    private String sendDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_questionnaire_id", insertable = false, updatable = false)
    private Questionnaire questionnaire;

    @Column(name = "f_questionnaire_id")
    private Long questionnaireId;
}
