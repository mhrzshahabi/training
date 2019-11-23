package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ESessionTime {

    FirstSession(1, "8-10"),
    SecondSession(2, "10-12"),
    ThirdSession(3, "14-16");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
