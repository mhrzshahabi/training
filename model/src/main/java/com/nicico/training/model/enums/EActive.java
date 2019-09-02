package com.nicico.training.model.enums;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 10:58 AM
*/

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EActive {

    Active(1, "فعال"),
    Inactive(0, "غیرفعال");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
