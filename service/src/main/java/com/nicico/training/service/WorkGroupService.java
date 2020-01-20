package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PermissionDTO;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.model.WorkGroup;
import com.nicico.training.repository.WorkGroupDAO;
import lombok.*;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class WorkGroupService {

    private final EntityManager entityManager;
    private final ModelMapper modelMapper;
    private final WorkGroupDAO workGroupDAO;

    @Transactional(readOnly = true)
//    @Override
    public WorkGroup getWorkGroup(Long id) {
        Optional<WorkGroup> optionalWorkGroup = workGroupDAO.findById(id);
        return optionalWorkGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<WorkGroupDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(workGroupDAO, request, job -> modelMapper.map(job, WorkGroupDTO.Info.class));
    }

    @Transactional(readOnly = true)
//    @Override
    public List<PermissionDTO.PermissionFormData> getEntityAttributesList(List<String> entityList) {
        Class entityType = null;
        String tableName;
        List<Field> fieldNameList;
        List<Object[]> columnList;
        String columnListQuery;
        String valuesQuery;
        List<PermissionDTO.PermissionFormData> permissionFormData = new ArrayList<>();
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

            List<PermissionDTO.ColumnData> columnDataList = new ArrayList<>();
            for (Field field : fieldNameList) {
                if (field.getName().toLowerCase().equals("id") || field.getAnnotation(Column.class) == null)
                    continue;
                PermissionDTO.ColumnData columnData = new PermissionDTO.ColumnData();
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
            permissionFormData.add(new PermissionDTO.PermissionFormData(entityType.getName(), columnDataList));
        }
        return permissionFormData;
    }
}
