package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.service.CompanyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;import com.fasterxml.jackson.core.type.TypeReference;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;

import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import java.io.IOException;
import java.util.List;



@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/company")
public class CompanyRestController {
  private final CompanyService companyService;
   private final ObjectMapper objectMapper;
   private final DateUtil dateUtil;
   private final ReportUtil reportUtil;
   
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
    public ResponseEntity<CompanyDTO.Info> create(@RequestBody CompanyDTO.Create req) {
        CompanyDTO.Create create = (new ModelMapper()).map(req, CompanyDTO.Create.class);
        return new ResponseEntity<>(companyService.create(create), HttpStatus.CREATED);
    }

 @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CompanyDTO.Info> update(@PathVariable Long id, @RequestBody CompanyDTO.Update request) {
        CompanyDTO.Update update = (new ModelMapper()).map(request, CompanyDTO.Update.class);
        return new ResponseEntity<>(companyService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        companyService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

     @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody CompanyDTO.Delete request) {
        companyService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


     @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CompanyDTO.CompanySpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<CompanyDTO.Info> response = companyService.search(request);

        final CompanyDTO.SpecRs specResponse = new CompanyDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
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
