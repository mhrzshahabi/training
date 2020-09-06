package com.nicico.training.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassCheckListDTO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.ClassCheckListService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/class-checklist")
public class ClassCheckListRestController {

    private final ClassCheckListService classCheckListService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final ClassAlarmService classAlarmService;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<ClassCheckListDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(classCheckListService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<ClassCheckListDTO.Info>> list() {
        return new ResponseEntity<>(classCheckListService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<ClassCheckListDTO.Info> create(@RequestBody ClassCheckListDTO.Create req) {
        ClassCheckListDTO.Create create = (new ModelMapper()).map(req, ClassCheckListDTO.Create.class);
        return new ResponseEntity<>(classCheckListService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<ClassCheckListDTO.Info> update(@PathVariable Long id, @RequestBody ClassCheckListDTO.Update request) {
        ClassCheckListDTO.Update update = (new ModelMapper()).map(request, ClassCheckListDTO.Update.class);
        return new ResponseEntity<>(classCheckListService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        classCheckListService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody ClassCheckListDTO.Delete request) {
        classCheckListService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //
//     @Loggable
//    @GetMapping(value = "/spec-list")
//    public ResponseEntity<ClassCheckListDTO.ClassCheckListSpecRs> list(@RequestParam("_startRow") Integer startRow,
//                                                       @RequestParam("_endRow") Integer endRow,
//                                                       @RequestParam(value = "_constructor", required = false) String constructor,
//                                                       @RequestParam(value = "operator", required = false) String operator,
//                                                       @RequestParam(value = "criteria", required = false) String criteria,
//                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        SearchDTO.CriteriaRq criteriaRq;
//        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
//            criteria = "[" + criteria + "]";
//            criteriaRq = new SearchDTO.CriteriaRq();
//            criteriaRq.setOperator(EOperator.valueOf(operator))
//                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
//                    }));
//        request.setCriteria(criteriaRq);
//        }
//        if (StringUtils.isNotEmpty(sortBy)) {
//            request.setSortBy(sortBy);
//        }
//        request.setStartIndex(startRow)
//                .setCount(endRow - startRow);
//        SearchDTO.SearchRs<ClassCheckListDTO.Info> response = classCheckListService.search(request);
//        final ClassCheckListDTO.SpecRs specResponse = new ClassCheckListDTO.SpecRs();
//        specResponse.setData(response.getList())
//                .setStartRow(startRow)
//                .setEndRow(startRow + response.getList().size())
//                .setTotalRows(response.getTotalCount().intValue());
//        final ClassCheckListDTO.ClassCheckListSpecRs specRs = new ClassCheckListDTO.ClassCheckListSpecRs();
//        specRs.setResponse(specResponse);
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ClassCheckListDTO.Info> list(@RequestParam MultiValueMap<String, String> criteria) {
        return new ResponseEntity(classCheckListService.newSearch(criteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<ClassCheckListDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(classCheckListService.search(request), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/fill-Table/{classId}/{checkListId}")
    public ResponseEntity<ClassCheckListDTO.Info> fill(@PathVariable Long classId, @PathVariable Long checkListId) {
        return new ResponseEntity(classCheckListService.fillTable(classId, checkListId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/edit/{id}")
    public ResponseEntity<ClassCheckListDTO.Info> updateDescription(@PathVariable Long id, @RequestBody ClassCheckListDTO.Update request) throws IOException {
        ClassCheckListDTO.Update update = (new ModelMapper()).map(request, ClassCheckListDTO.Update.class);
        return new ResponseEntity(classCheckListService.updateDescription(id, update), HttpStatus.OK);
    }


    @Loggable
  //  @PostMapping(value = "/edit")
    public ResponseEntity<ClassCheckListDTO.Info> updateDescription(@RequestParam MultiValueMap<String, String> body) throws IOException {

        ResponseEntity<ClassCheckListDTO.Info> infoResponseEntity = new ResponseEntity(classCheckListService.updateDescriptionCheck(body), HttpStatus.OK);

        //*****check alarms*****
//        if (infoResponseEntity.getStatusCodeValue() == 200) {
//            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getTclassId());
//            classAlarmService.saveAlarms();
//        }

        return infoResponseEntity;
    }

    @Loggable
    @PostMapping(value = "/edit")
    public ResponseEntity<ClassCheckListDTO.Info> updateDescription1(@RequestBody ClassCheckListDTO.Info[] request) throws IOException {
       for(int i=0;i<request.length;i++)
       {
           classCheckListService.updateDescription2(request[i]);
       }
        return null;
    }


}
