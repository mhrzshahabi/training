package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_evaluation_answer")
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
@AuditOverride(forClass = Auditable.class)
public class EvaluationAnswer extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_evaluation_answer_id")
    @SequenceGenerator(name = "seq_evaluation_answer_id", sequenceName = "seq_evaluation_answer_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne()
    @JoinColumn(name = "f_evaluation_id", insertable = false, updatable = false)
    private Evaluation evaluation;

    @NotNull
    @Column(name = "f_evaluation_id")
    private Long evaluationId;

    ////it can be DynamicQuestionId and QuestionnaireQuestionId
    @NotNull
    @Column(name = "f_evaluation_question_id")
    private Long evaluationQuestionId;

    @ManyToOne()
    @JoinColumn(name = "f_question_source_id", insertable = false, updatable = false)
    private ParameterValue questionSource;

    @NotNull
    @Column(name = "f_question_source_id")
    private Long questionSourceId;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_answer_id", insertable = false, updatable = false)
    private ParameterValue answer;

    @Column(name = "f_answer_id")
    private Long answerId;
}
