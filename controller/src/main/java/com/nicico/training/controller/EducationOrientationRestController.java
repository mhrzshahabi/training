package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationOrientationService;
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
@RequestMapping(value = "/api/educationOrientation")
public class EducationOrientationRestController {
    private final IEducationOrientationService educationOrientationService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationOrientationService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<List<EducationOrientationDTO.Info>> list() {
        return new ResponseEntity<>(educationOrientationService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.Info> create(@Validated @RequestBody EducationOrientationDTO.Create request) {
        return new ResponseEntity<>(educationOrientationService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EducationOrientationDTO.Update request) {
        return new ResponseEntity<>(educationOrientationService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationOrientation')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        educationOrientationService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationOrientation')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationOrientationDTO.Delete request) {
        educationOrientationService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.EducationOrientationSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationOrientationDTO.Info> response = educationOrientationService.search(request);

        final EducationOrientationDTO.SpecRs specResponse = new EducationOrientationDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationOrientationDTO.EducationOrientationSpecRs specRs = new EducationOrientationDTO.EducationOrientationSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<SearchDTO.SearchRs<EducationOrientationDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationOrientationService.search(request), HttpStatus.OK);
    }

    // ------------------------------


}
