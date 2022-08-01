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
    PROFESSOR(1, "استاد"),
    ASSOCIATEPROFESSOR(2,  "دانشیار"),
    ASSISTANTPROFESSOR(3, "استادیار"),
    COACH(4, "مربی"),
    EDUCATOR(5, "آموزشیار");


    private final Integer id;
    private final String title;

    public String getLiteral() {
        return name();
    }

}
