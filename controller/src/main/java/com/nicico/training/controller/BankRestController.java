package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.BankBranchDTO;
import com.nicico.training.dto.BankDTO;
import com.nicico.training.iservice.IBankService;
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
@RequestMapping(value = "/api/bank")
public class BankRestController {
    private final IBankService bankService;
    private final ObjectMapper objectMapper;

    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_bank')")
    public ResponseEntity<BankDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(bankService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_bank')")
    public ResponseEntity<List<BankDTO.Info>> list() {
        return new ResponseEntity<>(bankService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_bank')")
    public ResponseEntity<BankDTO.Info> create(@Validated @RequestBody BankDTO.Create request) {
        return new ResponseEntity<>(bankService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_bank')")
    public ResponseEntity<BankDTO.Info> update(@PathVariable Long id, @Validated @RequestBody BankDTO.Update request) {
        return new ResponseEntity<>(bankService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_bank')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            bankService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_bank')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody BankDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            bankService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_bank')")
    public ResponseEntity<BankDTO.BankSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                   @RequestParam(value = "_endRow",defaultValue = "50") Integer endRow,
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

        SearchDTO.SearchRs<BankDTO.Info> response = bankService.search(request);

        final BankDTO.SpecRs specResponse = new BankDTO.SpecRs();
        final BankDTO.BankSpecRs specRs = new BankDTO.BankSpecRs();
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
//    @PreAuthorize("hasAuthority('r_bank')")
    public ResponseEntity<SearchDTO.SearchRs<BankDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(bankService.search(request), HttpStatus.OK);

    }

    @Loggable
    @GetMapping(value = "bank-branches/{bankId}")
//    @PreAuthorize("hasAnyAuthority('r_course')")
    public ResponseEntity<BankBranchDTO.BankBranchSpecRs> getBankBranches(@PathVariable Long bankId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<BankBranchDTO.Info> bankBranches = bankService.getBankBranches(bankId);

        final BankBranchDTO.SpecRs specResponse = new BankBranchDTO.SpecRs();
        specResponse.setData(bankBranches)
                .setStartRow(0)
                .setEndRow(bankBranches.size())
                .setTotalRows(bankBranches.size());

        final BankBranchDTO.BankBranchSpecRs specRs = new BankBranchDTO.BankBranchSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


}
