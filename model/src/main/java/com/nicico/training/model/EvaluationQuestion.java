package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_evaluation_question",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_question", "f_domain_id"})})
public class EvaluationQuestion extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "evaluation_question_seq")
    @SequenceGenerator(name = "evaluation_question_seq", sequenceName = "seq_evaluation_question_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_question", nullable = false, unique = true)
    private String question;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "f_domain_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue domain;

    @Column(name = "f_domain_id")
    private Long domainId;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "tbl_evaluation_question_evaluation_index",
            joinColumns = {@JoinColumn(name = "f_evaluation_question", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_evaluation_index", referencedColumnName = "id")})
    private List<EvaluationIndex> evaluationIndices;
}
