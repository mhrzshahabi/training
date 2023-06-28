package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum AgreementStatus {

    registration(1, "ثبت اولیه"),
    waiting(2, "در انتظار تایید"),
    returning(3, "عودت داده شده"),
    accepted(4, "تایید شده");

    private final Integer key;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

    public static AgreementStatus fromString(String text) {
        for (AgreementStatus paymentDocStatus : AgreementStatus.values()) {
            if (paymentDocStatus.getTitleFa().equalsIgnoreCase(text)) {
                return paymentDocStatus;
            }
        }
        return null;
    }
}
