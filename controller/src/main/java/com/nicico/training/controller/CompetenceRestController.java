/*
ghazanfari_f,
1/14/2020,
2:46 PM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.service.CompetenceService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final CompetenceService competenceService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<CompetenceDTO.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(competenceService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceDTO.Info> create(@RequestBody Object rq) {
        CompetenceDTO.Create create = modelMapper.map(rq, CompetenceDTO.Create.class);
        return new ResponseEntity<>(competenceService.checkAndCreate(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<CompetenceDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        CompetenceDTO.Update update = modelMapper.map(rq, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(competenceService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

}
