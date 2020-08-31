package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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
public class TargetSocietyDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    private Long societyId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TargetSociety - Info")
    public static class Info extends TargetSocietyDTO {
        private Long targetSocietyTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TargetSociety - Create")
    public static class Create extends TargetSocietyDTO {
        @ApiModelProperty(required = true)
        private Long tclassId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TargetSociety - Update")
    public static class Update extends Create {
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TargetSociety - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TargetSocietySpecRs")
    public static class TargetSocietySpecRs{
        private TargetSocietyDTO.SpecRs response;
    }

    // ------------------------------

    @Setter
    @Getter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs{
        private List<TargetSocietyDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
