package com.nicico.training.model.compositeKey;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"UnitId","TclassId","EvaluationAnalysisId"}, callSuper = false)
@Embeddable
public class EvaluationStaticalReportKey implements Serializable {

    @Column(name = "UNIT_ID")
    private Long UnitId;

    @Column(name = "TCLASS_ID")
    private Long TclassId;

    @Column(name = "EVALUATIONANALYSIS_ID")
    private Long EvaluationAnalysisId;
}

