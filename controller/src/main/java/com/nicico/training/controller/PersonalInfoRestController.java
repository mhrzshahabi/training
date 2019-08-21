package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.model.PersonalInfo;
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
@RequestMapping(value = "/api/personalInfo")
public class PersonalInfoRestController {

    private final IPersonalInfoService personalInfoService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(personalInfoService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<List<PersonalInfoDTO.Info>> list() {
        return new ResponseEntity<>(personalInfoService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.Info> create(@Validated @RequestBody PersonalInfoDTO.Create request) {
        return new ResponseEntity<>(personalInfoService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.Info> update(@PathVariable Long id, @Validated @RequestBody PersonalInfoDTO.Update request) {
        return new ResponseEntity<>(personalInfoService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_personalInfo')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        personalInfoService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_personalInfo')")
    public ResponseEntity<Void> delete(@Validated @RequestBody PersonalInfoDTO.Delete request) {
        personalInfoService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.PersonalInfoSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                         @RequestParam("_endRow") Integer endRow,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<PersonalInfoDTO.Info> response = personalInfoService.search(request);

        final PersonalInfoDTO.SpecRs specResponse = new PersonalInfoDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final PersonalInfoDTO.PersonalInfoSpecRs specRs = new PersonalInfoDTO.PersonalInfoSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<SearchDTO.SearchRs<PersonalInfoDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(personalInfoService.search(request), HttpStatus.OK);
    }

}
