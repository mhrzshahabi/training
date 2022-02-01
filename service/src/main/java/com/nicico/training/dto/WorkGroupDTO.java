package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

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
        private Set<PermissionDTO.Info> permissions;
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
}
