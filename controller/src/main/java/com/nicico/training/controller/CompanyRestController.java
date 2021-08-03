package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.service.CompanyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/company")
public class CompanyRestController {
    private final CompanyService companyService;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<CompanyDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(companyService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<CompanyDTO.Info>> list() {
        return new ResponseEntity<>(companyService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody CompanyDTO.Create request) {

        try {
            return new ResponseEntity<>( companyService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(TrainingException.ErrorType.DuplicateRecord.getHttpStatusCode(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody CompanyDTO.Update request) {

        try {
            return new ResponseEntity<>(companyService.update(id, request), HttpStatus.OK);
        } catch (TrainingException e) {
            BaseResponse response = new BaseResponse();
            response.setStatus(e.getHttpStatusCode());
            switch (e.getHttpStatusCode()) {
                case 409:
                    response.setMessage("رکوردی با این اطلاعات در سیستم وجود دارد");
                    break;
                case 404:
                    response.setMessage("شرکت مورد نظر یافت نشد");
                    break;
                case 405:
                    response.setMessage("خطا در ویرایش مدیر شرکت صورت گرفت");
                    break;
                case 406:
                    response.setMessage("خطا در ویرایش آدرس شرکت صورت گرفت");
                    break;
                default:
                    response.setMessage("خطا در ویرایش شرکت صورت گرفت");
            }
            response.setStatus(e.getHttpStatusCode());

            return new ResponseEntity<>(response, HttpStatus.REQUEST_TIMEOUT);

        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            companyService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

//    @Loggable
//    @DeleteMapping(value = "/list")
//    public ResponseEntity<Void> delete(@Validated @RequestBody CompanyDTO.Delete request) {
//        companyService.delete(request);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CompanyDTO.CompanySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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

        SearchDTO.SearchRs<CompanyDTO.Info> response = companyService.search(request);

        final CompanyDTO.SpecRs specResponse = new CompanyDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CompanyDTO.CompanySpecRs specRs = new CompanyDTO.CompanySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<CompanyDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(companyService.search(request), HttpStatus.OK);
    }

}
