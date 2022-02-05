package com.nicico.training.dto.enums;

import lombok.Getter;

@Getter
public enum ClassStatusDTO {

    PLANNING(1, "برنامه ریزی"),
    INPROGRESS(2, "در حال اجرا"),
    FINISH(3, "پایان یافته"),
    CANCEL(4, "لغو شده"),
    LOCK(5, "اختتام");

    private String value;
    private int key;

    ClassStatusDTO(int key,String value) {
        this.key=key;
        this.value=value;

    }
}
