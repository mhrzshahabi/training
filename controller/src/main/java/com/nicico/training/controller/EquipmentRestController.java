package com.nicico.training.controller;/* com.nicico.training.controller
@Author:jafari-h
@Date:5/28/2019
@Time:1:07 PM
*/


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EquipmentDTO;
import com.nicico.training.iservice.IEquipmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/equipment")
public class EquipmentRestController {
    private final IEquipmentService equipmentService;
    private final ObjectMapper objectMapper;

    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<EquipmentDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(equipmentService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<List<EquipmentDTO.Info>> list() {
        return new ResponseEntity<>(equipmentService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_equipment')")
    public ResponseEntity<EquipmentDTO.Info> create(@Validated @RequestBody EquipmentDTO.Create request) {
        return new ResponseEntity<>(equipmentService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_equipment')")
    public ResponseEntity<EquipmentDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EquipmentDTO.Update request) {
        return new ResponseEntity<>(equipmentService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_equipment')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            equipmentService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_equipment')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody EquipmentDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            equipmentService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<EquipmentDTO.Info> response = equipmentService.search(request);

        final EquipmentDTO.SpecRs specResponse = new EquipmentDTO.SpecRs();
        final EquipmentDTO.EquipmentSpecRs specRs = new EquipmentDTO.EquipmentSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<SearchDTO.SearchRs<EquipmentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(equipmentService.search(request), HttpStatus.OK);
    }
}
