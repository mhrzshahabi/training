package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ERunType {

    Internal(1, "داخلي"),
    Dispatch(2, "اعزام"),
    InternalSeminar(3, "سمينار داخلي"),
    DispatchSeminar(4, "سمينار اعزام"),
    WhileWorking(5, "حين كار");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
