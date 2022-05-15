package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.iservice.IAgreementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/agreement")
public class AgreementRestController {

    private final ObjectMapper objectMapper;
    private final IAgreementService agreementService;

    @Loggable
    @PostMapping
    public ResponseEntity<AgreementDTO.Info> create(@RequestBody AgreementDTO.Create create) {
        return new ResponseEntity<>(agreementService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@RequestBody AgreementDTO.Update update, @PathVariable Long id) {
        try {
            agreementService.update(update, id);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        agreementService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/upload")
    public ResponseEntity upload(@RequestBody AgreementDTO.Upload upload) {
        try {
            agreementService.upload(upload);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_FOUND);
        }
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<AgreementDTO.Info>> agreementList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                @RequestParam(value = "_constructor", required = false) String constructor,
                                                                @RequestParam(value = "operator", required = false) String operator,
                                                                @RequestParam(value = "criteria", required = false) String criteria,
                                                                @RequestParam(value = "id", required = false) Long id,
                                                                @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            searchRq.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }

        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            searchRq.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        searchRq.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<AgreementDTO.Info> result = agreementService.search(searchRq);

        ISC.Response<AgreementDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + result.getList().size());
        response.setTotalRows(result.getTotalCount().intValue());
        response.setData(result.getList());
        ISC<AgreementDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
