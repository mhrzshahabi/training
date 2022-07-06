package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.iservice.IOperationalChartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

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
    @GetMapping(value = "/list")
    public ResponseEntity<List<OperationalChartDTO.Info>> list() {
        return new ResponseEntity<>(operationalChartService.list(), HttpStatus.OK);
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
    public ResponseEntity<OperationalChartDTO.Info> addChild(@PathVariable Long parent_id,@PathVariable Long child_id) {
         return new ResponseEntity<>(operationalChartService.addChild(parent_id,child_id), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/update/{id}")
    public ResponseEntity<OperationalChartDTO.Info> update(@PathVariable Long id, @Validated @RequestBody OperationalChartDTO.Update request) {
        return new ResponseEntity<>(operationalChartService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/updateParent/{childId}/{newParentId}")
    public ResponseEntity<OperationalChartDTO.Info> updateParent(@PathVariable Long childId,@PathVariable Long newParentId) {
        return new ResponseEntity<>(operationalChartService.updateParent(childId,newParentId), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        operationalChartService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<OperationalChartDTO.OperationalCharSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                         @RequestParam(value = "_endRow", defaultValue = "75") Integer endRow,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<OperationalChartDTO.Info> response = operationalChartService.search(request);

        final OperationalChartDTO.SpecRs specResponse = new OperationalChartDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final OperationalChartDTO.OperationalCharSpecRs specRs = new OperationalChartDTO.OperationalCharSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<OperationalChartDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(operationalChartService.search(request), HttpStatus.OK);
    }

}
