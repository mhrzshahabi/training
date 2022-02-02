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
public class StateDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String name;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StateInfo")
    public static class Info extends StateDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StateCreateRq")
    public static class Create extends StateDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StateUpdateRq")
    public static class Update extends StateDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StateDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("StateSpecRs")
    public static class StateSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

