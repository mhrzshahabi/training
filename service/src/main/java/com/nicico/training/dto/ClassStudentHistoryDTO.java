package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class ClassStudentHistoryDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForAudit")
    public static class InfoForAudit extends ClassStudentHistoryDTO {
        private Long id;
        private String student;
        private String code;
        private String createdBy;
        private Date createdDate;
        private String modifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassAuditSpecRs {
        private SpecAuditRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecAuditRs {
        private List<ClassStudentHistoryDTO.InfoForAudit> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
