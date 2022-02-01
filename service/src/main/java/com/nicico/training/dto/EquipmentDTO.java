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
public class EquipmentDTO {
    @ApiModelProperty
    private String code;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EquipmentInfo")
    public static class Info extends EquipmentDTO {
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
    @ApiModel("EquipmentCreateRq")
    public static class Create extends EquipmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EquipmentUpdateRq")
    public static class Update extends EquipmentDTO {
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EquipmentDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EquipmentIdListRq")
    public static class EquipmentIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EquipmentSpecRs")
    public static class EquipmentSpecRs {
        private EquipmentDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EquipmentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
