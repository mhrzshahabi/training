package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ClassCheckListDTO implements Serializable {
    @ApiModelProperty(required = true)
    private Boolean enableStatus;
    @ApiModelProperty(required = true)
    private String description;
    @ApiModelProperty(required = true)
    private Long checkListItemId;
    @ApiModelProperty(required = true)
    private Long tclassId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassCheckListInfo")
    public static class Info extends ClassCheckListDTO {
        private Long id;
        private CheckListItemDTO.Info checkListItem;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassCheckListCreateRq")
    public static class Create extends ClassCheckListDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassCheckListUpdateRq")
    public static class Update extends ClassCheckListDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassCheckListDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassCheckListIdListRq")
    public static class ClassCheckListIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassCheckListSpecRs")
    public static class ClassCheckListSpecRs {
        private ClassCheckListDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassCheckListDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

