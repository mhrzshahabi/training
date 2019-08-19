package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.service.TermService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@RequestMapping("/api/term")
public class TermRestController {
  private final TermService termService;
   private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<TermDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(termService.get(id), HttpStatus.OK);
    }

     @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<TermDTO.Info>> list() {
        return new ResponseEntity<>(termService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<TermDTO.Info> create(@RequestBody TermDTO.Create req) {
        TermDTO.Create create = (new ModelMapper()).map(req, TermDTO.Create.class);
        return new ResponseEntity<>(termService.create(create), HttpStatus.CREATED);
    }

 @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<TermDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        TermDTO.Update update = (new ModelMapper()).map(request, TermDTO.Update.class);
        return new ResponseEntity<>(termService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        termService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

     @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody TermDTO.Delete request) {
        termService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


     @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<TermDTO.TermSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<TermDTO.Info> response = termService.search(request);

        final TermDTO.SpecRs specResponse = new TermDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final TermDTO.TermSpecRs specRs = new TermDTO.TermSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


      @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<TermDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(termService.search(request), HttpStatus.OK);
    }

}
