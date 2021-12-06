package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IViewStatisticsUnitReportService;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.repository.QuestionBankDAO;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.service.QuestionBankTestQuestionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
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
import java.util.List;
import java.util.Optional;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/question-bank")
public class QuestionBankRestController {

    private final QuestionBankService questionBankService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final QuestionBankTestQuestionService questionBankTestQuestionService;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<QuestionBankDTO.FullInfo> get(@PathVariable Long id) {
        return new ResponseEntity<>(questionBankService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/max")
    public Integer getMaxId() {
        return questionBankService.getMaxId();
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<QuestionBankDTO.QuestionBankSpecRs> list(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                   @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                                   @RequestParam(value = "id", required = false) Long id,
                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws NoSuchFieldException, IllegalAccessException, IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
            if (request.getCriteria() != null && request.getCriteria().getCriteria() != null)
            {
                for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                    if (criterion.getFieldName() != null) {
                        if (criterion.getFieldName().equals("eQuestionLevel.id") || criterion.getFieldName().equals("eQuestionLevel") ||
                                criterion.getFieldName().equals("equestionLevel.id") || criterion.getFieldName().equals("equestionLevel")) {
                            criterion.setFieldName("eQuestionLevelId");
                        }
                    }
                }
            }
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            if (sortBy.equals("eQuestionLevel.id") || sortBy.equals("eQuestionLevel") ||
                    sortBy.equals("eQuestionLevel.id") || sortBy.equals("eQuestionLevel")){
                sortBy = "eQuestionLevelId";
            }
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);


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
        HttpStatus httpStatus = HttpStatus.OK;
        QuestionBankDTO.Info info = null;
        if (!questionBankTestQuestionService.usedQuestion(id)) {
            info = questionBankService.update(id, request);
            return new ResponseEntity<>(info, httpStatus);
        } else {
            return new ResponseEntity<>(
                    info,
                    HttpStatus.FORBIDDEN);
        }

    }


    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            if (!questionBankTestQuestionService.usedQuestion(id)) {
                QuestionBank qb = questionBankService.getById(id);

                if (qb == null) {
                    return new ResponseEntity<>(
                            new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                            HttpStatus.NOT_FOUND);
                } else if (questionBankService.isExist(id)) {
                    return new ResponseEntity<>(
                            new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                            HttpStatus.NOT_ACCEPTABLE);
                } else {
                    questionBankService.delete(id);
                    return new ResponseEntity(HttpStatus.OK);
                }
            } else {
                return new ResponseEntity<>(
                        new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                        HttpStatus.NOT_ACCEPTABLE);
            }


        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/usedQuestion/{id}")
    public ResponseEntity<Boolean> usedQuestion(@PathVariable Long id) {
        return new ResponseEntity<>(questionBankTestQuestionService.usedQuestion(id), HttpStatus.OK);
    }


}