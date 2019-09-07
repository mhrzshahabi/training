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
public class DepartmentDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Department - Info")
    public static class Info extends DepartmentDTO {
        private String id;
        private String area;
        private String assistance;
        private String affairs;
    }
}
