package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_question_bank_test_question")
public class QuestionBankTestQuestion extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "question_bank_test_question_seq")
    @SequenceGenerator(name = "question_bank_test_question_seq", sequenceName = "seq_question_bank_test_question_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_test_question", insertable = false, updatable = false)
    private TestQuestion testQuestion;

    @Column(name = "f_test_question")
    private Long testQuestionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_question_bank", insertable = false, updatable = false)
    private QuestionBank questionBank;

    @Column(name = "f_question_bank")
    private Long questionBankId;
}