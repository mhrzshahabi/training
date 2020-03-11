package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CityDTO;
import com.nicico.training.iservice.ICityService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/city")
public class CityRestController {
    private final ICityService cityService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_city')")
    public ResponseEntity<CityDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(cityService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_city')")
    public ResponseEntity<List<CityDTO.Info>> list() {
        return new ResponseEntity<>(cityService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<CityDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<CityDTO.Info> searchRs = cityService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_city')")
    public ResponseEntity<CityDTO.Info> create(@Validated @RequestBody CityDTO.Create request) {
        return new ResponseEntity<>(cityService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CityDTO.Info> create1(@Validated @RequestBody CityDTO.Create request) {
        return new ResponseEntity<>(cityService.create(request), HttpStatus.CREATED);
    }


    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_city')")
    public ResponseEntity<CityDTO.Info> update(@PathVariable Long id, @Validated @RequestBody CityDTO.Update request) {
        return new ResponseEntity<>(cityService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_city')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        cityService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_city')")
    public ResponseEntity<Void> delete(@Validated @RequestBody CityDTO.Delete request) {
        cityService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_city')")
    public ResponseEntity<CityDTO.CitySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                   @RequestParam(value = "operator", required = false) String operator,
                                                   @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<CityDTO.Info> response = cityService.search(request);

        final CityDTO.SpecRs specResponse = new CityDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CityDTO.CitySpecRs specRs = new CityDTO.CitySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_city')")
    public ResponseEntity<SearchDTO.SearchRs<CityDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(cityService.search(request), HttpStatus.OK);
    }


}
