package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EGender {

    Male(1, "مرد"),
    Female(2, "زن");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
