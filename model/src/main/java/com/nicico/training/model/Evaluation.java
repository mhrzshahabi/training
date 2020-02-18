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
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "evaluation_seq")
    @SequenceGenerator(name = "evaluation_seq", sequenceName = "evaluation_seq_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_questionnaire_type_id", insertable = false, updatable = false)
    private ParameterValue questionnaireType;

    @Column(name = "f_questionnaire_type_id")
    private Long questionnaireTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
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

    @OneToMany(mappedBy = "evaluation", cascade = CascadeType.ALL)
    private List<EvaluationAnswer> evaluationAnswerList;

}
