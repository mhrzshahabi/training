package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PostGradeDTO implements Serializable {
    private String code;
    private String titleFa;
    private String peopleType;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGrade - Info")
    public static class Info extends PostGradeDTO {
        private Long id;
        private Long enabled;
        private Long deleted;
    }
}
