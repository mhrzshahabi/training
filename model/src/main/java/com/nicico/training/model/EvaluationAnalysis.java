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
@Table(name = "tbl_evaluation_analysis")
public class EvaluationAnalysis extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_evaluation_analysis_id")
    @SequenceGenerator(name = "seq_evaluation_analysis_id", sequenceName = "seq_evaluation_analysis_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "f_tclass", nullable = false, unique = true)
    private Tclass tClass;

    @Column(name = "f_tclass", insertable = false, updatable = false, nullable = false, unique = true)
    private Long tClassId;

    @Column(name = "c_reaction_grade")
    private String reactionGrade;

    @Column(name = "c_learning_grade")
    private String learningGrade;

    @Column(name = "c_behavioral_grade")
    private String behavioralGrade;

    @Column(name = "c_results_grade")
    private String resultsGrade;

    @Column(name = "c_effectiveness_grade")
    private String effectivenessGrade;

    @Column(name = "c_teacher_grade")
    private String teacherGrade;

    @Column(name = "b_reaction_pass")
    private Boolean reactionPass;

    @Column(name = "b_learning_pass")
    private Boolean learningPass;

    @Column(name = "b_behavioral_pass")
    private Boolean behavioralPass;

    @Column(name = "b_results_pass")
    private Boolean resultsPass;

    @Column(name = "b_effectiveness_pass")
    private Boolean effectivenessPass;

    @Column(name = "b_teacher_pass")
    private Boolean teacherPass;
}