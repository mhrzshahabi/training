package com.nicico.training.model.enums;
/*@Author:jafari-h
@Date:6/3/2019
@Time:12:10 PM
*/

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ClassStatus {
    planning(1, "برنامه ریزی"),
    inProcess(2, "در حال اجرا"),
    finish(3, "پایان یافته"),
    cancel(4, "لغو شده"),
    lock(5, "اختتام");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

}
