package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;
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

    @ManyToOne
    @JoinColumn(name = "f_class", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class")
    private Long tclassId;

    @OneToMany(mappedBy = "testQuestion", fetch = FetchType.LAZY ,cascade = CascadeType.REMOVE)
    private Set<QuestionBankTestQuestion> questionBankTestQuestionList;

    @Column(name = "c_date")
    private String date;

    @Column(name = "c_time")
    private String time;

    @Column(name = "n_duration")
    private Integer duration;

    @Column(name = "B_ONLINE_FINAL_EXAM_STATUS")
    private Boolean onlineFinalExamStatus;
}