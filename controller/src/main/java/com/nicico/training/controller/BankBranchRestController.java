package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.BankBranchDTO;
import com.nicico.training.iservice.IBankBranchService;
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
@RequestMapping(value = "/api/bank_branch")
public class BankBranchRestController {
    private final IBankBranchService bankBranchService;
    private final ObjectMapper objectMapper;

    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_bank_branch')")
    public ResponseEntity<BankBranchDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(bankBranchService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_bank_branch')")
    public ResponseEntity<List<BankBranchDTO.Info>> list() {
        return new ResponseEntity<>(bankBranchService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_bank_branch')")
    public ResponseEntity<BankBranchDTO.Info> create(@Validated @RequestBody BankBranchDTO.Create request) {
        return new ResponseEntity<>(bankBranchService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_bank_branch')")
    public ResponseEntity<BankBranchDTO.Info> update(@PathVariable Long id, @Validated @RequestBody BankBranchDTO.Update request) {
        return new ResponseEntity<>(bankBranchService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_bank_branch')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            bankBranchService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_bank_branch')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody BankBranchDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            bankBranchService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_bank_branch')")
    public ResponseEntity<BankBranchDTO.BankBranchSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<BankBranchDTO.Info> response = bankBranchService.search(request);

        final BankBranchDTO.SpecRs specResponse = new BankBranchDTO.SpecRs();
        final BankBranchDTO.BankBranchSpecRs specRs = new BankBranchDTO.BankBranchSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_bank_branch')")
    public ResponseEntity<SearchDTO.SearchRs<BankBranchDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(bankBranchService.search(request), HttpStatus.OK);
    }
}
