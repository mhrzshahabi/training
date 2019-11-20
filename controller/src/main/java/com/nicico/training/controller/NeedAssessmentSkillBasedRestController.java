
package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedAssessmentSkillBasedDTO;
import com.nicico.training.service.NeedAssessmentSkillBasedService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needAssessmentSkillBased")
public class NeedAssessmentSkillBasedRestController {

    private final NeedAssessmentSkillBasedService needAssessmentSkillBasedService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedAssessmentSkillBasedDTO.Info>> list() {
        return new ResponseEntity<>(needAssessmentSkillBasedService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<NeedAssessmentSkillBasedDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> searchRs = needAssessmentSkillBasedService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/iscFullList/{objectType}:{objectId}")
    public ResponseEntity<ISC<NeedAssessmentSkillBasedDTO.Info>> fullList(HttpServletRequest iscRq,
                                                                          @PathVariable String objectType,
                                                                          @PathVariable Long objectId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> searchRs = needAssessmentSkillBasedService.deepSearch(searchRq, objectType, objectId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }


    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<NeedAssessmentSkillBasedDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(needAssessmentSkillBasedService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-all")
    public ResponseEntity addAll(@Validated @RequestBody NeedAssessmentSkillBasedDTO.Create[] request) {

        List<Long> responseList = new ArrayList<>();
        for (NeedAssessmentSkillBasedDTO.Create creating : request) {
            try {
                needAssessmentSkillBasedService.create(creating);
            } catch (TrainingException ex) {
                responseList.add(creating.getSkillId());
            }
        }
        if (responseList.isEmpty())
            return new ResponseEntity<>(HttpStatus.OK);
        return new ResponseEntity<>(responseList, null, HttpStatus.NOT_ACCEPTABLE);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody NeedAssessmentSkillBasedDTO.Update request) {
        try {
            return new ResponseEntity<>(needAssessmentSkillBasedService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            needAssessmentSkillBasedService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/remove-all/{ids}")
    public ResponseEntity delete(@PathVariable Set<Long> ids) {
        List<Long> responseList = new ArrayList<>();
        for (Long deleting : ids) {
            try {
                needAssessmentSkillBasedService.delete(deleting);
            } catch (TrainingException | DataIntegrityViolationException e) {
                responseList.add(deleting);
            }
        }
        if (responseList.isEmpty())
            return new ResponseEntity<>(HttpStatus.OK);
        return new ResponseEntity<>(responseList, null, HttpStatus.NOT_ACCEPTABLE);
    }

}
