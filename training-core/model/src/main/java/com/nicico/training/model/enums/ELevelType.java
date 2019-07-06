package com.nicico.training.model.enums;/* com.nicico.training.model.enumeration
@Author:jafari-h
@Date:6/3/2019
@Time:12:04 PM
*/

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ELevelType {
    Master(1, "كارشناسي"),
    Technician(2, "تكنسيني"),
    Worker(3, "كارگري");
    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
