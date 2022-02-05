package com.nicico.training.dto;

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
public class CheckListDTO implements Serializable {
    @ApiModelProperty(required = true)
    private String titleFa;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListInfo")
    public static class Info extends CheckListDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListCreateRq")
    public static class Create extends CheckListDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListUpdateRq")
    public static class Update extends CheckListDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CheckListIdListRq")
    public static class CheckListIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CheckListSpecRs")
    public static class CheckListSpecRs {
        private CheckListDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CheckListDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
