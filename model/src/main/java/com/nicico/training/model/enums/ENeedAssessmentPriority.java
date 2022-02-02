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

    EssentialService(1, "ضروری ضمن خدمت"),
    ImprovingFunctional(2, "عملکردی بهبود"),
    Developmental(3, "توسعه ای"),
    EssentialAppointment(4, "ضروری انتصاب سمت");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
