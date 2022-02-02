package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class EvaluationIndexDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String nameFa;
    private String nameEn;
    private String description;
    private String evalStatus;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationIndexInfo")
    public static class Info extends EvaluationIndexDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationIndexCreateRq")
    public static class Create extends EvaluationIndexDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationIndexUpdateRq")
    public static class Update extends EvaluationIndexDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationIndexDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EvaluationIndexSpecRs")
    public static class EvaluationIndexSpecRs {
        private EvaluationIndexDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EvaluationIndexDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

