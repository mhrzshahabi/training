/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

import com.nicico.training.model.ParameterValue;
import io.swagger.annotations.ApiModel;
import lombok.AccessLevel;
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
    public static class Info {
        private Long id;
        private String code;
        private String titleFa;
        private String peopleType;
//        @Getter(AccessLevel.NONE)
//        private ParameterValue pEnabled;
//
//        public ParameterValue getpEnabled() {
//            return pEnabled;
//        }
    }
}
