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
@Table(name = "tbl_class_student_history")
public class ClassStudentHistory extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_student_history_seq")
    @SequenceGenerator(name = "class_student_history_seq", sequenceName = "seq_class_student_history_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "class_id")
    private Long tclassId;

    @Column(name = "failure_reason_id")
    private Long failureReasonId;

    @Column(name = "score")
    private Float score;

    @Column(name = "scores_state_id")
    private Long scoresStateId;

    @Column(name = "TEST_SCORE")
    private Float testScore;

    @Column(name = "DESCRIPTIVEـSCORE")
    private Float descriptiveScore;
}
