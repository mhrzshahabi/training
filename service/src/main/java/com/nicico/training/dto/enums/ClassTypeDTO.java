package com.nicico.training.dto.enums;


import lombok.Getter;

@Getter
public enum ClassTypeDTO {
    JOBTRAINING(1,"آموزش حین کار"),
    RETRAINING(2,"بازآموزی"),
    PRESENCE(3,"حضوری"),
    VIRTUAL(4,"مجازی"),
    SEMINAR(5,"سمینار"),
    WORKSHOP(6,"عملی و کارگاهی"),
    NOTPRESENCE (7,"غیر حضوری");


    private int key;
    private String value;

    ClassTypeDTO(int i, String s) {
        this.key=i;
        this.value=s;
    }
}
