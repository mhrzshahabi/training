package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForEvalAudit")
    public static class InfoForSms {
        private Long id;
        private String createdBy;
        private String createdDate;
        private String mobileNumber;
        private String pId;
        private String smsType;
        private String trackingNumber;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecSmsRs {
        private List<InfoForSms> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SmsSpecRsSpecRs")
    public static class SmsSpecRs {
        private SpecSmsRs response;
    }
}
