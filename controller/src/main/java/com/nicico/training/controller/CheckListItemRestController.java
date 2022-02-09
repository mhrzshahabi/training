package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CheckListItemDTO;
import com.nicico.training.iservice.ICheckListItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/checklistItem")
public class CheckListItemRestController {
    private final ICheckListItemService iCheckListItemService;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<CheckListItemDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(iCheckListItemService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<CheckListItemDTO.Info>> list() {
        return new ResponseEntity<>(iCheckListItemService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CheckListItemDTO.Info> create(@RequestBody CheckListItemDTO.Create req) {
        CheckListItemDTO.Create create = (new ModelMapper()).map(req, CheckListItemDTO.Create.class);
        ResponseEntity<CheckListItemDTO.Info> infoResponseEntity = new ResponseEntity<>(iCheckListItemService.create(create), HttpStatus.CREATED);

        //*****check alarms*****
        ////because is to long , I disabled this part, if you want to use this part you must use for update and delete to
        ////if (infoResponseEntity.getStatusCodeValue() == 201) {
        ////    classAlarmService.alarmCheckListConflict(0L);
        ////    classAlarmService.saveAlarms();
        ////}
        return infoResponseEntity;
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CheckListItemDTO.Info> update(@PathVariable Long id, @RequestBody CheckListItemDTO.Update request) {
        CheckListItemDTO.Update update = (new ModelMapper()).map(request, CheckListItemDTO.Update.class);
        return new ResponseEntity<>(iCheckListItemService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/edit/{id}")
    public ResponseEntity<CheckListItemDTO.Info> updateDescription(@PathVariable Long id, @RequestBody CheckListItemDTO.Update request) throws IOException {
        CheckListItemDTO.Update update = (new ModelMapper()).map(request, CheckListItemDTO.Update.class);
        return new ResponseEntity(iCheckListItemService.updateDescription(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        iCheckListItemService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody CheckListItemDTO.Delete request) {
        iCheckListItemService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CheckListItemDTO.CheckListItemSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                     @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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

        SearchDTO.SearchRs<CheckListItemDTO.Info> response = iCheckListItemService.search(request);

        final CheckListItemDTO.SpecRs specResponse = new CheckListItemDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CheckListItemDTO.CheckListItemSpecRs specRs = new CheckListItemDTO.CheckListItemSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<CheckListItemDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(iCheckListItemService.search(request), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "is_Delete/{id}")
    public ResponseEntity<CheckListItemDTO.Info> is_Delete(@PathVariable Long id, @RequestBody CheckListItemDTO.Update request) {
        CheckListItemDTO.Update update = (new ModelMapper()).map(request, CheckListItemDTO.Update.class);
        return new ResponseEntity<>(iCheckListItemService.is_Delete(id, update), HttpStatus.OK);
    }


}
