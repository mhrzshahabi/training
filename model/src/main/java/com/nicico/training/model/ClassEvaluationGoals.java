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
@Table(name = "tbl_class_evaluation_goals", uniqueConstraints = {@UniqueConstraint(columnNames = {"n_class", "n_skill", "n_goal"})})
public class ClassEvaluationGoals extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_evaluation_goals_seq")
    @SequenceGenerator(name = "class_evaluation_goals_seq", sequenceName = "seq_class_evaluation_goals_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "n_class", nullable = false)
    private Long classId;

    @Column(name = "n_skill")
    private Long skillId;

    @Column(name = "n_goal")
    private Long goalId;

    @Column(name = "c_question")
    private String question;

    @Column(name = "c_origin_question")
    private String originQuestion;

}
