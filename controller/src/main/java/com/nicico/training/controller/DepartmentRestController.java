package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.DepartmentDTO;
import com.nicico.training.iservice.IDepartmentService;
import com.nicico.training.service.BaseService;
import com.nicico.training.utility.SpecListUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/department")
public class DepartmentRestController {

    private final SpecListUtil specListUtil;
    private final IDepartmentService departmentService;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<DepartmentDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(departmentService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    //@PreAuthorize("hasAuthority('r_department')")
    public ResponseEntity<List<DepartmentDTO.Info>> list() {
        return new ResponseEntity<>(departmentService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_evaluationResult')")
    public ResponseEntity<TotalResponse<DepartmentDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {

        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(departmentService.search(nicicoCriteria), HttpStatus.OK);
    }

    // ------------------------------
    @Loggable
    @GetMapping(value = "/departmentGridFetch")
//	@PreAuthorize("hasAuthority('r_zoneIndex')")
    public ResponseEntity<DepartmentDTO.DepartmentSpecRs> list(
            @RequestParam("_startRow") Integer startRow,
            @RequestParam("_endRow") Integer endRow,
            @RequestParam(value = "_sortBy", required = false) String sortBy,
            @RequestParam(value = "operator", required = false) String operator,
            @RequestParam(value = "criteria", required = false) String criteria,
            final HttpServletRequest httpRequest
    ) throws IOException {
        String criteria1 = criteria;

        if (criteria != null && criteria.contains("depParrentId") && criteria.contains("null"))
            criteria1 = criteria.substring(0, (criteria.lastIndexOf("{") - 1));

        DepartmentDTO.DepartmentSpecRs specRs = specListUtil.createSearchRq(startRow, endRow, operator, criteria1, sortBy, request -> {
            SearchDTO.SearchRs<DepartmentDTO.Info> response = departmentService.search(request);
            List<DepartmentDTO.Info> departmentList;
            if (criteria == null) {
                if (httpRequest.getParameter("depParrentId") == null ||
                        (httpRequest.getParameter("depParrentId") != null && httpRequest.getParameter("depParrentId").equalsIgnoreCase("null"))
                ) {
                    departmentList = departmentService.findRootNode();
                } else {
                    Long parentId = new Long(httpRequest.getParameter("depParrentId"));
                    departmentList = departmentService.findByParentId(parentId);
                }
                response.setList(departmentList);
            } else if (!criteria.contains("null")) {
                String[] temp = criteria.split("depParrentId");
                Long parentId = new Long(temp[1].substring(10, 22));
                departmentList = departmentService.findByParentId(parentId);
                response.setList(departmentList);
            }


            final DepartmentDTO.SpecRs specResponse = new DepartmentDTO.SpecRs();
            specResponse.setData(response.getList())
                    .setStartRow(startRow)
                    .setEndRow(startRow + response.getList().size())
                    .setTotalRows(response.getTotalCount().intValue());

            return new DepartmentDTO.DepartmentSpecRs().setResponse(specResponse);
        });

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_department')")

    public ResponseEntity<SearchDTO.SearchRs<DepartmentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(departmentService.search(request), HttpStatus.OK);
    }

    @GetMapping("/all-field-values")
    public ResponseEntity<ISC<DepartmentDTO.FieldValue>> findAllValuesOfOneFieldFromDepartment(@RequestParam String fieldName) {
        return new ResponseEntity<>(ISC.convertToIscRs(departmentService.findAllValuesOfOneFieldFromDepartment(fieldName), 0), HttpStatus.OK);
    }

    @GetMapping("/organ-segment-iscList/{fieldName}")
    public ResponseEntity<ISC<DepartmentDTO.OrganSegment>> getOrganSegmentList(@PathVariable String fieldName, HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(departmentService.getOrganSegmentList(fieldName, searchRq), searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<ISC<DepartmentDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<DepartmentDTO.Info> searchRs = departmentService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/getDepChartData")
    public ResponseEntity<List<DepartmentDTO.DepChart>> getDepChartData() {
        List<DepartmentDTO.DepChart> depChartRoots = departmentService.getDepChartData();
        return new ResponseEntity<>(depChartRoots, HttpStatus.OK);
    }

    @PostMapping(value = "/getDepChartChildren/{category}/{parentTitle}")
    public ResponseEntity<List<DepartmentDTO.DepChart>> getDepChartChildren(@PathVariable String category, @PathVariable String parentTitle, @RequestBody List<Long> childrenIds) {
        List<DepartmentDTO.DepChart> depChartRoots = departmentService.getDepChartChildren(category, parentTitle, childrenIds);
        return new ResponseEntity<>(depChartRoots, HttpStatus.OK);
    }

    @GetMapping(value = "/getSearchDepChartData/{value}")
    public ResponseEntity<List<DepartmentDTO.DepChart>> getSearchDepChartData(@PathVariable String value) {
        List<DepartmentDTO.DepChart> depChartRoots = departmentService.getSearchDepChartData(value);
        return new ResponseEntity<>(depChartRoots, HttpStatus.OK);
    }

    @GetMapping(value = "/getDepartmentsRoot")
    public ResponseEntity<List<DepartmentDTO.TSociety>> getDepartmentsRoot() {
        List<DepartmentDTO.TSociety> roots = departmentService.getRoot();
        for (DepartmentDTO.TSociety root : roots)
            root.setParentId(0L);
        return new ResponseEntity<>(roots, HttpStatus.OK);
    }

    @GetMapping(value = "/getDepartmentsByParentId/{parentId}")
    public ResponseEntity<List<DepartmentDTO.TSociety>> getDepartmentsByParentId(@PathVariable Long parentId) {
        return new ResponseEntity<>(departmentService.getDepartmentByParentId(parentId), HttpStatus.OK);
    }

    @PostMapping(value = "/getDepartmentsChilderen")
    public ResponseEntity<List<DepartmentDTO.TSociety>> getDepartmentsChilderen(@RequestBody List<Long> childeren) {
        List<DepartmentDTO.TSociety> result = departmentService.getDepartmentsByParentIds(childeren);
        return new ResponseEntity<>(result, HttpStatus.OK);

    }

    @GetMapping(value = "/searchSocieties")
    public ResponseEntity<List<DepartmentDTO.TSociety>> searchSocieties(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(null);
        searchRq.setCount(null);
        return new ResponseEntity<>(departmentService.searchSocieties(searchRq), HttpStatus.OK);
    }

}
