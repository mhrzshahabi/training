package com.nicico.training.controller;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.StateDTO;
import com.nicico.training.iservice.IStateService;
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
@RequestMapping(value = "/api/state")
public class StateRestController {
    private final IStateService stateService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_state')")
    public ResponseEntity<StateDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(stateService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_state')")
    public ResponseEntity<List<StateDTO.Info>> list() {
        return new ResponseEntity<>(stateService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_state')")
    public ResponseEntity<StateDTO.Info> create(@Validated @RequestBody StateDTO.Create request) {
        return new ResponseEntity<>(stateService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_state')")
    public ResponseEntity<StateDTO.Info> update(@PathVariable Long id, @Validated @RequestBody StateDTO.Update request) {
        return new ResponseEntity<>(stateService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_state')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        stateService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_state')")
    public ResponseEntity<Void> delete(@Validated @RequestBody StateDTO.Delete request) {
        stateService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_state')")
    public ResponseEntity<StateDTO.StateSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<StateDTO.Info> response = stateService.search(request);

        final StateDTO.SpecRs specResponse = new StateDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final StateDTO.StateSpecRs specRs = new StateDTO.StateSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_state')")
    public ResponseEntity<SearchDTO.SearchRs<StateDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(stateService.search(request), HttpStatus.OK);
    }


}
