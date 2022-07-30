package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.OperationalChart;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class OperationalChartDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;

    @ApiModelProperty(required = false)
    private Long parentId;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String complex;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String userName;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String nationalCode;

    @ApiModelProperty(required = false)
    private Long roleId;

    @ApiModelProperty(required = true)
    private String code;

    @ApiModelProperty(required = true)
    private List<OperationalChart> operationalChartParentChild;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalCharInfo")
    public static class Info extends OperationalChartDTO {
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
    @ApiModel("OperationalCharCreateRq")
    public static class Create extends OperationalChartDTO {

        @ApiModelProperty(required = true)
        private Long userId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalCharUpdateRq")
    public static class Update extends OperationalChartDTO {

        @ApiModelProperty(required = true)
        private Long userId;

//        @NotEmpty
//        @ApiModelProperty(required = true)
//        private String title;
//
//        @ApiModelProperty(required = true)
//        private String userName;
//
//        @ApiModelProperty(required = true)
//        private String nationalCode;
//
//        @ApiModelProperty(required = true)
//        private Long roleId;
//
//        @ApiModelProperty(required = true)
//        private Long userId;
//
//        @ApiModelProperty(required = true)
//        private String code;
//
//        @NotNull
//        @ApiModelProperty(required = true)
//        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalCharDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("OperationalCharSpecRs")
    public static class OperationalCharSpecRs {
        private OperationalChartDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<OperationalChartDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
