package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.iservice.IAccountInfoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/accountinfo")
public class AccountInfoRestController {

    private final IAccountInfoService accountInfoService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AccountInfoDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(accountInfoService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<List<AccountInfoDTO.Info>> list() {
        return new ResponseEntity<>(accountInfoService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_address')")
    public ResponseEntity<AccountInfoDTO.Info> create(@Validated @RequestBody AccountInfoDTO.Create request) {
        return new ResponseEntity<>(accountInfoService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_address')")
    public ResponseEntity<AccountInfoDTO.Info> update(@PathVariable Long id, @Validated @RequestBody AccountInfoDTO.Update request) {
        return new ResponseEntity<>(accountInfoService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        accountInfoService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity<Void> delete(@Validated @RequestBody AccountInfoDTO.Delete request) {
        accountInfoService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AccountInfoDTO.AccountInfoSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                         @RequestParam("_endRow") Integer endRow,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<AccountInfoDTO.Info> response = accountInfoService.search(request);

        final AccountInfoDTO.SpecRs specResponse = new AccountInfoDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final AccountInfoDTO.AccountInfoSpecRs specRs = new AccountInfoDTO.AccountInfoSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<SearchDTO.SearchRs<AccountInfoDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(accountInfoService.search(request), HttpStatus.OK);
    }

}
