/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

import com.nicico.training.model.enums.EDeleted;
import com.nicico.training.model.enums.EEnabled;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
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
        private EEnabled eEnabled;
        private EDeleted eDeleted;
    }
}
