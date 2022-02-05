package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum EMobileForSMS {

    trainingMobile(1),
    trainingSecondMobile(2),
    hrMobile(3),
    mdmsMobile(4);

    private final Integer id;
    public static EMobileForSMS getEnum(Integer id) {
        for (EMobileForSMS value : values()) {
            if (value.getId().equals(id))
                return value;
        }
        return null;
    }
}
