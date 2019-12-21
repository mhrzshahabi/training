package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.DepartmentDTO;
import com.nicico.training.iservice.IDepartmentService;
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
                        (httpRequest.getParameter("depParrentId") != null && httpRequest.getParameter("depParrentId").toString().equalsIgnoreCase("null"))
                ) {
                    departmentList = departmentService.findRootNode();
                } else {
                    Long parentId = new Long(httpRequest.getParameter("depParrentId").toString());
                    departmentList = departmentService.findByParentId(parentId);
                }
                if (departmentList != null && departmentList.size() > 0) {
                    for (int i = 0; i < departmentList.size(); i++) {
                        if (departmentList.get(i).getParentDepartment() != null)
                            departmentList.get(i).setDepParrentId(departmentList.get(i).getParentDepartment().getId());
                    }
                }
                response.setList(departmentList);
            } else if (criteria != null && !criteria.contains("null")) {
                String[] temp = criteria.split("depParrentId");
                Long parentId = new Long(temp[1].substring(10, 22).toString());
                departmentList = departmentService.findByParentId(parentId);
                if (departmentList != null && departmentList.size() > 0) {
                    for (int i = 0; i < departmentList.size(); i++) {
                        if (departmentList.get(i).getParentDepartment() != null)
                            departmentList.get(i).setDepParrentId(departmentList.get(i).getParentDepartment().getId());
                    }
                }
                response.setList(departmentList);
            }


            final DepartmentDTO.SpecRs specResponse = new DepartmentDTO.SpecRs();
            specResponse.setData(response.getList())
                    .setStartRow(startRow)
                    .setEndRow(startRow + response.getTotalCount().intValue())
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
}
