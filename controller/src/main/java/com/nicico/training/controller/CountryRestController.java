package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CountryDTO;
import com.nicico.training.iservice.ICountryService;
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
@RequestMapping(value = "/api/country")
public class CountryRestController {
    private final ICountryService countryService;

    @Loggable
    @GetMapping(value = "/{id}")
     public ResponseEntity<CountryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(countryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<List<CountryDTO.Info>> list() {
        return new ResponseEntity<>(countryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_country')")
    public ResponseEntity<CountryDTO.Info> create(@Validated @RequestBody CountryDTO.Create request) {
        return new ResponseEntity<>(countryService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_country')")
    public ResponseEntity<CountryDTO.Info> update(@PathVariable Long id, @Validated @RequestBody CountryDTO.Update request) {
        return new ResponseEntity<>(countryService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_country')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        countryService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_country')")
    public ResponseEntity<Void> delete(@Validated @RequestBody CountryDTO.Delete request) {
        countryService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<CountryDTO.CountrySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                         @RequestParam(value = "_endRow", defaultValue = "75") Integer endRow,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<CountryDTO.Info> response = countryService.search(request);

        final CountryDTO.SpecRs specResponse = new CountryDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CountryDTO.CountrySpecRs specRs = new CountryDTO.CountrySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<SearchDTO.SearchRs<CountryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(countryService.search(request), HttpStatus.OK);
    }


}
