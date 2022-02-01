package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ETeacherAttachmentType {

    Resume(1, "رزومه"),
    EducationLicence(2, "مدرک تحصیلی"),
    Certificate(3, "گواهینامه");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
