package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.model.RequestItem;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.requestItem.RequestItemWithDiff;

import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request-item")
public class RequestItemRestController {

    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IRequestItemService requestItemService;
    private final ObjectMapper objectMapper;


    @Loggable
    @PostMapping
    public ResponseEntity<RequestItemDTO.Info> create(@RequestBody RequestItemDTO.Create request) {
        RequestItem requestItem=requestItemBeanMapper.toRequestItem(request);
        RequestItem saved=  requestItemService.create(requestItem);
        RequestItemDTO.Info res=requestItemBeanMapper.toRequestItemDto(saved);
        return new ResponseEntity<>(res, HttpStatus.CREATED);

    }

    @Loggable
    @PostMapping(value = "/list")
    public ResponseEntity<List<RequestItemWithDiff>> createList(@RequestBody List<RequestItemDTO.Create> requests) {
        List<RequestItem> requestItem=requestItemBeanMapper.toRequestItemDtos(requests);
        List<RequestItemWithDiff>list= requestItemService.createList(requestItem);
         return new ResponseEntity<>(list, HttpStatus.CREATED);

    }


    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<RequestItemDTO.Info> update(@PathVariable Long id, @RequestBody RequestItemDTO.Create request) {
        RequestItem competenceRequest=requestItemBeanMapper.toRequestItem(request);
        RequestItem competenceRequestResponse=  requestItemService.update(competenceRequest,id);
        RequestItemDTO.Info res=requestItemBeanMapper.toRequestItemDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            requestItemService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<RequestItemDTO.Info> get(@PathVariable Long id) {
        RequestItem competenceRequestResponse=  requestItemService.get(id);
        RequestItemDTO.Info res=requestItemBeanMapper.toRequestItemDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);
    }
//
    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<RequestItemDTO.Info>> list() {
        List<RequestItem> requestItems=  requestItemService.getList();
        List<RequestItemDTO.Info> res=requestItemBeanMapper.toRequestItemDTODtos(requestItems);
        return new ResponseEntity<>(res, HttpStatus.OK); }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<RequestItemDTO.RequestItemSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        List<RequestItem> response = requestItemService.search(request);
        List<RequestItemDTO.Info> res=requestItemBeanMapper.toRequestItemDTODtos(response);

        final RequestItemDTO.SpecRs specResponse = new RequestItemDTO.SpecRs();
        final RequestItemDTO.RequestItemSpecRs specRs = new RequestItemDTO.RequestItemSpecRs();
        specResponse.setData(res)
                .setStartRow(startRow)
                .setEndRow(startRow + res.size())
                .setTotalRows(requestItemService.getTotalCount());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }



}
