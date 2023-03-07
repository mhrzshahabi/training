package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
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
    
    

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Message-Info")
    public static class WithSession {
        private Long messageId;
        private String title;
        private String context;
        private String groupId;

        //session attributes
        private Long sessionId;
        private String dayName;
        private Long classId;
        private String titleClass;
        private String sessionDate;
        private String sessionStartHour;
        private String sessionEndHour;
    }
    

}
