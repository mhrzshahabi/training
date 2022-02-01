package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_questionnaire_question",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"f_evaluation_question", "f_questionnaire"})})
public class QuestionnaireQuestion extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_questionnaire_question_id")
    @SequenceGenerator(name = "seq_questionnaire_question_id", sequenceName = "seq_questionnaire_question_id", allocationSize = 1)
    private Long id;

    @Column(name = "f_weight", nullable = false)
    private Integer weight;

    @Column(name = "n_order", nullable = false)
    private Integer order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_evaluation_question", nullable = false, insertable = false, updatable = false)
    private EvaluationQuestion evaluationQuestion;

    @Column(name = "f_evaluation_question")
    private Long evaluationQuestionId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "f_questionnaire", nullable = false, insertable = false, updatable = false)
    private Questionnaire questionnaire;

    @Column(name = "f_questionnaire")
    private Long questionnaireId;
}

