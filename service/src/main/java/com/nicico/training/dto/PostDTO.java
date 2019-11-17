/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PostDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Post - Info")
    public static class Info {
        private Long id;
        private String code;
        private String titleFa;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
//        private DepartmentDTO.Info department;
    }
}
