package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.service.OperationalUnitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/operationalUnit")
public class OperationalUnitRestController {


    private final OperationalUnitService operationalUnitService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    //*********************************

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(operationalUnitService.get(id), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<OperationalUnitDTO.Info>> list() {
        return new ResponseEntity<>(operationalUnitService.list(), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping
    public ResponseEntity<OperationalUnitDTO.Info> create(@RequestBody OperationalUnitDTO.Create req) {
        OperationalUnitDTO.Create create = (new ModelMapper()).map(req, OperationalUnitDTO.Create.class);
        return new ResponseEntity<>(operationalUnitService.create(create), HttpStatus.CREATED);
    }

    //*********************************

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        OperationalUnitDTO.Update update = (new ModelMapper()).map(request, OperationalUnitDTO.Update.class);
        return new ResponseEntity<>(operationalUnitService.update(id, update), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        operationalUnitService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody OperationalUnitDTO.Delete request) {
        operationalUnitService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<OperationalUnitDTO.OperationalUnitSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                   @RequestParam("_endRow") Integer endRow,
                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                   @RequestParam(value = "operator", required = false) String operator,
                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<OperationalUnitDTO.Info> response = operationalUnitService.search(request);

        final OperationalUnitDTO.SpecRs specResponse = new OperationalUnitDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final OperationalUnitDTO.OperationalUnitSpecRs specRs = new OperationalUnitDTO.OperationalUnitSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

}
