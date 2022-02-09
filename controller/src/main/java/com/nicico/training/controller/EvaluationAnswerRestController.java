package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationAnswerService;
import com.nicico.training.mapper.evaluationAnswer.EvaluationAnswerAuditMapper;
import com.nicico.training.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnswer")
public class EvaluationAnswerRestController {

    private final ObjectMapper objectMapper;

    private final IEvaluationAnswerService iEvaluationAnswerService;
    private final EvaluationAnswerAuditMapper evaluationAnswerAuditMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<EvaluationAnswerDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(iEvaluationAnswerService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<EvaluationAnswerDTO.Info>> list() {
        return new ResponseEntity<>(iEvaluationAnswerService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<EvaluationAnswerDTO.Info> create(@RequestBody Object req) {
        EvaluationAnswerDTO.Create create = (new ModelMapper()).map(req, EvaluationAnswerDTO.Create.class);
        return new ResponseEntity<>(iEvaluationAnswerService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<EvaluationAnswerDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        EvaluationAnswerDTO.Update update = (new ModelMapper()).map(request, EvaluationAnswerDTO.Update.class);
        return new ResponseEntity<>(iEvaluationAnswerService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        iEvaluationAnswerService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity delete(@Validated @RequestBody EvaluationAnswerDTO.Delete request) {
        iEvaluationAnswerService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<EvaluationAnswerDTO.EvaluationAnswerSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                               @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                               @RequestParam(value = "_constructor", required = false) String constructor,
                                                               @RequestParam(value = "operator", required = false) String operator,
                                                               @RequestParam(value = "criteria", required = false) String criteria,
                                                               @RequestParam(value = "id", required = false) Long id,
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
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<EvaluationAnswerDTO.Info> response = iEvaluationAnswerService.search(request);
        final EvaluationAnswerDTO.SpecRs specResponse = new EvaluationAnswerDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EvaluationAnswerDTO.EvaluationAnswerSpecRs specRs = new EvaluationAnswerDTO.EvaluationAnswerSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<EvaluationAnswerDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(iEvaluationAnswerService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/evalAnswerAudit/{evaluationId}")
    public ResponseEntity<EvaluationAnswerDTO.EvaluationAnswerAuditSpecRs> getEvalAnswerAudit(@PathVariable Long evaluationId) {
        List<EvaluationAnswerAudit> evaluationAnswerAuditList = iEvaluationAnswerService.getAuditData(evaluationId);
        List<EvaluationAnswerDTO.EvaluationAnswerForAudit> data = evaluationAnswerAuditMapper.toEvaluationAnswerForAuditList(evaluationAnswerAuditList);
        EvaluationAnswerDTO.SpecEvaluationAnswerForAuditRs specResponse = new EvaluationAnswerDTO.SpecEvaluationAnswerForAuditRs();
        EvaluationAnswerDTO.EvaluationAnswerAuditSpecRs specRs = new EvaluationAnswerDTO.EvaluationAnswerAuditSpecRs();
        specResponse.setData(data)
                .setStartRow(0)
                .setEndRow(data.size())
                .setTotalRows(data.size());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
