package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class GenericPermissionDTO {
    private Long objectId;
    private String objectType;
    private Long workGroupId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Generic_Permission - Info")
    public static class Info extends GenericPermissionDTO {
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Generic_Permission - Update")
    public static class Update extends GenericPermissionDTO {
        private List<Long> categories;
        private List<Long> parameterValues;
        private List<Long> departments;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class PermissionFormData {
        String entityName;
        List<Info> columnDataList;
    }
}
