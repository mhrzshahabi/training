/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class MessageParameterDTO {



    @Getter
    @Setter
    @Accessors(chain = true)
    @AllArgsConstructor
    @NoArgsConstructor
    @ApiModel("MessageParameter-Create")
    public static class Create extends MessageParameterDTO {
        private String name;

        private String value;
    }

}
