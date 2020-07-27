package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IViewStatisticsUnitReportService;
import com.nicico.training.repository.QuestionBankDAO;
import com.nicico.training.service.QuestionBankService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/question-bank")
public class QuestionBankRestController {

    private final QuestionBankService questionBankService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<QuestionBankDTO.FullInfo> get(@PathVariable Long id) {
        return new ResponseEntity<>(questionBankService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/max")
    public Integer getMaxId(){
        return questionBankService.getMaxId();
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<QuestionBankDTO.QuestionBankSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                   @RequestParam(value = "criteria", required = false) String criteria) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<QuestionBankDTO.Info> response = questionBankService.search(request);

        final QuestionBankDTO.SpecRs specResponse = new QuestionBankDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final QuestionBankDTO.QuestionBankSpecRs specRs = new QuestionBankDTO.QuestionBankSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping
    public ResponseEntity<QuestionBankDTO.Info> create(@Validated @RequestBody QuestionBankDTO.Create request) {
        HttpStatus httpStatus = HttpStatus.CREATED;
        QuestionBankDTO.Info info = null;
        try {
            info = questionBankService.create(request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            info = null;
        }
        return new ResponseEntity<>(info, httpStatus);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<QuestionBankDTO.Info> update(@PathVariable Long id, @RequestBody QuestionBankDTO.Update request) {
        return new ResponseEntity<>(questionBankService.update(id, request), HttpStatus.OK);
    }


    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            questionBankService.delete(id);
            return new ResponseEntity(HttpStatus.OK);

        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }


}