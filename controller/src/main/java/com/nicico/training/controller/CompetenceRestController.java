/*
ghazanfari_f, 9/7/2019, 10:59 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.service.CompetenceService;
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
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final CompetenceService competenceService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<CompetenceDTO.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<CompetenceDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<CompetenceDTO.Info> searchRs = competenceService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<CompetenceDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(competenceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceDTO.Info> create(@RequestBody Object req) {
        CompetenceDTO.Create create = modelMapper.map(req, CompetenceDTO.Create.class);
        return new ResponseEntity<>(competenceService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<CompetenceDTO.Info> update(@PathVariable Long id, @RequestBody Object req) {
        CompetenceDTO.Update update = modelMapper.map(req, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        competenceService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
