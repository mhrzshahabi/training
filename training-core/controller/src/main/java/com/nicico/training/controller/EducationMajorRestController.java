package com.nicico.training.controller;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.EducationMajorDTO;
import com.nicico.training.iservice.IEducationMajorService;
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
@RequestMapping(value = "/api/educationMajor")
public class EducationMajorRestController {
    private final IEducationMajorService educationMajorService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<EducationMajorDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationMajorService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<List<EducationMajorDTO.Info>> list() {
        return new ResponseEntity<>(educationMajorService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationMajor')")
    public ResponseEntity<EducationMajorDTO.Info> create(@Validated @RequestBody EducationMajorDTO.Create request) {
        return new ResponseEntity<>(educationMajorService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationMajor')")
    public ResponseEntity<EducationMajorDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EducationMajorDTO.Update request) {
        return new ResponseEntity<>(educationMajorService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationMajor')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        educationMajorService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationMajor')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationMajorDTO.Delete request) {
        educationMajorService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<EducationMajorDTO.EducationMajorSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationMajorDTO.Info> response = educationMajorService.search(request);

        final EducationMajorDTO.SpecRs specResponse = new EducationMajorDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationMajorDTO.EducationMajorSpecRs specRs = new EducationMajorDTO.EducationMajorSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<SearchDTO.SearchRs<EducationMajorDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationMajorService.search(request), HttpStatus.OK);
    }

    // ------------------------------
}
