/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

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
        private Long enabled;
        private Long deleted;

        //don't touch
        @Getter(AccessLevel.NONE)
        private Long isEnabled;

        public Long getIsEnabled(){
            //90000 is a fake number
            return enabled==null ? 90000 : enabled;
        }
    }
}
