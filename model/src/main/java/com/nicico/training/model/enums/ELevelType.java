package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ELevelType {

    Master(1, "كارشناسي", "1"),
    Technician(2, "تكنسيني", "2"),
    Worker(3, "كارگري", "3"),
    Global(4, "عمومی", "4");

    private final Integer id;
    private final String titleFa;
    private final String code;

    public String getLiteral() {
        return name();
    }
}
