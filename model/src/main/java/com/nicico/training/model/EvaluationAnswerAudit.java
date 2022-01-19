package com.nicico.training.model;

import com.nicico.training.model.compositeKey.EvaluationAnswerAuditId;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from TBL_EVALUATION_ANSWER_AUD")
@DiscriminatorValue("EvaluationAnswerAudit")
public class EvaluationAnswerAudit implements Serializable {

    @EmbeddedId
    private EvaluationAnswerAuditId id;

    @Column(name = "f_evaluation_id")
    private Long evaluationId;

    @Column(name = "f_evaluation_question_id")
    private Long evaluationQuestionId;

    @Column(name = "f_question_source_id")
    private Long questionSourceId;

    @Column(name = "f_answer_id")
    private Long answerId;

    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @Column(name = "C_LAST_MODIFIED_BY")
    private String modifiedBy;

    @Column(name = "d_last_modified_date")
    private String modifiedDate;
}
