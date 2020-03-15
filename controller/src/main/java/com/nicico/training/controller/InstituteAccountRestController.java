package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.InstituteAccountDTO;
import com.nicico.training.iservice.IInstituteAccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/institute-account")
public class InstituteAccountRestController {
    private final IInstituteAccountService accountService;
    private final ObjectMapper objectMapper;

    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<InstituteAccountDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(accountService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<List<InstituteAccountDTO.Info>> list() {
        return new ResponseEntity<>(accountService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_account')")
    public ResponseEntity<InstituteAccountDTO.Info> create(@Validated @RequestBody Object request) {
        return new ResponseEntity<>(accountService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_account')")
    public ResponseEntity<InstituteAccountDTO.Info> update(@PathVariable Long id, @Validated @RequestBody Object request) {
        return new ResponseEntity<>(accountService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_account')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            accountService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_account')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody InstituteAccountDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            accountService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<InstituteAccountDTO.AccountSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<InstituteAccountDTO.Info> response = accountService.search(request);

        final InstituteAccountDTO.SpecRs specResponse = new InstituteAccountDTO.SpecRs();
        final InstituteAccountDTO.AccountSpecRs specRs = new InstituteAccountDTO.AccountSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<SearchDTO.SearchRs<InstituteAccountDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(accountService.search(request), HttpStatus.OK);
    }
}
