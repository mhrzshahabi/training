package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)

public enum EPlaceType {

    Class(1, "کلاس"),
    Salon(2, "سالن"),
    ComputerSite(3, "سایت کامپیوتر"),
    Salon1(4, "سالن (مرکز همایش و سمینارها)"),
    LanguageLab(5, "آزمایشگاه زبان"),
    Theory(6, "تئوری"),
    Lab(7, "آزمایشگاهی"),
    WorkShop(8, "کارگاهی"),
    Public(9, "عمومی"),
    Robotic(10, "رباتیک");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
