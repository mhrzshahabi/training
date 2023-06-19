package com.nicico.training.model.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"titleFa"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum PaymentDocStatus {

    registration(1, "ثبت اولیه"),
    paid(2, "پرداخت شده");

    private final Integer key;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }

    public static PaymentDocStatus fromString(String text) {
        for (PaymentDocStatus paymentDocStatus : PaymentDocStatus.values()) {
            if (paymentDocStatus.getTitleFa().equalsIgnoreCase(text)) {
                return paymentDocStatus;
            }
        }
        return null;
    }
}
