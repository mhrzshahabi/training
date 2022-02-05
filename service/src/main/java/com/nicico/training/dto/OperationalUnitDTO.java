package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class OperationalUnitDTO implements Serializable {
    @ApiModelProperty(required = true)
    private String unitCode;
    @ApiModelProperty(required = true)
    private String operationalUnit;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitInfo")
    public static class Info extends OperationalUnitDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitCreateRq")
    public static class Create extends OperationalUnitDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitUpdateRq")
    public static class Update extends OperationalUnitDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitIdListRq")
    public static class OperationalUnitIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitSpecRs")
    public static class OperationalUnitSpecRs {
        private OperationalUnitDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<OperationalUnitDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalUnitInfoTuple")
    public static class InfoTuple {
        private String unitCode;
        private String operationalUnit;
    }
}
