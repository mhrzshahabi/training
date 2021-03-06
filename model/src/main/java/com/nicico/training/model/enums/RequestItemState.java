package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum RequestItemState {

    Impeded(1, "نیاز به گذراندن دوره"),
    Unimpeded(2, "بلامانع"),
    PostMissed(3, "پست موجود نیست");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
