package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EClassAttachmentType {

    Booklet(1, "جزوه"),
    ScoreList(2, "لیست نمرات"),
    AttendanceList(3, "لیست حضور و غیاب"),
    AbsenceLetter(4, "نامه غیبت موجه"),
    SessionContent(5, "محتوای جلسات");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
