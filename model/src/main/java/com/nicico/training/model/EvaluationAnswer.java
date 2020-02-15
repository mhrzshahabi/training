package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_evaluation_answer")
public class EvaluationAnswer extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "evaluation_answer_seq")
    @SequenceGenerator(name = "evaluation_answer_seq", sequenceName = "evaluation_answer_seq_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_evaluation_id", insertable = false, updatable = false)
    private Evaluation evaluation;

    @NotNull
    @Column(name = "f_evaluation_id")
    private Long evaluationId;

    ////it can be SkillId, GoalId and QuestionnaireQuestionId
    @NotNull
    @Column(name = "f_evaluation_question_id")
    private Long evaluationQuestionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_question_source_id", insertable = false, updatable = false)
    private ParameterValue questionSource;

    @NotNull
    @Column(name = "f_question_source_id")
    private Long questionSourceId;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_answer_id", insertable = false, updatable = false)
    private ParameterValue answer;

    @Column(name = "f_answer_id")
    private Long answerId;

}
