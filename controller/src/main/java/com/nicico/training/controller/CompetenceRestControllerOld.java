/*
ghazanfari_f, 9/7/2019, 10:59 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTOOld;
import com.nicico.training.service.CompetenceServiceOld;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competenceOld")
public class CompetenceRestControllerOld {

    private final CompetenceServiceOld competenceService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<CompetenceDTOOld.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<CompetenceDTOOld.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<CompetenceDTOOld.Info> searchRs = competenceService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<CompetenceDTOOld.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(competenceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceDTOOld.Info> create(@RequestBody Object req) {
        CompetenceDTOOld.Create create = modelMapper.map(req, CompetenceDTOOld.Create.class);
        return new ResponseEntity<>(competenceService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<CompetenceDTOOld.Info> update(@PathVariable Long id, @RequestBody Object req) {
        CompetenceDTOOld.Update update = modelMapper.map(req, CompetenceDTOOld.Update.class);
        return new ResponseEntity<>(competenceService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        competenceService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
