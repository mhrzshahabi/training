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
public class PermissionDTO {
    private String entityName;
    private String attributeName;
    private String attributeType;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Permission - Info")
    public static class Info extends PermissionDTO {
        private Long id;
        private Long workGroupId;
        private List attributeValues;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Permission - CreateOrUpdate")
    public static class CreateOrUpdate extends PermissionDTO {
        private List attributeValues;
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
