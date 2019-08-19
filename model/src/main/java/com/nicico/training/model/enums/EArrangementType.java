package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)

public enum EArrangementType {
    Linear(1, "ردیفی"),
    Conference(2, "کنفرانسی"),
    U_Shape(3, "U شکل");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

}
