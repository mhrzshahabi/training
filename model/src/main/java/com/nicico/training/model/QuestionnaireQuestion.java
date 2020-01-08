/*
ghazanfari_f,
1/8/2020,
2:41 PM
*/
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_questionnaire_question")
public class QuestionnaireQuestion extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_questionnaire_question_id")
    @SequenceGenerator(name = "seq_questionnaire_question_id", sequenceName = "seq_questionnaire_question_id", allocationSize = 1)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "evaluation_question_id", nullable = false, insertable = false, updatable = false)
    private EvaluationQuestion evaluationQuestion;

    @Column(name = "evaluation_question_id")
    private Long evaluationQuestionId;

    private float weight;

    private Integer order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_questionnaire", nullable = false, insertable = false, updatable = false)
    private Questionnaire questionnaire;


}

