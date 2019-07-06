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
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ETheoType {
    Theory(1, "تئوري"),
    Practical(2, "عملي"),
    TheoryPractical(3, "تئوري_عملي");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

}
