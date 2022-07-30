package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum TeacherRank {
    Professor(1, "استاد"),
    AssociateProfessor(2,  "دانشیار"),
    AssistantProfessor(3, "استادیار"),
    Coach(4, "مربی"),
    Educator(5, "آموزشیار");


    private final Integer id;
    private final String title;

    public String getLiteral() {
        return name();
    }

}
