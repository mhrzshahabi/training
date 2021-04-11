package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.GenericPermission;
import com.nicico.training.model.Permission;
import com.nicico.training.model.WorkGroup;
import com.nicico.training.repository.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.*;
import java.lang.reflect.Field;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkGroupService implements IWorkGroupService {

    private final EntityManager entityManager;
    private final ModelMapper modelMapper;
    private final WorkGroupDAO workGroupDAO;
    private final PermissionDAO permissionDAO;
    private final GenericPermissionDAO genericPermissionDAO;
    private final SkillDAO skillDAO;
    private final CourseDAO courseDAO;
    private final TclassDAO tclassDAO;

    @Transactional(readOnly = true)
    @Override
    public WorkGroup getWorkGroup(Long id) {
        Optional<WorkGroup> optionalWorkGroup = workGroupDAO.findById(id);
        return optionalWorkGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public WorkGroupDTO.Info create(WorkGroupDTO.Create request) {
        try {
            WorkGroup creating = modelMapper.map(request, WorkGroup.class);
            return modelMapper.map(workGroupDAO.saveAndFlush(creating), WorkGroupDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public WorkGroupDTO.Info update(Long id, WorkGroupDTO.Update request) {
        final WorkGroup workGroup = getWorkGroup(id);
        WorkGroup updating = new WorkGroup();
        modelMapper.map(workGroup, updating);
        modelMapper.map(request, updating);
        updating.setUserIds(request.getUserIds());
        try {
            return modelMapper.map(workGroupDAO.saveAndFlush(updating), WorkGroupDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public List<GenericPermissionDTO.Info> editGenericPermissionList(GenericPermissionDTO.Update rq, Long workGroupId) {

        List<GenericPermissionDTO.Info> response;

        List<GenericPermission> deleteIds = genericPermissionDAO.findByObjectIdNotInAndAndWorkGroupIdAndObjectType(rq.getCategories() == null ? new ArrayList<>() : rq.getCategories(), workGroupId, "Category");
        List<GenericPermission> existIds = new ArrayList<>();

        if (rq.getCategories() != null) {
            existIds = genericPermissionDAO.findByObjectIdInAndAndWorkGroupIdAndObjectType(rq.getCategories(), workGroupId, "Category");
        }

        List<Long> insertIds = new ArrayList<Long>();

        if (rq.getCategories() != null) {
            for (Long id : rq.getCategories()) {
                if (existIds.stream().filter(p -> p.getObjectId().longValue() == id.longValue()).count() == 0) {
                    insertIds.add(id);
                }
            }
        }

        for (GenericPermission genericPermission : deleteIds) {
            genericPermissionDAO.deleteById(genericPermission.getId());
        }

        for (Long id : insertIds) {
            GenericPermission genericPermission = new GenericPermission();

            genericPermission.setWorkGroupId(workGroupId);
            genericPermission.setObjectId(id);
            genericPermission.setObjectType("Category");

            genericPermissionDAO.saveAndFlush(genericPermission);
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        deleteIds = genericPermissionDAO.findByObjectIdNotInAndAndWorkGroupIdAndObjectType(rq.getDepartments() == null ? new ArrayList<>() : rq.getDepartments(), workGroupId, "Department");
        existIds = new ArrayList<>();

        if (rq.getDepartments() != null) {
            existIds = genericPermissionDAO.findByObjectIdInAndAndWorkGroupIdAndObjectType(rq.getDepartments(), workGroupId, "Department");
        }
        insertIds = new ArrayList<Long>();

        if (rq.getDepartments() != null) {
            for (Long id : rq.getDepartments()) {
                if (existIds.stream().filter(p -> p.getObjectId().longValue() == id.longValue()).count() == 0) {
                    insertIds.add(id);
                }
            }
        }


        for (GenericPermission genericPermission : deleteIds) {
            genericPermissionDAO.deleteById(genericPermission.getId());
        }

        for (Long id : insertIds) {
            GenericPermission genericPermission = new GenericPermission();

            genericPermission.setWorkGroupId(workGroupId);
            genericPermission.setObjectId(id);
            genericPermission.setObjectType("Department");

            genericPermissionDAO.saveAndFlush(genericPermission);
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        deleteIds = genericPermissionDAO.findByObjectIdNotInAndAndWorkGroupIdAndObjectType(rq.getParameterValues() == null ? new ArrayList<>() : rq.getParameterValues(), workGroupId, "ParameterValue");
        existIds = new ArrayList<>();

        if (rq.getParameterValues() != null) {
            existIds = genericPermissionDAO.findByObjectIdInAndAndWorkGroupIdAndObjectType(rq.getParameterValues(), workGroupId, "ParameterValue");
        }
        insertIds = new ArrayList<Long>();

        if (rq.getParameterValues() != null) {
            for (Long id : rq.getParameterValues()) {
                if (existIds.stream().filter(p -> p.getObjectId().longValue() == id.longValue()).count() == 0) {
                    insertIds.add(id);
                }
            }
        }

        for (GenericPermission genericPermission : deleteIds) {
            genericPermissionDAO.deleteById(genericPermission.getId());
        }

        for (Long id : insertIds) {
            GenericPermission genericPermission = new GenericPermission();

            genericPermission.setWorkGroupId(workGroupId);
            genericPermission.setObjectId(id);
            genericPermission.setObjectType("ParameterValue");

            genericPermissionDAO.saveAndFlush(genericPermission);
        }

        response = modelMapper.map(genericPermissionDAO.findAllByWorkGroupId(workGroupId), new TypeToken<List<GenericPermissionDTO.Info>>() {
        }.getType());

        return response;
    }

    @Transactional
    @Override
    public List<PermissionDTO.Info> editPermissionList(PermissionDTO.CreateOrUpdate[] rq, Long workGroupId) {
        List<PermissionDTO.Info> response = new ArrayList<>();
        for (PermissionDTO.CreateOrUpdate createOrUpdate : rq) {
            Optional<Permission> optional = permissionDAO.findByEntityNameAndAndAttributeNameAndWorkGroupId(
                    createOrUpdate.getEntityName(),
                    createOrUpdate.getAttributeName(),
                    workGroupId
            );
            if (optional.isPresent() && (createOrUpdate.getAttributeValues() == null || createOrUpdate.getAttributeValues().isEmpty())) {
                permissionDAO.delete(optional.get());
                continue;
            }
            Permission permission = new Permission();
            permission.setWorkGroupId(workGroupId);
            optional.ifPresent(opt -> modelMapper.map(opt, permission));
            modelMapper.map(createOrUpdate, permission);
            permission.setAttributeValues(createOrUpdate.getAttributeValues());
            try {
                response.add(modelMapper.map(permissionDAO.saveAndFlush(permission), PermissionDTO.Info.class));
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        }
        return response;
    }

    @Transactional
    @Override
    public void deleteAll(List<Long> request) {
        final List<WorkGroup> gAllById = workGroupDAO.findAllById(request);
        workGroupDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<WorkGroupDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(workGroupDAO, request, job -> modelMapper.map(job, WorkGroupDTO.Info.class));
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Transactional(readOnly = true)
    @Override
    public List<PermissionDTO.PermissionFormData> getEntityAttributesList(List<String> entityList) {

        Class<?> entityType = null;
        String tableName;
        List<Field> fieldNameList;
        List<Object[]> columnList;
        String columnListQuery;
        String valuesQuery;
        String columnName = null;

        List<PermissionDTO.PermissionFormData> permissionFormData = new ArrayList<>();
        for (String entity : entityList) {
            try {
                entityType = Class.forName("com.nicico.training.model." + entity);
            } catch (ClassNotFoundException e) {
                log.error("Exception", e);
            }
            assert entityType != null;
            tableName = entityType.getAnnotation(Table.class).name().toUpperCase();
            fieldNameList = Arrays.asList(entityType.getDeclaredFields());
            columnListQuery = "SELECT column_name, c.comments " +
                    "FROM user_col_comments c JOIN user_tab_cols k " +
                    "USING(table_name,column_name) " +
                    "WHERE table_name = :tableName " +
                    "AND column_name NOT IN ('ID','C_CREATED_BY','D_CREATED_DATE','E_DELETED','E_ENABLED','C_LAST_MODIFIED_BY','D_LAST_MODIFIED_DATE','N_VERSION')";
            columnList = (List<Object[]>) entityManager.createNativeQuery(columnListQuery).setParameter("tableName", tableName).getResultList();

            List<PermissionDTO.Info> columnDataList = new ArrayList<>();
            for (Field field : fieldNameList) {
                if (field.getName().toLowerCase().equals("id"))
                    continue;

                if (field.getAnnotation(Column.class) != null) {
                    for (Object[] column : columnList) {
                        if (String.valueOf(column[0]).toLowerCase().equals(field.getAnnotation(Column.class).name().toLowerCase())) {
                            columnName = (String.valueOf(column[0]).toLowerCase());
                            break;
                        }
                    }
                    if (columnName.startsWith("f_"))
                        continue;
                    Permission attributeData = new Permission();
                    attributeData.setAttributeName(field.getName());
                    attributeData.setAttributeType(field.getType().getName().replace(".", "_"));
                    valuesQuery = "SELECT DISTINCT " + columnName + " FROM " + tableName + " ORDER BY " + columnName;
                    attributeData.setAttributeValues(entityManager.createNativeQuery(valuesQuery).getResultList());
                    attributeData.setEntityName(entityType.getName());
                    columnDataList.add(modelMapper.map(attributeData, PermissionDTO.Info.class));
                }
            }
            permissionFormData.add(new PermissionDTO.PermissionFormData(entityType.getSimpleName(), columnDataList));
        }
        return permissionFormData;
    }

    @Transactional(readOnly = true)
    @Override
    public List<GenericPermissionDTO.Info> getAllGenericPermissions(Long workGroupId) {

        return modelMapper.map(genericPermissionDAO.findAllByWorkGroupId(workGroupId), new TypeToken<List<GenericPermissionDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.CriteriaRq getUnassignedRecordsCriteria(String entityName) {
        List<Permission> permissions = permissionDAO.findByEntityName(entityName);
        SearchDTO.CriteriaRq rq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        if (permissions.size() == 0)
            return rq;
        List<List<Permission>> pGroupByWorkGroup = new ArrayList<>(permissions.stream().collect(Collectors.groupingBy(Permission::getWorkGroupId)).values());
        pGroupByWorkGroup.forEach(pForOneWG -> {
            SearchDTO.CriteriaRq criteriaRqs = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
            pForOneWG.forEach(permission -> permissionToCriteria(criteriaRqs, permission, EOperator.notEqual));
            if (criteriaRqs.getCriteria().size() > 0)
                rq.getCriteria().add(criteriaRqs);
        });
        return rq;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.CriteriaRq applyPermissions(Class entity, Long userId) {
        String query = "SELECT F_WORK_GROUP FROM TBL_WORK_GROUP_USER_IDS WHERE USER_IDS = " + userId;
        List<Long> workGroupIds = modelMapper.map(entityManager.createNativeQuery(query).getResultList(), new TypeToken<List<Long>>() {
        }.getType());
        SearchDTO.CriteriaRq rq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        for (Long workGroupId : workGroupIds) {
            SearchDTO.CriteriaRq criteriaRqs = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            List<Permission> permissions = permissionDAO.findByEntityNameAndWorkGroupId(entity.getName(), workGroupId);
            permissions.forEach(permission -> permissionToCriteria(criteriaRqs, permission, EOperator.equals));
            if (criteriaRqs.getCriteria().size() > 0)
                rq.getCriteria().add(criteriaRqs);
        }
        if (rq.getCriteria().size() == 0)
            rq.getCriteria().add(makeNewCriteria("id", 0L, EOperator.equals, null));
        return rq;
    }

    private void permissionToCriteria(SearchDTO.CriteriaRq criteriaRqs, Permission permission, EOperator operator) {
        try {
            Class<?> attributeType = Class.forName(permission.getAttributeType().replace("_", "."));
            List values = new ArrayList();
            for (String value : permission.getAttributeValues()) {
                values.add(attributeType.cast(value));
            }
            criteriaRqs.getCriteria().add(makeNewCriteria(permission.getAttributeName(), values, operator, null));
        } catch (ClassNotFoundException e) {
            log.error("Exception", e);

        }
    }

    @Transactional(readOnly = true)
    @Override
    public boolean isAllowUseId(String entity, Long Id) {
        try {

            switch (entity) {
                case "Skill":
                    return setCriteria(skillDAO,p -> modelMapper.map(p, SkillDTO.Info.class),Id,"categoryId");
                case "Course":
                    return setCriteria(courseDAO,p -> modelMapper.map(p, CourseDTO.Info.class),Id,"categoryId");
                case "Tclass":
                    return setCriteria(tclassDAO,p -> modelMapper.map(p, TclassDTO.Info.class),Id,"course.categoryId");
            }

            return false;

        } catch (Exception ex) {
            return false;
        }

    }

    @Override
    public Boolean hasAccess(Long userId, List<String> groupIds) {
        for (String groupId:groupIds)
        {
            WorkGroup workGroup= workGroupDAO.findByIdAndFetchUserIdsEagerly(Long.parseLong(groupId));
            if (workGroup!=null && !workGroup.getUserIds().isEmpty() && workGroup.getUserIds().contains(userId)){
                return true;
            }
        }
           return false;
    }

    @Override
    public Map<String,Boolean> hasAccessToGroups(Long userId, List<String> groupIds) {
        final Map<String, Boolean> response = new HashMap<>();
        for (String groupId:groupIds)
        {
            WorkGroup workGroup= workGroupDAO.findByIdAndFetchUserIdsEagerly(Long.parseLong(groupId));
            response.put(groupId, workGroup != null && !workGroup.getUserIds().isEmpty() && workGroup.getUserIds().contains(userId));
        }
           return response;
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.CriteriaRq addPermissionToCriteria(String fieldName, SearchDTO.CriteriaRq criteriaRq) {

        Long userId = SecurityUtil.getUserId();

        SearchDTO.CriteriaRq tmpCriteria = null;
        List<SearchDTO.CriteriaRq> listCriteria = new ArrayList<>();

        SearchDTO.CriteriaRq result = new SearchDTO.CriteriaRq();
        result.setOperator(EOperator.and);

        if (criteriaRq != null) {
            listCriteria.add(criteriaRq);
        }

        List<Long> ids = new ArrayList<>();

        genericPermissionDAO.findByObjectTypeAndAndWorkGroupUserIds("Category", userId).stream().forEach(p -> ids.add(p.getObjectId()));

        tmpCriteria = new SearchDTO.CriteriaRq();

        SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.inSet);
        criteriaRq1.setFieldName(fieldName);
        if (ids.size() == 0) {
            ids.add(-1L);
            criteriaRq1.setValue(ids);
        } else {
            criteriaRq1.setValue(ids);
        }

        SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
        criteriaRq2.setOperator(EOperator.isNull);
        criteriaRq2.setFieldName(fieldName);

        ArrayList<SearchDTO.CriteriaRq> criteriaRqs = new ArrayList<>();
        criteriaRqs.add(criteriaRq1);
        criteriaRqs.add(criteriaRq2);
        tmpCriteria.setCriteria(criteriaRqs);
        tmpCriteria.setOperator(EOperator.or);



        listCriteria.add(tmpCriteria);

        result.setCriteria(listCriteria);

        return result;
    }


    private <INFO, E, DAO extends JpaSpecificationExecutor> boolean setCriteria(DAO dao, Function<E, INFO> converter, Long Id, String fieldName) {
        Long userId = SecurityUtil.getUserId();
        final List<Long> ids = new ArrayList<>();

        genericPermissionDAO.findByObjectTypeAndAndWorkGroupUserIds("Category", userId).stream().forEach(p -> ids.add(p.getObjectId()));
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();

        searchRq.setCount(1);
        searchRq.setStartIndex(0);
        searchRq.setCriteria(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().setOperator(EOperator.and);
        searchRq.getCriteria().setCriteria(new ArrayList<>());
        searchRq.getCriteria().getCriteria().add(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().getCriteria().get(0).setOperator(EOperator.equals);
        searchRq.getCriteria().getCriteria().get(0).setValue(Id);
        searchRq.getCriteria().getCriteria().get(0).setFieldName("id");

        searchRq.getCriteria().getCriteria().add(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().getCriteria().get(1).setOperator(EOperator.inSet);
        searchRq.getCriteria().getCriteria().get(1).setValue(ids);
        searchRq.getCriteria().getCriteria().get(1).setFieldName(fieldName);

        SearchDTO.SearchRs<INFO> result = SearchUtil.search(dao, searchRq, converter);

        if (result.getTotalCount() == 0) {
            return false;
        } else {
            return true;
        }
    }
}
