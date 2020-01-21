package com.nicico.training.dto;

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
    private Long workGroupId;

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class ColumnData {
        String filedName;
        String columnName;
        String description;
        //        Class fieldType;
        List values;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class PermissionFormData {
        String entityName;
        List<ColumnData> columnDataList;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class PermissionUpdate {
        String entityName;
        String columnName;
        List values;
    }

}
