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
@Table(name = "tbl_behavioral_goal", uniqueConstraints = {@UniqueConstraint(columnNames = {"c_title_fa"})})
public class BehavioralGoal extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "behavioral_goal_seq")
    @SequenceGenerator(name = "behavioral_goal_seq", sequenceName = "seq_behavioral_goal_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_kind", nullable = false)
    private String kind;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_goal_id", insertable = false, updatable = false)
    private Goal goal;

    @Column(name = "f_goal_id")
    private Long goalId;

}
