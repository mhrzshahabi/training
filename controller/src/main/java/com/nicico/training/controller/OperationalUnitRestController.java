package com.nicico.training.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.service.OperationalUnitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/operationalUnit")
public class OperationalUnitRestController {


    private final OperationalUnitService operationalUnitService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    //*********************************

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(operationalUnitService.get(id), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<OperationalUnitDTO.Info>> list() {
        return new ResponseEntity<>(operationalUnitService.list(), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping
    public ResponseEntity<OperationalUnitDTO.Info> create(@RequestBody OperationalUnitDTO.Create req) {
        OperationalUnitDTO.Create create = (new ModelMapper()).map(req, OperationalUnitDTO.Create.class);
        return new ResponseEntity<>(operationalUnitService.create(create), HttpStatus.CREATED);
    }

    //*********************************

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        OperationalUnitDTO.Update update = (new ModelMapper()).map(request, OperationalUnitDTO.Update.class);
        return new ResponseEntity<>(operationalUnitService.update(id, update), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        operationalUnitService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody OperationalUnitDTO.Delete request) {
        operationalUnitService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

}
