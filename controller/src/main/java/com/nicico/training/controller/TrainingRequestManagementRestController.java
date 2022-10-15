package com.nicico.training.controller;



import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TrainingRequestManagementDTO;
import com.nicico.training.iservice.ITrainingReqItemService;
import com.nicico.training.iservice.ITrainingRequestManagementService;
import com.nicico.training.mapper.trainingRequestManagement.TrainingRequestManagementBeanMapper;
import com.nicico.training.model.TrainingRequestItem;
import com.nicico.training.model.TrainingRequestManagement;
import io.micrometer.core.instrument.util.StringUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/training-request-management")
public class TrainingRequestManagementRestController {

    private final TrainingRequestManagementBeanMapper trainingRequestManagementBeanMapper;
    private final ITrainingRequestManagementService trainingRequestManagementService;
    private final ITrainingReqItemService trainingReqItemService;
    private final ObjectMapper objectMapper;

    @Loggable
    @PostMapping
    public ResponseEntity<TrainingRequestManagementDTO.Info> create(@RequestBody TrainingRequestManagementDTO.Create request) {
        TrainingRequestManagement trainingRequestManagement=trainingRequestManagementBeanMapper.toTrainingRequestManagement(request);
        TrainingRequestManagement requestManagement=  trainingRequestManagementService.create(trainingRequestManagement);
        TrainingRequestManagementDTO.Info res=trainingRequestManagementBeanMapper.toTrainingRequestManagementDto(requestManagement);
        return new ResponseEntity<>(res, HttpStatus.CREATED);

    }
//
    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<TrainingRequestManagementDTO.Info> update(@PathVariable Long id, @RequestBody TrainingRequestManagementDTO.Update request) {
        TrainingRequestManagement competenceRequest=trainingRequestManagementBeanMapper.toTrainingRequestManagement(request);
        TrainingRequestManagement competenceRequestResponse=  trainingRequestManagementService.update(competenceRequest,id);
        TrainingRequestManagementDTO.Info res=trainingRequestManagementBeanMapper.toTrainingRequestManagementDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            trainingRequestManagementService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }
//
    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<TrainingRequestManagementDTO.Info> get(@PathVariable Long id) {
        TrainingRequestManagement trainingRequestManagement=  trainingRequestManagementService.get(id);
        TrainingRequestManagementDTO.Info res=trainingRequestManagementBeanMapper.toTrainingRequestManagementDto(trainingRequestManagement);
        return new ResponseEntity<>(res, HttpStatus.OK);
    }
//
    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<TrainingRequestManagementDTO.Info>> list() {
        List<TrainingRequestManagement> competenceRequestResponses=  trainingRequestManagementService.getList();
        List<TrainingRequestManagementDTO.Info> res=trainingRequestManagementBeanMapper.toTrainingRequestManagementDTOs(competenceRequestResponses);
        return new ResponseEntity<>(res, HttpStatus.OK); }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<TrainingRequestManagementDTO.TrainingRequestManagementSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        List<TrainingRequestManagement> response = trainingRequestManagementService.search(request);
        List<TrainingRequestManagementDTO.Info> res=trainingRequestManagementBeanMapper.toTrainingRequestManagementDTOs(response);

        final TrainingRequestManagementDTO.SpecRs specResponse = new TrainingRequestManagementDTO.SpecRs();
        final TrainingRequestManagementDTO.TrainingRequestManagementSpecRs specRs = new TrainingRequestManagementDTO.TrainingRequestManagementSpecRs();
        specResponse.setData(res)
                .setStartRow(startRow)
                .setEndRow(startRow + res.size())
                .setTotalRows(trainingRequestManagementService.getTotalCount());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list-items/{id}/{ref}")
    public ResponseEntity<TrainingRequestManagementDTO.PASpecRs> listOfItem(
            @PathVariable(value = "id") Long id,
            @PathVariable(value = "ref") String ref,
            @RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        List<TrainingRequestItem> response = trainingRequestManagementService.searchPositionAppointment(request);
        List<TrainingRequestManagementDTO.PositionAppointmentInfo> res=trainingRequestManagementBeanMapper.toTrainingReqPositionAppointmentDtos(response);

        final TrainingRequestManagementDTO.SpecRsPA specResponse = new TrainingRequestManagementDTO.SpecRsPA();
        final TrainingRequestManagementDTO.PASpecRs specRs = new TrainingRequestManagementDTO.PASpecRs();
        specResponse.setData(res)
                .setStartRow(startRow)
                .setEndRow(startRow + res.size())
                .setTotalRows(trainingReqItemService.getTotalCount(id,ref));

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/add")
    public ResponseEntity<BaseResponse> addItem(@RequestBody TrainingRequestManagementDTO.CreatePositionAppointment request) {
        BaseResponse baseResponse=  trainingRequestManagementService.addChild(request);
        return new ResponseEntity<>(baseResponse, HttpStatus.valueOf(baseResponse.getStatus()));
    }

    @Loggable
    @DeleteMapping(value = "/delete/{requestTrainingId}/{positionAppointmentId}")
    public ResponseEntity<BaseResponse> deleteItem(@PathVariable Long requestTrainingId,@PathVariable Long positionAppointmentId) {
        BaseResponse baseResponse=  trainingRequestManagementService.deleteChild(requestTrainingId,positionAppointmentId);
        return new ResponseEntity<>(baseResponse, HttpStatus.valueOf(baseResponse.getStatus()));
    }



}
