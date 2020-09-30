package com.nicico.training.service;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
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

import java.io.IOException;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

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

    @Transactional(readOnly = true)
    public List<DepartmentDTO.TSociety> getRoot() {
        return modelMapper.map(departmentDAO.getRoot(), new TypeToken<List<DepartmentDTO.TSociety>>() {
        }.getType());
    }

    @Override
    public List<DepartmentDTO.TSociety> getDepartmentByParentId(Long parentId) {
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("parentId", parentId, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria("enabled", null, EOperator.isNull, null));
        searchRq.setCriteria(criteriaRq);
        List<DepartmentDTO.Info> infoList = search(searchRq).getList();
        Iterator<DepartmentDTO.Info> iterator = infoList.iterator();
        while (iterator.hasNext()) {
            DepartmentDTO.Info removedObject = iterator.next();
            if (removedObject.getId().equals(parentId))
                iterator.remove();
        }
        return modelMapper.map(infoList, new TypeToken<List<DepartmentDTO.TSociety>>() {
        }.getType());
    }

    @Override
    public List<DepartmentDTO.TSociety> getDepartmentsByParentIds(List<Long> parentsId) {
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        if (parentsId.size() > 0) {
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteriaRq.getCriteria().add(makeNewCriteria("parentId", parentsId, EOperator.inSet, null));
            criteriaRq.getCriteria().add(makeNewCriteria("enabled", null, EOperator.isNull, null));
            searchRq.setCriteria(criteriaRq);
            List<DepartmentDTO.Info> infoList = search(searchRq).getList();
            Iterator<DepartmentDTO.Info> iterator = infoList.iterator();
            while (iterator.hasNext()) {
                DepartmentDTO.Info removedObject = iterator.next();
                if (parentsId.contains(removedObject.getId()))
                    iterator.remove();
            }
            return modelMapper.map(infoList, new TypeToken<List<DepartmentDTO.TSociety>>() {
            }.getType());
        } else
            return new ArrayList<>();
    }

    @Override
    public List<DepartmentDTO.TSociety> searchSocieties(SearchDTO.SearchRq request) {
        List<DepartmentDTO.TSociety> infoList = modelMapper.map(search(request).getList(), new TypeToken<List<DepartmentDTO.TSociety>>() {
        }.getType());
        Set<DepartmentDTO.TSociety> departments = new HashSet<>();
        Long anccestorId = null;
        if (infoList.size() > 0) {
            List<DepartmentDTO.TSociety> roots = getRoot();
            DepartmentDTO.TSociety society = roots.get(0);
            anccestorId = roots.get(0).getId();
            society.setParentId(0L);
            departments.add(society);
        }
        for (DepartmentDTO.TSociety child : infoList) {
            departments.addAll(findDeparmentAnccestor(anccestorId, child.getParentId()));
            departments.add(child);
        }
        return new ArrayList<>(departments);
    }


    private List<DepartmentDTO.TSociety> findDeparmentAnccestor(Long anccestorId, Long parentId) {
        List<DepartmentDTO.TSociety> parents = new ArrayList<>();
        DepartmentDTO.TSociety parent = modelMapper.map(get(parentId), DepartmentDTO.TSociety.class);
        if (parent.getParentId().equals(anccestorId)) {
            parents.add(parent);
            return parents;
        } else {
            parents.add(parent);
            parents.addAll(findDeparmentAnccestor(anccestorId, parent.getParentId()));
        }
        return parents;
    }
}
