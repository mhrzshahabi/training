/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

import com.nicico.training.model.enums.EActive;
import com.nicico.training.model.enums.EDeleted;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PostGradeDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGrade - Info")
    public static class Info extends PostGradeDTO {
        private Long id;
        private String code;
        private String titleFa;
    }
}
