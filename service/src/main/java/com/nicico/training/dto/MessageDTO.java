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
@AllArgsConstructor
@NoArgsConstructor
public class MessageDTO {
    private String pId;
    private Long tclassId;
    private Long orginalMessageId;
    private Long userTypeId;
    private Integer countSend;
    private Integer interval;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Message-Create")
    public static class Create extends MessageDTO {
        private String contextText;
        private String contextHtml;
        private List<MessageContactDTO.Create> messageContactList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Message-Info")
    public static class Info extends MessageDTO {
        private Long id;
        private List<MessageContactDTO.Info> messageContactList;
    }
}
