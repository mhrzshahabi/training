package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.DepartmentDTO;
import com.nicico.training.iservice.IDepartmentService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@RequiredArgsConstructor
@Service
public class DepartmentService extends GenericService<Department, Long, DepartmentDTO.Info, Object, Object, Object> implements IDepartmentService {

    private final ModelMapper modelMapper;
    private final DepartmentDAO departmentDAO;
    private final ComplexDAO complexDAO;
    private final AssistantDAO assistantDAO;
    private final AffairsDAO affairsDAO;
    private final SectionDAO sectionDAO;
    private final UnitDAO unitDAO;

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
        if (values != null) {
            values.forEach(value -> response.getList().add(new DepartmentDTO.FieldValue(value)));
        }
        response.setTotalCount((long) response.getList().size());
        return response;
    }

    @Override
    @Transactional
    public SearchDTO.SearchRs<DepartmentDTO.OrganSegment> getOrganSegmentList(String fieldName, SearchDTO.SearchRq request) {
        switch (fieldName) {
            case "complexTitle":
            case "mojtame":
                return SearchUtil.search(complexDAO, request, d -> modelMapper.map(d, DepartmentDTO.OrganSegment.class));

            case "ccpAssistant":
            case "moavenat":
                return SearchUtil.search(assistantDAO, request, d -> modelMapper.map(d, DepartmentDTO.OrganSegment.class));

            case "ccpAffairs":
            case "omor":
                return SearchUtil.search(affairsDAO, request, d -> modelMapper.map(d, DepartmentDTO.OrganSegment.class));

            case "ccpSection":
            case "ghesmat":
                return SearchUtil.search(sectionDAO, request, d -> modelMapper.map(d, DepartmentDTO.OrganSegment.class));

            case "ccpUnit":
            case "vahed":
                return SearchUtil.search(unitDAO, request, d -> modelMapper.map(d, DepartmentDTO.OrganSegment.class));
            default:
                SearchDTO.SearchRs<DepartmentDTO.OrganSegment> nullResp = new SearchDTO.SearchRs<>();
                nullResp.setList(new ArrayList<>());
                nullResp.setTotalCount(0L);
                return nullResp;
        }
    }

    @Override
    public List<DepartmentDTO.DepChart> getDepChartData() {

        List<DepartmentDTO.DepChart> complexes = modelMapper.map(complexDAO.findAll(), new TypeToken<List<DepartmentDTO.DepChart>>() {
        }.getType());
        complexes.forEach(complex -> {
            complex.setParentTitle("");
            complex.setCategory("complex");
        });

        List<Assistant> assistants = assistantDAO.findAll();
        assistants.forEach(assistant -> {
            DepartmentDTO.DepChart map = modelMapper.map(assistant, DepartmentDTO.DepChart.class);
            map.setParentTitle(assistant.getMojtameTitle());
            map.setCategory("assistant");
            complexes.add(map);
        });

        List<Affairs> affairs = affairsDAO.findAll();
        affairs.forEach(affair -> {
            DepartmentDTO.DepChart map = modelMapper.map(affair, DepartmentDTO.DepChart.class);
            map.setParentTitle(affair.getMoavenatTitle());
            map.setCategory("affair");
            complexes.add(map);
        });

        List<Section> sections = sectionDAO.findAll();
        sections.forEach(section -> {
            DepartmentDTO.DepChart map = modelMapper.map(section, DepartmentDTO.DepChart.class);
            map.setParentTitle(section.getOmorTitle());
            map.setCategory("section");
            complexes.add(map);
        });

        List<Unit> units = unitDAO.findAll();
        units.forEach(unit -> {
            DepartmentDTO.DepChart map = modelMapper.map(unit, DepartmentDTO.DepChart.class);
            map.setParentTitle(unit.getGhesmatTitle());
            map.setCategory("unit");
            complexes.add(map);
        });

        return complexes;
    }

    @Override
    public List<DepartmentDTO.DepChart> getDepChartChildren(String category, String parentTitle, List<Long> childrenIds) {

        List<DepartmentDTO.DepChart> depChildren = new ArrayList<>();

        switch (category) {

            case "complex":
                List<Assistant> assistants = assistantDAO.findAllById(childrenIds);
                assistants.forEach(assistant -> {
                    DepartmentDTO.DepChart map = modelMapper.map(assistant, DepartmentDTO.DepChart.class);
                    map.setParentTitle(parentTitle);
                    map.setCategory("assistant");
                    depChildren.add(map);
                });
                break;

            case "assistant":
                List<Affairs> affairs = affairsDAO.findAllById(childrenIds);
                affairs.forEach(affair -> {
                    DepartmentDTO.DepChart map = modelMapper.map(affair, DepartmentDTO.DepChart.class);
                    map.setParentTitle(parentTitle);
                    map.setCategory("affair");
                    depChildren.add(map);
                });
                break;

            case "affair":
                List<Section> sections = sectionDAO.findAllById(childrenIds);
                sections.forEach(section -> {
                    DepartmentDTO.DepChart map = modelMapper.map(section, DepartmentDTO.DepChart.class);
                    map.setParentTitle(parentTitle);
                    map.setCategory("section");
                    depChildren.add(map);
                });
                break;

            case "section":
                List<Unit> units = unitDAO.findAllById(childrenIds);
                units.forEach(unit -> {
                    DepartmentDTO.DepChart map = modelMapper.map(unit, DepartmentDTO.DepChart.class);
                    map.setParentTitle(parentTitle);
                    map.setCategory("unit");
                    depChildren.add(map);
                });
                break;

            case "unit":
                break;
        }

        return depChildren;
    }

    @Override
    public List<DepartmentDTO.DepChart> getSearchDepChartData(String value) {

        List<DepartmentDTO.DepChart> depChartData = this.getDepChartData();
        return depChartData.stream().filter(data -> data.getTitle().contains(value)).collect(Collectors.toList());
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
        infoList.removeIf(removedObject -> removedObject.getId().equals(parentId));
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
            infoList.removeIf(removedObject -> parentsId.contains(removedObject.getId()));
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

    @Override
    public DepartmentDTO.Info getByCode(String code) {
        Optional<Department> optional = departmentDAO.getByCode(code);
        if (optional.isPresent())
            return modelMapper.map(optional.get(), DepartmentDTO.Info.class);
        return null;
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
