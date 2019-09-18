/*
ghazanfari_f, 9/7/2019, 10:59 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedAssessmentDTO;
import com.nicico.training.service.NeedAssessmentService;
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
@RequestMapping("/api/needAssessment")
public class NeedAssessmentRestController {

    private final NeedAssessmentService needAssessmentService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedAssessmentDTO.Info>> list() {
        return new ResponseEntity<>(needAssessmentService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<NeedAssessmentDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<NeedAssessmentDTO.Info> searchRs = needAssessmentService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<NeedAssessmentDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(needAssessmentService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object req) {
        try {
            NeedAssessmentDTO.Create create = modelMapper.map(req, NeedAssessmentDTO.Create.class);
            return new ResponseEntity<>(needAssessmentService.create(create), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_FOUND);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<NeedAssessmentDTO.Info> update(@PathVariable Long id, @RequestBody Object req) {
        NeedAssessmentDTO.Update update = modelMapper.map(req, NeedAssessmentDTO.Update.class);
        return new ResponseEntity<>(needAssessmentService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        needAssessmentService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
