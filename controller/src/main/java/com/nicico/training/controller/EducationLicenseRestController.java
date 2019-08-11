package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationLicenseDTO;
import com.nicico.training.iservice.IEducationLicenseService;
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
@RequestMapping(value = "/api/educationLicense")
public class EducationLicenseRestController {
    private final IEducationLicenseService educationLicenseService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLicense')")
    public ResponseEntity<EducationLicenseDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationLicenseService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationLicense')")
    public ResponseEntity<List<EducationLicenseDTO.Info>> list() {
        return new ResponseEntity<>(educationLicenseService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationLicense')")
    public ResponseEntity<EducationLicenseDTO.Info> create(@Validated @RequestBody EducationLicenseDTO.Create request) {
        return new ResponseEntity<>(educationLicenseService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLicense')")
    public ResponseEntity<EducationLicenseDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EducationLicenseDTO.Update request) {
        return new ResponseEntity<>(educationLicenseService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationLicense')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        educationLicenseService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationLicense')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationLicenseDTO.Delete request) {
        educationLicenseService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLicense')")
    public ResponseEntity<EducationLicenseDTO.EducationLicenseSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationLicenseDTO.Info> response = educationLicenseService.search(request);

        final EducationLicenseDTO.SpecRs specResponse = new EducationLicenseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationLicenseDTO.EducationLicenseSpecRs specRs = new EducationLicenseDTO.EducationLicenseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationLicense')")
    public ResponseEntity<SearchDTO.SearchRs<EducationLicenseDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationLicenseService.search(request), HttpStatus.OK);
    }

    // ------------------------------
}
