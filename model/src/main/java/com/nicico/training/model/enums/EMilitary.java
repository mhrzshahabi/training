package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EMilitary {

    Passed(1, "گذرانده"),
    Exempt(2, "معاف"),
    Inductee(3, "مشمول");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
