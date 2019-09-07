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
public class JobDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Job - Info")
    public static class Info extends JobDTO {
        private Long id;
        private String code;
        private String titleFa;
    }
}
