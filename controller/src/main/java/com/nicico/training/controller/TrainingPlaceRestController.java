package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TrainingPlaceDTO;
import com.nicico.training.iservice.ITrainingPlaceService;
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
@RequestMapping(value = "/api/training-place")
public class TrainingPlaceRestController {
    private final ITrainingPlaceService trainingPlaceService;
    private final ObjectMapper objectMapper;

    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<TrainingPlaceDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(trainingPlaceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<List<TrainingPlaceDTO.Info>> list() {
        return new ResponseEntity<>(trainingPlaceService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_equipment')")
    public ResponseEntity<TrainingPlaceDTO.Info> create(@Validated @RequestBody TrainingPlaceDTO.Create request) {
        return new ResponseEntity<>(trainingPlaceService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_equipment')")
    public ResponseEntity<TrainingPlaceDTO.Info> update(@PathVariable Long id, @Validated @RequestBody TrainingPlaceDTO.Update request) {
        return new ResponseEntity<>(trainingPlaceService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_equipment')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;
        try {
            trainingPlaceService.delete(id);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_equipment')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody TrainingPlaceDTO.Delete request) {
        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;
        try {
            trainingPlaceService.delete(request);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<TrainingPlaceDTO.TrainingPlaceSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<TrainingPlaceDTO.Info> response = trainingPlaceService.search(request);

        final TrainingPlaceDTO.SpecRs specResponse = new TrainingPlaceDTO.SpecRs();
        final TrainingPlaceDTO.TrainingPlaceSpecRs specRs = new TrainingPlaceDTO.TrainingPlaceSpecRs();
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
    public ResponseEntity<SearchDTO.SearchRs<TrainingPlaceDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(trainingPlaceService.search(request), HttpStatus.OK);
    }


}
