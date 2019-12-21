package com.nicico.training.service;

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

        final List<Department> mainForm = departmentDAO.getByDepParrentId(parentId);
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
}
