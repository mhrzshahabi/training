package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EEnabled {

    Enabled(1, "فعال"),
    Disabled(0, "غیر فعال");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
