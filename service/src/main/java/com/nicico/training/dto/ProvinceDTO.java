package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ProvinceDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String nameFa;
    private String nameEn;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ProvinceInfo")
    public static class Info extends ProvinceDTO{
        private Long id;
        private Integer version;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("ProvinceInfoTuple")
    static class ProvinceInfoTuple{
        private String nameFa;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("ProvinceCreateRq")
    public static class Create extends ProvinceDTO{ }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("ProvinceUpdateRq")
    public static class Update extends ProvinceDTO{
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("ProvinceDeleteRq")
    public static class Delete{
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ProvinceSpecRs")
    public static class ProvinceSpecRs{
        private ProvinceDTO.SpecRs response;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs{
        private List<ProvinceDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
