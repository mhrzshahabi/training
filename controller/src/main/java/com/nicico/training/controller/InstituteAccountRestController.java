package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.iservice.IInstituteAccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_account')")
    public ResponseEntity<AccountInfoDTO.CreateOrUpdate> create(@Validated @RequestBody Object request) {
        return new ResponseEntity<>(accountService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<List<AccountInfoDTO.Info>> list() {
        return new ResponseEntity<>(accountService.list(), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_account')")
    public ResponseEntity<AccountInfoDTO.CreateOrUpdate> update(@PathVariable Long id, @Validated @RequestBody Object request) {
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
    @GetMapping(value = "{instituteId}/accounts")
//    @PreAuthorize("hasAuthority('r_getAccounts')")
    public ResponseEntity<AccountInfoDTO.AccountInfoSpecRs> getAccounts(@RequestParam("_startRow") Integer startRow,
                                                                           @RequestParam("_endRow") Integer endRow,
                                                                           @RequestParam(value = "_constructor", required = false) String constructor,
                                                                           @RequestParam(value = "operator", required = false) String operator,
                                                                           @RequestParam(value = "criteria", required = false) String criteria,
                                                                           @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                           @PathVariable Long instituteId) {
        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        List<AccountInfoDTO.Info> accounts = accountService.get(instituteId,pageable);

        final AccountInfoDTO.SpecRs specResponse = new AccountInfoDTO.SpecRs();
        specResponse.setData(accounts)
                .setStartRow(0)
                .setEndRow(accounts.size())
                .setTotalRows(accounts.size());

        final AccountInfoDTO.AccountInfoSpecRs specRs = new AccountInfoDTO.AccountInfoSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_account')")
    public ResponseEntity<AccountInfoDTO.AccountInfoSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<AccountInfoDTO.Info> response = accountService.search(request);

        final AccountInfoDTO.SpecRs specResponse = new AccountInfoDTO.SpecRs();
        final AccountInfoDTO.AccountInfoSpecRs specRs = new AccountInfoDTO.AccountInfoSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
