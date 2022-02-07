package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.UserRequestType;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.question.dto.ElsAttachmentDto;

import javax.persistence.Column;
import java.util.Date;
import java.util.List;

@Data
public class RequestResVM {
    private Long id;
    private String text;
    private String name;
    private String nationalCode;
    private String response;
    private UserRequestType type;
    private RequestStatus status;
    private String reference;
    private String createdDate;
    private List<ElsAttachmentDto> requestAttachmentDtos;
    private List<ElsAttachmentDto> responseAttachmentDtos;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForAudit")
    public static class InfoForAudit extends RequestResVM {
        private String createdBy;
        private String lastModifiedBy;
        private String lastModifiedDate;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class RequestAuditSpecRs {
        private RequestResVM.SpecAuditRs response;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecAuditRs {
        private List<RequestResVM.InfoForAudit> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
