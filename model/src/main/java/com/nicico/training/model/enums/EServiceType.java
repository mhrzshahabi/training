package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EServiceType {

    Teaching(1, "تدریس"),
    Other(2, "سایر خدمات");

    private final Integer id;
    private final String title;

    public String getLiteral() {
        return name();
    }
}
