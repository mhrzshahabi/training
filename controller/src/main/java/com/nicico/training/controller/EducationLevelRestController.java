package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationLevelDTO;
import com.nicico.training.iservice.IEducationLevelService;
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
@RequestMapping(value = "/api/educationLevel")
public class EducationLevelRestController {
    private final IEducationLevelService educationLevelService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationLevelService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<List<EducationLevelDTO.Info>> list() {
        return new ResponseEntity<>(educationLevelService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> create(@Validated @RequestBody EducationLevelDTO.Create request) {
        return new ResponseEntity<>(educationLevelService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EducationLevelDTO.Update request) {
        return new ResponseEntity<>(educationLevelService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        educationLevelService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationLevelDTO.Delete request) {
        educationLevelService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<EducationLevelDTO.EducationLevelSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationLevelDTO.Info> response = educationLevelService.search(request);

        final EducationLevelDTO.SpecRs specResponse = new EducationLevelDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationLevelDTO.EducationLevelSpecRs specRs = new EducationLevelDTO.EducationLevelSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<SearchDTO.SearchRs<EducationLevelDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationLevelService.search(request), HttpStatus.OK);
    }

    // ------------------------------
}
