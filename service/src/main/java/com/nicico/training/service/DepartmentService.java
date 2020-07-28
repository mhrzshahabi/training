package com.nicico.training.service;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.DepartmentDTO;
import com.nicico.training.iservice.IDepartmentService;
import com.nicico.training.model.Department;
import com.nicico.training.repository.DepartmentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class DepartmentService extends GenericService<Department, Long, DepartmentDTO.Info, Object, Object, Object> implements IDepartmentService {

    private final ModelMapper modelMapper;
    private final DepartmentDAO departmentDAO;

    @Override
    @Transactional(readOnly = true)
    @PreAuthorize("hasAuthority('Department_R')")
    public List<DepartmentDTO.Info> findRootNode() {

        final List<Department> slAll = departmentDAO.findRootNode();
        return modelMapper.map(slAll, new TypeToken<List<DepartmentDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional(readOnly = true)
    @PreAuthorize("hasAuthority('Department_R')")
    public List<DepartmentDTO.Info> findByParentId(Long parentId) {

        final List<Department> mainForm = departmentDAO.findAllByParentId(parentId);
        return modelMapper.map(mainForm, new TypeToken<List<DepartmentDTO.Info>>() {
        }.getType());
    }

    // unavailable services

    @Override
    public DepartmentDTO.Info create(Object request) {
        return null;
    }

    @Override
    public DepartmentDTO.Info save(Department entity) {
        return null;
    }

    @Override
    public DepartmentDTO.Info update(Object request) {
        return null;
    }

    @Override
    public DepartmentDTO.Info update(Long aLong, Object request) {
        return null;
    }

    @Override
    public List<DepartmentDTO.Info> createAll(List<Object> requests) {
        return null;
    }

    @Override
    public List<DepartmentDTO.Info> saveAll(List<Department> entities) {
        return null;
    }

    @Override
    public List<DepartmentDTO.Info> updateAll(List<Object> requests) {
        return null;
    }

    @Override
    public List<DepartmentDTO.Info> updateAll(List<Long> longs, List<Object> requests) {
        return null;
    }

    @Override
    public void delete(Long aLong) {

    }

    @Override
    public void deleteAll(Object request) {

    }

    //Amin HK
    @Override
    @Transactional
    public SearchDTO.SearchRs<DepartmentDTO.FieldValue> findAllValuesOfOneFieldFromDepartment(String fieldName) {
        List<String> values = null;
        switch (fieldName) {
            case "ccpAffairs":
                values = departmentDAO.findAllAffairsFromDepartment();
                break;

             case "ccpUnit":
                values = departmentDAO.findAllUnitsFromDepartment();
                break;

            case "ccpAssistant":
                values = departmentDAO.findAllAssistantsFromDepartment();
                break;

           case "ccpArea":
                values = departmentDAO.findAllAreasFromDepartment();
                break;

            case "complexTitle":
                values = departmentDAO.findAllComplexsFromDepartment();
                break;

            case "ccpSection":
                values = departmentDAO.findAllSectionsFromDepartment();
                break;
        }

        SearchDTO.SearchRs<DepartmentDTO.FieldValue> response = new SearchDTO.SearchRs<>();
        response.setList(new ArrayList<>());
        values.forEach(value -> response.getList().add(new DepartmentDTO.FieldValue(value)));
        response.setTotalCount((long) response.getList().size());
        return response;
    }
}
