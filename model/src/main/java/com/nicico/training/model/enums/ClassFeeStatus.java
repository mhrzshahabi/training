package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ClassFeeStatus {

    REGISTERED(1, "ثبت اولیه"),
    PAID(2, "پرداخت شده");

    private final Integer key;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

    public static ClassFeeStatus fromString(String text) {
        for (ClassFeeStatus classFeeStatus : ClassFeeStatus.values()) {
            if (classFeeStatus.getTitleFa().equalsIgnoreCase(text)) {
                return classFeeStatus;
            }
        }
        return null;
    }
}
