package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ECompetenceInputType {

    PerformanceEvaluation(1, "ارزیابی عملکرد"),
    OrganizationalGoals(2, "استراتژی و اهداف سازماني"),
    TaskDescription(3, "شرح وظيفه"),
    OccupationalComplications(4, "عارضه يابي شغل");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
