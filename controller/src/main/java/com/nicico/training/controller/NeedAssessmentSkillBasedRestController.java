
package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedAssessmentSkillBasedDTO;
import com.nicico.training.service.NeedAssessmentSkillBasedService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needAssessmentSkillBased")
public class NeedAssessmentSkillBasedRestController {

    private final NeedAssessmentSkillBasedService needAssessmentSkillBasedService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedAssessmentSkillBasedDTO.Info>> list() {
        return new ResponseEntity<>(needAssessmentSkillBasedService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<NeedAssessmentSkillBasedDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> searchRs = needAssessmentSkillBasedService.deepSearch(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<NeedAssessmentSkillBasedDTO.NeedAssessmentSkillBasedSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                                                           @RequestParam("_endRow") Integer endRow,
                                                                                           @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                           @RequestParam(value = "operator", required = false) String operator,
                                                                                           @RequestParam(value = "criteria", required = false) String criteria,
                                                                                           @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> response = needAssessmentSkillBasedService.deepSearch(request);

        final NeedAssessmentSkillBasedDTO.SpecRs specResponse = new NeedAssessmentSkillBasedDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final NeedAssessmentSkillBasedDTO.NeedAssessmentSkillBasedSpecRs specRs = new NeedAssessmentSkillBasedDTO.NeedAssessmentSkillBasedSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<NeedAssessmentSkillBasedDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(needAssessmentSkillBasedService.get(id), HttpStatus.OK);
    }

//    @Loggable
//    @PostMapping
//    public ResponseEntity create(@RequestBody Object req) {
//        try {
//            NeedAssessmentSkillBasedDTO.Create create = modelMapper.map(req, NeedAssessmentSkillBasedDTO.Create.class);
//            return new ResponseEntity<>(needAssessmentSkillBasedService.create(create), HttpStatus.OK);
//        } catch (TrainingException ex) {
//            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_FOUND);
//        }
//    }

    @Loggable
    @PostMapping(value = "/add-all")
    public ResponseEntity addAll(@Validated @RequestBody NeedAssessmentSkillBasedDTO.Create[] request) {

        List<String> responseList = new ArrayList<>();
        for (NeedAssessmentSkillBasedDTO.Create creating : request) {
            try {
                needAssessmentSkillBasedService.create(creating);
            } catch (TrainingException ex) {
                responseList.add("id:" + creating + ",msg:" + ex.getMessage());
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
    @DeleteMapping(value = "/list")
    public ResponseEntity delete(@RequestBody Object request) {

        List deletingList = modelMapper.map(request, List.class);
        List<String> responseList = new ArrayList<>();
        for (Object deleting : deletingList) {
            try {
                needAssessmentSkillBasedService.delete((Long)deleting);
            } catch (TrainingException | DataIntegrityViolationException e) {
                responseList.add("id:" + deleting + ",msg:" + new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage());
            }
        }
        if (responseList.isEmpty())
            return new ResponseEntity<>(HttpStatus.OK);
        return new ResponseEntity<>(responseList, null, HttpStatus.NOT_ACCEPTABLE);
    }

}
