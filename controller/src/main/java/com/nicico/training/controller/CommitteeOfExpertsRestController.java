package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
 import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeOfExpertsDTO;
import com.nicico.training.dto.CommitteeOfExpertsUsersDTO;
import com.nicico.training.iservice.ICommitteeOfExpertsService;
import com.nicico.training.mapper.CommitteeOfExperts.CommitteeOfExpertsBeanMapper;
import com.nicico.training.model.CommitteeOfExperts;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/CommitteeOfExperts")
public class CommitteeOfExpertsRestController {

    private final ObjectMapper objectMapper;
    private final CommitteeOfExpertsBeanMapper committeeOfExpertsBeanMapper;
    private final ICommitteeOfExpertsService committeeOfExpertsService;



    @Loggable
    @PostMapping
    public ResponseEntity<BaseResponse> create(@RequestBody CommitteeOfExpertsDTO.Create req) {
        BaseResponse res = new BaseResponse();
        try {
            res = committeeOfExpertsService.create(committeeOfExpertsBeanMapper.toModel(req));
        }catch (TrainingException ex){
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));

    }

    @Loggable
    @PutMapping
    public ResponseEntity<BaseResponse> edit(@RequestBody CommitteeOfExpertsDTO.Create req) {
        BaseResponse res = new BaseResponse();
        try {
            res = committeeOfExpertsService.edit(committeeOfExpertsBeanMapper.toModel(req));
        }catch (TrainingException ex){
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));

    }



    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CommitteeOfExpertsDTO.CommitteeSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<CommitteeOfExpertsDTO.Info> response = committeeOfExpertsService.search(request);

        final CommitteeOfExpertsDTO.SpecRs specResponse = new CommitteeOfExpertsDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CommitteeOfExpertsDTO.CommitteeSpecRs specRs = new CommitteeOfExpertsDTO.CommitteeSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            committeeOfExpertsService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }


    @Loggable
    @GetMapping("/get/{id}")
    public ResponseEntity<CommitteeOfExpertsDTO> get(@PathVariable Long id) {
        try {
            CommitteeOfExperts committeeOfExperts= committeeOfExpertsService.get(id);
            CommitteeOfExpertsDTO dto = committeeOfExpertsBeanMapper.toDto(committeeOfExperts);
            return new ResponseEntity<>(dto,HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_FOUND);
        }
    }

    @Loggable
    @GetMapping(value = "/listOfParts/{id}")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<CommitteeOfExpertsUsersDTO.CommitteeSpecRs> listOfParts(@PathVariable Long id) {
        List<CommitteeOfExpertsUsersDTO.Info> data=  committeeOfExpertsService.listOfParts(id);
        final CommitteeOfExpertsUsersDTO.SpecRs specResponse = new CommitteeOfExpertsUsersDTO.SpecRs();
        specResponse.setData(data)
                .setStartRow(0)
                .setEndRow(data.size())
                .setTotalRows(data.size());

        final CommitteeOfExpertsUsersDTO.CommitteeSpecRs specRs = new CommitteeOfExpertsUsersDTO.CommitteeSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


}
