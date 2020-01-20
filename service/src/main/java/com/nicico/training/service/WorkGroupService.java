package com.nicico.training.service;

import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.model.*;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class WorkGroupService {

    @Autowired
    protected EntityManager entityManager;

    public List<WorkGroupDTO.PermissionFormData> getEntityAttributesList(List<String> entityList) {
        Class entityType = null;
        String tableName;
        List<Field> fieldNameList;
        List<Object[]> columnList;
        String columnListQuery;
        String valuesQuery;
        List<WorkGroupDTO.PermissionFormData> permissionFormData = new ArrayList<>();
        for (String entity : entityList) {
            try {
                entityType = Class.forName(entity);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
//            switch (entity) {
//                case "Post": {
//                    entityType = Post.class;
//                    break;
//                }
//                case "Job": {
//                    entityType = Job.class;
//                    break;
//                }
//                case "PostGrade": {
//                    entityType = PostGrade.class;
//                    break;
//                }
//                case "PostGroup": {
//                    entityType = PostGroup.class;
//                    break;
//                }
//                case "JobGroup": {
//                    entityType = JobGroup.class;
//                    break;
//                }
//                case "PostGradeGroup": {
//                    entityType = PostGradeGroup.class;
//                    break;
//                }
//                case "Skill": {
//                    entityType = Skill.class;
//                    break;
//                }
//                case "SkillGroup": {
//                    entityType = SkillGroup.class;
//                    break;
//                }
//                default:
//                    continue;
//            }
            assert entityType != null;
            tableName = ((Table) entityType.getAnnotation(Table.class)).name().toUpperCase();
            fieldNameList = Arrays.asList(entityType.getDeclaredFields());
            columnListQuery = "SELECT column_name, c.comments " +
                    "FROM user_col_comments c JOIN user_tab_cols k " +
                    "USING(table_name,column_name) " +
                    "WHERE table_name = :tableName " +
                    "AND column_name NOT IN ('ID','C_CREATED_BY','D_CREATED_DATE','E_DELETED','E_ENABLED','C_LAST_MODIFIED_BY','D_LAST_MODIFIED_DATE','N_VERSION')";
            columnList = (List<Object[]>) entityManager.createNativeQuery(columnListQuery).setParameter("tableName", tableName).getResultList();

            List<WorkGroupDTO.ColumnData> columnDataList = new ArrayList<>();
            for (Field field : fieldNameList) {
                if (field.getName().toLowerCase().equals("id") || field.getAnnotation(Column.class) == null)
                    continue;
                WorkGroupDTO.ColumnData columnData = new WorkGroupDTO.ColumnData();
                if (field.getAnnotation(Column.class) != null) {
                    columnData.setFiledName(field.getName().toLowerCase());
                    for (Object[] column : columnList) {
                        if (String.valueOf(column[0]).toLowerCase().equals(field.getAnnotation(Column.class).name().toLowerCase())) {
                            columnData.setColumnName(String.valueOf(column[0]).toLowerCase());
                            columnData.setDescription(String.valueOf(column[1]).toLowerCase());
                            break;
                        }
                    }
                }
                if (columnData.getColumnName() != null && columnData.getColumnName().startsWith("f_")) {
                    //TODO
                } else if (columnData.getColumnName() != null) {
                    valuesQuery = "SELECT DISTINCT " + columnData.getColumnName() + " FROM " + tableName;
                    columnData.setValues(entityManager.createNativeQuery(valuesQuery).getResultList());
                }
                if (columnData.getColumnName() != null && !columnData.getColumnName().startsWith("f_"))
                    columnDataList.add(columnData);
            }
            permissionFormData.add(new WorkGroupDTO.PermissionFormData(entityType.getName(), columnDataList));
        }
        return permissionFormData;
    }
}
