package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ActiveClasses {
    private Long id;
    private String code;
    private String title;
    private String startDate;
    private String endDate;

    public ActiveClasses(Long id, String code, String title, String startDate, String endDate) {
        this.id = id;
        this.code = code;
        this.title = title;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}
