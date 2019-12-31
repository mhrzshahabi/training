package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EPublicationSubjectType {

    Book(0, "کتاب", "B"),
    Project(1, "پروژه تحقیقاتی", "P"),
    Article(2, "مقاله معتبر", "A"),
    Translation(3, "ترجمه کتاب", "T"),
    NoteBook(4, "جزوه", "N");

    private final Integer id;
    private final String titleFa;
    private final String code;

    public String getLiteral() {
        return name();
    }
}
