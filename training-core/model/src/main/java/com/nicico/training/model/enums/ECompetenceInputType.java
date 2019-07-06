package com.nicico.training.model.enums;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 12:54 PM
*/

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ECompetenceInputType {

    TaskDescription(1, "شرح وظيفه"),
    OrganizationalGoals(2, "اهداف سازماني"),
    OccupationalComplications(3, "عارضه يابي شغل");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
