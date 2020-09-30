/*
 * Author: Mehran Golrokhi
 */

package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
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
    @NoArgsConstructor
    @ApiModel("AllMessagesForSend")
    public static class AllMessagesForSend {

        private Integer countSend;

        private Integer countSent;

        /*private String contextText;

        private String contextHtml;*/

        private String objectMobile;

        private Long messageContactId;

        private Long classId;

        private String objectType;

        private Long objectId;
    }

}
