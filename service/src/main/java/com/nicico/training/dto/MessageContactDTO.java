/**
 * Author:    Mehran Golrokhi
 * Created:    1399.05.15
 */

package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)

public class MessageContactDTO {




    @Getter
    @Setter
    @Accessors(chain = true)
    @AllArgsConstructor
    @ApiModel("FullInfo")
    public static class FullInfo{

        private Long id;

        private String contextText;
        private String contextHtml;

        private Integer countSent;
        private Integer countSend;

        private String objectMobile;
    }
}
