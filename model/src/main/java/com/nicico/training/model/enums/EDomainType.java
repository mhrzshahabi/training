package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EDomainType {

    Knowledge(1, "دانشي"),
    Skill(2, "مهارتي"),
    Attitude(3, "نگرشي");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
