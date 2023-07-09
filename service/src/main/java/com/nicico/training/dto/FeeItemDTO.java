package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class FeeItemDTO implements Serializable {

    private Long id;
    private Date lastModifiedDate;
    private Date createdDate;
    private String createdBy;
    private String lastModifiedBy;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FeeItemDTO - Info")
    public static class Info extends FeeItemDTO {
        private String title;
        private Double cost;
        private Long classId;
        private String classTitle;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FeeItem - Create")
    public static class Create extends FeeItemDTO {
        private String title;
        private Double cost;
        private Long classId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("FeeItemSpecRs")
    public static class FreeItemSpecRs {
        private FeeItemDTO.SpecRs response;
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
