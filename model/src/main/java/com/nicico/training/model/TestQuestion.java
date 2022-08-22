package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_test_question")
public class TestQuestion extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "test_question_seq")
    @SequenceGenerator(name = "test_question_seq", sequenceName = "seq_test_question_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "b_is_pre_test_question", nullable = false)
    private boolean isPreTestQuestion;

    @Column(name = "c_test_question_type", nullable = false)
    private String testQuestionType;

    @ManyToOne
    @JoinColumn(name = "f_class", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class")
    private Long tclassId;

    @Column(name = "c_date")
    private String date;

    @Column(name = "c_end_date")
    private String endDate;

    @Column(name = "c_end_time")
    private String endTime;

    @Column(name = "c_time")
    private String time;

    @Column(name = "class_score")
    private String classScore;

    @Column(name = "practical_score")
    private String practicalScore;

    @Column(name = "n_duration")
    private Integer duration;

    @Column(name = "B_ONLINE_FINAL_EXAM_STATUS")
    private Boolean onlineFinalExamStatus;

    @OneToMany(mappedBy = "testQuestion", fetch = FetchType.LAZY ,cascade = CascadeType.REMOVE)
    private Set<QuestionBankTestQuestion> questionBankTestQuestionList;

    @OneToMany(mappedBy = "exam", fetch = FetchType.LAZY ,cascade = CascadeType.ALL)
    private Set<QuestionProtocol> questionProtocols;
}