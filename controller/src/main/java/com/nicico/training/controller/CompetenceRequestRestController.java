package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceRequestDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.competenceRequest.CompetenceRequestBeanMapper;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.RequestItem;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/competence-request")
public class CompetenceRequestRestController {

    private final CompetenceRequestBeanMapper competenceRequestBeanMapper;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final ICompetenceRequestService competenceRequestService;
    private final IRequestItemService requestItemService;
    private final ObjectMapper objectMapper;


    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceRequestDTO.Info> create(@RequestBody CompetenceRequestDTO.Create request) {
           CompetenceRequest competenceRequest=competenceRequestBeanMapper.toCompetenceRequest(request);
           CompetenceRequest competenceRequestResponse=  competenceRequestService.create(competenceRequest);
           CompetenceRequestDTO.Info res=competenceRequestBeanMapper.toCompetenceRequestDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.CREATED);

    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CompetenceRequestDTO.Info> update(@PathVariable Long id, @RequestBody CompetenceRequestDTO.Create request) {
            CompetenceRequest competenceRequest=competenceRequestBeanMapper.toCompetenceRequest(request);
            CompetenceRequest competenceRequestResponse=  competenceRequestService.update(competenceRequest,id);
            CompetenceRequestDTO.Info res=competenceRequestBeanMapper.toCompetenceRequestDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            competenceRequestService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<CompetenceRequestDTO.Info> get(@PathVariable Long id) {
        CompetenceRequest competenceRequestResponse=  competenceRequestService.get(id);
        CompetenceRequestDTO.Info res=competenceRequestBeanMapper.toCompetenceRequestDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<CompetenceRequestDTO.Info>> list() {
        List<CompetenceRequest> competenceRequestResponses=  competenceRequestService.getList();
        List<CompetenceRequestDTO.Info> res=competenceRequestBeanMapper.toCompetenceRequestDtos(competenceRequestResponses);
        return new ResponseEntity<>(res, HttpStatus.OK); }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CompetenceRequestDTO.CompetenceRequestSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                   @RequestParam(value = "_endRow",defaultValue = "50") Integer endRow,
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

        List<CompetenceRequest> response = competenceRequestService.search(request);
        List<CompetenceRequestDTO.Info> res=competenceRequestBeanMapper.toCompetenceRequestDtos(response);

        final CompetenceRequestDTO.SpecRs specResponse = new CompetenceRequestDTO.SpecRs();
        final CompetenceRequestDTO.CompetenceRequestSpecRs specRs = new CompetenceRequestDTO.CompetenceRequestSpecRs();
        specResponse.setData(res)
                .setStartRow(startRow)
                .setEndRow(startRow + res.size())
                .setTotalRows(competenceRequestService.getTotalCount());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/request-item-list")
    public ResponseEntity<List<RequestItemDTO.Info>> getRequestItemList(@RequestParam Long id) {
        List<RequestItem> competenceRequestResponses=  requestItemService.getListWithCompetenceRequest(id);
        List<RequestItemDTO.Info> res=requestItemBeanMapper.toRequestItemDTODtos(competenceRequestResponses);
        return new ResponseEntity<>(res, HttpStatus.OK); }


}
