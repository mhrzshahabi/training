package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.Polis;
import com.nicico.training.model.Province;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PolisDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private Long provinceId;
    private String nameFa;
    private String nameEn;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ProvinceInfo")
    public static class Info extends PolisDTO{
        private Long id;
        private Integer version;
        private ProvinceDTO province;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("PolisTuple")
    static class PolisInfoTuple{
        private String nameFa;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("PolisCreateRq")
    public static class Create extends PolisDTO{ }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("PolisUpdateRq")
    public static class Update extends Create{
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("PolisDeleteRq")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PolisSpecRs")
    public static class PolisSpecRs{
        private PolisDTO.SpecRs response;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs{
        private List<PolisDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
