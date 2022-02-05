package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class MessageContactDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MessageContact-Create")
    public static class Create extends MessageContactDTO {
        private Long messageId;
        private Long objectId;
        private String objectType;
        private String objectMobile;
        private List<MessageParameterDTO.Create> messageParameterList;
        private Date lastSentDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MessageContact-Info")
    public static class Info extends MessageContactDTO {
        private Long id;
        private Long messageId;
        private Long objectId;
        private String objectType;
        private String objectMobile;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @AllArgsConstructor
    @NoArgsConstructor
    @ApiModel("AllMessagesForSend")
    public static class AllMessagesForSend {
        private Integer countSend;
        private Integer countSent;
        private String objectMobile;
        private Long messageContactId;
        private Long classId;
        private String objectType;
        private Long objectId;
        private String pid;
    }
}
