package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.RequestItemState;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class RequestItemAuditDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info {
        private Long id;
        private String personnelNumber;
        private String personnelNo2;
        private String name;
        private String lastName;
        private String affairs;
        private String post;
        private String workGroupCode;
        private String nationalCode;
        private RequestItemState state;
        protected Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Long revType;
        private Long deleted;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("RequestItemAuditSpecRs")
    public static class RequestItemAuditSpecRs {
        private RequestItemAuditDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<RequestItemAuditDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
