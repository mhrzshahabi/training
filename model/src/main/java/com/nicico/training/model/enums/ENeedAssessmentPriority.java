/*
ghazanfari_f, 9/12/2019, 2:01 PM
*/
package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ENeedAssessmentPriority {

    EssentialFunctional(1, "عملکردی ضروری"),
    ImprovingFunctional(2, "عملکردی بهبود"),
    Developmental(3, "توسعه ای");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
