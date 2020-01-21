package com.nicico.training.dto;

import com.nicico.training.model.Permission;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class WorkGroupDTO {

    private String title;
    private String description;
    private Set<Long> userIds;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("WorkGroup - Info")
    public static class Info extends WorkGroupDTO {
        private Long id;
//        private Set<PermissionDTO.ColumnData> permissions;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("WorkGroup - Create")
    public static class Create extends WorkGroupDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("WorkGroup - Update")
    public static class Update extends WorkGroupDTO {
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("WorkGroup - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

}
