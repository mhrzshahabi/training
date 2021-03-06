package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class OperationalRoleDTO {
    private String code;
    private String title;
    private String description;
    private Long operationalUnitId;
    private Set<Long> userIds;
    private Set<Long> postIds;
    private Long complexId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Info")
    public static class Info extends OperationalRoleDTO {
        private Long id;
        private OperationalUnitDTO.Info operationalUnit;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Create")
    public static class Create extends OperationalRoleDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Update")
    public static class Update extends OperationalRoleDTO {
        private Integer version;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRoleSpecRs")
    public static class OperationalRoleSpecRs {
        private OperationalRoleDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<OperationalRoleDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


}
