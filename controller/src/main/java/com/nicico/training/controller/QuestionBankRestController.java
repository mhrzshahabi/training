package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IQuestionBankService;
import com.nicico.training.iservice.IQuestionBankTestQuestionService;
import com.nicico.training.model.QuestionBank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/question-bank")
public class QuestionBankRestController {

    private final IQuestionBankService iQuestionBankService;
    private final ObjectMapper objectMapper;
    private final IQuestionBankTestQuestionService iQuestionBankTestQuestionService;
    private final MessageSource messageSource;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<QuestionBankDTO.FullInfo> get(@PathVariable Long id) {
        return new ResponseEntity<>(iQuestionBankService.get(id), HttpStatus.OK);
    } @Loggable

    @GetMapping(value = "/children-question/{id}")
    public ResponseEntity<QuestionBankDTO.QuestionBankSpecRsFullInfo> getChildrenQuestions(@PathVariable Long id) {
        final QuestionBankDTO.SpecRsFullInfo specResponse = new QuestionBankDTO.SpecRsFullInfo();
        List<QuestionBankDTO.FullInfo> data=new ArrayList<>();
        if (id!=-1L){
            data=iQuestionBankService.getChildrenQuestions(id).stream().toList();
        }
        specResponse.setData(data)
                .setStartRow(0)
                .setEndRow(data.size())
                .setTotalRows(data.size());

        final QuestionBankDTO.QuestionBankSpecRsFullInfo specRs = new QuestionBankDTO.QuestionBankSpecRsFullInfo();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
     }

    @Loggable
    @GetMapping(value = "/max")
    public Integer getMaxId() {
        return iQuestionBankService.getMaxId();
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

        SearchDTO.SearchRs<QuestionBankDTO.Info> response = iQuestionBankService.search(request);

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
            info = iQuestionBankService.create(request);

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
        if (!iQuestionBankTestQuestionService.usedQuestion(id)) {
            info = iQuestionBankService.update(id, request);
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
            if (!iQuestionBankTestQuestionService.usedQuestion(id)) {
                QuestionBank qb = iQuestionBankService.getById(id);

                if (qb == null) {
                    return new ResponseEntity<>(
                            new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                            HttpStatus.NOT_FOUND);
                } else if (iQuestionBankService.isExist(id)) {
                    return new ResponseEntity<>(
                            new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                            HttpStatus.NOT_ACCEPTABLE);
                } else {
                    iQuestionBankService.delete(id);
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
        return new ResponseEntity<>(iQuestionBankTestQuestionService.usedQuestion(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/with-filter/spec-list")
    public ResponseEntity<QuestionBankDTO.QuestionBankSpecRs> listWithFilter(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<QuestionBankDTO.Info> response = iQuestionBankService.search(request);

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
    @PostMapping(value = "/delete-questions-group/{id}/{ids}")
    public BaseResponse deleteQuestionsGroup(@PathVariable Long id, @PathVariable Set<Long> ids) {
        BaseResponse response=new BaseResponse();
        try {
            if (!iQuestionBankTestQuestionService.usedQuestion(id)) {
                QuestionBank qb = iQuestionBankService.getById(id);

                if (qb == null) {
                    response.setStatus(HttpStatus.NOT_FOUND.value());
                    return response;
                } else if (iQuestionBankService.isExist(id)) {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    return response;
                } else {
                    iQuestionBankService.deleteQuestionsGroup(id,ids);
                    response.setStatus(HttpStatus.OK.value());
                    return response;
                }
            } else {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                return response;
            }


        } catch (DataIntegrityViolationException e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            return response;
        }
    }

    @Loggable
    @PostMapping(value = "/add-questions-group/{id}/{ids}")
    public BaseResponse addQuestionsGroup(@PathVariable Long id, @PathVariable Set<Long> ids
            ,@RequestBody List<QuestionBankDTO.priorityData> priorityData
    ) {
        BaseResponse response=new BaseResponse();
        try {
            if (!iQuestionBankTestQuestionService.usedQuestion(id)) {
                QuestionBank qb = iQuestionBankService.getById(id);

                if (qb == null && id!=-1L) {
                    response.setStatus(HttpStatus.NOT_FOUND.value());
                    response.setMessage(messageSource.getMessage("question.error.notFound", null, LocaleContextHolder.getLocale()));


                    return response;
                } else if (iQuestionBankService.isExist(id)) {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    response.setMessage(messageSource.getMessage("question.error.used", null, LocaleContextHolder.getLocale()));


                    return response;
                } else {
                    return iQuestionBankService.addQuestionsGroup(id,ids,priorityData);
                }
            } else {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage(messageSource.getMessage("question.error.used", null, LocaleContextHolder.getLocale()));
                return response;
            }


        } catch (DataIntegrityViolationException e) {
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(messageSource.getMessage("msg.operation.successful", null, LocaleContextHolder.getLocale()));


            return response;
        }
    }
}