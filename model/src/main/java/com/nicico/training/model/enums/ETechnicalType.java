package com.nicico.training.model.enums;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 12:41 PM
*/

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ETechnicalType {

    General(1, "عمومي"),
    Technical(2, "تخصصی"),
    Managerial(3, "مديريتي");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

}
