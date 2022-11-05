package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_scores_by_committee")
public class ScoresByCommittee extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "scores_by_committee_seq")
    @SequenceGenerator(name = "scores_by_committee_seq", sequenceName = "seq_scores_by_committee_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_national_code", nullable = false)
    private String nationalCode;

    @Column(name = "c_score", nullable = false)
    private String score;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_course_id")
    private Course course;


}
