package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.service.AccountInfoService;
import com.nicico.training.service.AddressService;
import com.nicico.training.service.CompanyService;
import com.nicico.training.service.PersonalInfoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    private final PersonalInfoService personalInfoService;
    private final AddressService addressService;
    private final AccountInfoService accountInfoService;

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

//        if (request.getAccountInfo() != null) {
//            AccountInfoDTO.Info accountInfoDTO = accountInfoService.createOrUpdate(request.getAccountInfo());
//            request.setAccountInfoId(accountInfoDTO.getId());
//            request.setAccountInfo(null);
//        }
//        if (request.getAddress() != null) {
//            AddressDTO.Info addressDTO = addressService.createOrUpdate(request.getAddress());
//            request.setAddressId(addressDTO.getId());
//            request.setAddress(null);
//        }
//        if (request.getManager() != null) {
//            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.createOrUpdate(request.getManager());
//            request.setManagerId(personalInfoDTO.getId());
//            request.setManager(null);
//        }

        try {
            return new ResponseEntity<>(companyService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody CompanyDTO.Update request) {

//        if (request.getAccountInfo() != null) {
//            AccountInfoDTO.Info accountInfoDTO = accountInfoService.createOrUpdate(request.getAccountInfo());
//            request.setAccountInfoId(accountInfoDTO.getId());
//            request.setAccountInfo(null);
//        }
//        if (request.getAddress() != null) {
//            AddressDTO.Info addressDTO = addressService.createOrUpdate(request.getAddress());
//            request.setAddressId(addressDTO.getId());
//            request.setAddress(null);
//        }
//        if (request.getManager() != null) {
//            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.createOrUpdate(request.getManager());
//            request.setManagerId(personalInfoDTO.getId());
//            request.setManager(null);
//        }

        try {
            return new ResponseEntity<>(companyService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        final CompanyDTO.Info company = companyService.get(id);
        companyService.delete(id);
        if (company.getAccountInfoId() != null)
            accountInfoService.delete(company.getAccountInfoId());
        return new ResponseEntity<>(HttpStatus.OK);
    }

//    @Loggable
//    @DeleteMapping(value = "/list")
//    public ResponseEntity<Void> delete(@Validated @RequestBody CompanyDTO.Delete request) {
//        companyService.delete(request);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }


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
