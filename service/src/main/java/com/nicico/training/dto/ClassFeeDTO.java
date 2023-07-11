package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.ClassFee;
import com.nicico.training.model.enums.ClassFeeStatus;
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
public class ClassFeeDTO implements Serializable {
    private Long id;
    private Date lastModifiedDate;
    private Date createdDate;
    private String createdBy;
    private String lastModifiedBy;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassFeeDTO - Info")
    public static class Info extends ClassFeeDTO {
        private String date;
        private Long complexId;
        private String complexTitle;
        private Long classId;
        private String classTitle;
        private Long classFeeStatus;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassFee - Create")
    public static class Create extends ClassFeeDTO {
        private String date;
        private Long complexId;
        private Long classId;
        private String classTitle;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassFeeSpecRs")
    public static class ClassFeeSpecRs {
        private ClassFeeDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
