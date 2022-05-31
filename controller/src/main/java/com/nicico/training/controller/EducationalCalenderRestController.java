package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.EducationalCalenderDTO;
import com.nicico.training.iservice.IEducationalCalenderService;
import com.nicico.training.iservice.ITclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/educational-calender")
public class EducationalCalenderRestController {
    private final IEducationalCalenderService educationalCalenderService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody EducationalCalenderDTO request) {

        try {
            return new ResponseEntity<>( educationalCalenderService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(TrainingException.ErrorType.DuplicateRecord.getHttpStatusCode(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            educationalCalenderService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @GetMapping(value = "/spec-list")
    public ResponseEntity<EducationalCalenderDTO.EducationalCalenderSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<EducationalCalenderDTO.Info> response = educationalCalenderService.search(request);

        final EducationalCalenderDTO.SpecRs specResponse = new EducationalCalenderDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationalCalenderDTO.EducationalCalenderSpecRs specRs = new EducationalCalenderDTO.EducationalCalenderSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
