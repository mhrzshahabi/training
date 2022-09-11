package com.nicico.training.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.iservice.IOperationalChartService;
import com.nicico.training.repository.ComplexDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/operationalchart")
public class OperationalChartRestController {
    private final IOperationalChartService operationalChartService;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<OperationalChartDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(operationalChartService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/list")
    public ResponseEntity<List<OperationalChartDTO.Info>> list(@RequestBody Long complexId) {
        return new ResponseEntity<>(operationalChartService.list(complexId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
    public ResponseEntity<OperationalChartDTO.Info> create(@Validated @RequestBody OperationalChartDTO.Create request) {
        return new ResponseEntity<>(operationalChartService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/removeOldParent/{childId}")
    public ResponseEntity<OperationalChartDTO.Info> removeOldParent(@PathVariable Long childId) {
        return new ResponseEntity<>(operationalChartService.removeOldParent(childId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addchild/{child_id}/{parent_id}")
    public ResponseEntity<OperationalChartDTO.Info> addChild(@PathVariable Long parent_id, @PathVariable Long child_id) {
        return new ResponseEntity<>(operationalChartService.addChild(parent_id, child_id), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/update/{id}")
    public ResponseEntity<OperationalChartDTO.Info> update(@PathVariable Long id, @Validated @RequestBody OperationalChartDTO.Update request) {
        return new ResponseEntity<>(operationalChartService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        operationalChartService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<OperationalChartDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setDistinct(true);
        SearchDTO.SearchRs<OperationalChartDTO.Info> searchRs = null;

        try {
            searchRs = operationalChartService.deepSearch(searchRq,null);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/parent-list/{complexId}")
    public ResponseEntity<ISC<OperationalChartDTO.Info>> parentList(HttpServletRequest iscRq,@PathVariable Long complexId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setDistinct(true);
        SearchDTO.SearchRs<OperationalChartDTO.Info> searchRs = null;

        try {
            searchRs = operationalChartService.deepSearch(searchRq,complexId);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<OperationalChartDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(operationalChartService.search(request), HttpStatus.OK);
    }

}
