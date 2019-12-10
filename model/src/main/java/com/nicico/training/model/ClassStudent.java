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
@Table(name = "tbl_class_student_final")
public class ClassStudent extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "scores_seq")
    @SequenceGenerator(name = "scores_seq", sequenceName = "seq_scores_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "scores_state")
    private String scoresState;

    @Column(name = "failure_reason")
    private String failurereason;

    @Column(name = "score")
    private Float score;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_student_id", foreignKey = @ForeignKey(name = "fk_student_to_scores"), insertable = false, updatable = false)
    private Student student;

    @NotNull
    @Column(name = "f_student_id")
    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_tclass_id", foreignKey = @ForeignKey(name = "fk_tclass_to_student"), insertable = false, updatable = false)
    private Tclass tclass;

    @NotNull
    @Column(name = "f_tclass_id")
    private Long tclassId;

}
