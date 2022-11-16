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
@Table(name = "tbl_question_protocol")
public class QuestionProtocol {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "question_protocol_seq")
    @SequenceGenerator(name = "question_protocol_seq", sequenceName = "seq_question_protocol_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "question_id")
    private Long questionId;

    @Column(name = "question_mark")
    private Float questionMark;

    @Column(name = "f_test_question")
    private Long examId;

    @Column(name = "question_time")
    private Integer time;

    @Column(name = "correct_answer")
    private String correctAnswerTitle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_test_question", insertable = false, updatable = false)
    private TestQuestion exam;

    @Transient
    private String questionTitle;

    @Transient
    private String questionType;
}
