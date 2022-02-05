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
public class CheckListItemDTO implements Serializable {
    @ApiModelProperty(required = true)
    protected String group;
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private Long checkListId;
    @ApiModelProperty(required = true)
    private Boolean isDeleted;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListItemInfo")
    public static class Info extends CheckListItemDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListItemCreateRq")
    public static class Create extends CheckListItemDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListItemUpdateRq")
    public static class Update extends CheckListItemDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListItemDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListItemIdListRq")
    public static class CheckListItemIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CheckListItemSpecRs")
    public static class CheckListItemSpecRs {
        private CheckListItemDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CheckListItemDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
