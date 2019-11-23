package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ESessionType {

    Training(1, "آموزش"),
    Examination(2, "آزمون");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

}
