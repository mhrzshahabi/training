package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationIndexDTO;
import com.nicico.training.iservice.IEvaluationIndexService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
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
@RequestMapping(value = "/api/evaluationIndex")
public class EvaluationIndexRestController {

    private final IEvaluationIndexService evaluationIndexService;
    private final ObjectMapper objectMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_evaluationIndex')")
    public ResponseEntity<EvaluationIndexDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(evaluationIndexService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_evaluationIndex')")
    public ResponseEntity<List<EvaluationIndexDTO.Info>> list() {
        return new ResponseEntity<>(evaluationIndexService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//	@PreAuthorize("hasAuthority('c_evaluationIndex')")
    public ResponseEntity<EvaluationIndexDTO.Info> create(@Validated @RequestBody EvaluationIndexDTO.Create request) {
        return new ResponseEntity<>(evaluationIndexService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_evaluationIndex')")
    public ResponseEntity<EvaluationIndexDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EvaluationIndexDTO.Update request) {
        return new ResponseEntity<>(evaluationIndexService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_evaluationIndex')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            evaluationIndexService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_evaluationIndex')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody EvaluationIndexDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            evaluationIndexService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_evaluationIndex')")
    public ResponseEntity<EvaluationIndexDTO.EvaluationIndexSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<EvaluationIndexDTO.Info> response = evaluationIndexService.search(request);

        final EvaluationIndexDTO.SpecRs specResponse = new EvaluationIndexDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EvaluationIndexDTO.EvaluationIndexSpecRs specRs = new EvaluationIndexDTO.EvaluationIndexSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<EvaluationIndexDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<EvaluationIndexDTO.Info> searchRs = evaluationIndexService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_evaluationIndex')")
    public ResponseEntity<SearchDTO.SearchRs<EvaluationIndexDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(evaluationIndexService.search(request), HttpStatus.OK);
    }
}
