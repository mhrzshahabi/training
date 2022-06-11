package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationalDecisionHeaderDTO;
import com.nicico.training.iservice.IEducationalDecisionHeaderService;
import com.nicico.training.mapper.EducationalDecisionHeaderMapper.EducationalDecisionHeaderMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/header")
public class EducationalDecisionHeaderController {
    private final IEducationalDecisionHeaderService iEducationalDecisionHeaderService;
    private final EducationalDecisionHeaderMapper mapper;

    @Loggable
    @PostMapping
    public ResponseEntity<BaseResponse> create(@RequestBody EducationalDecisionHeaderDTO request){
        BaseResponse res = new BaseResponse();
        try {
            res = iEducationalDecisionHeaderService.create(mapper.toModel(request));
        }catch (TrainingException ex){
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));

    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<EducationalDecisionHeaderDTO.EducationDecisionHeaderSpecRs> list() {
        List<EducationalDecisionHeaderDTO.Info> data=  mapper.toDtosInfos(iEducationalDecisionHeaderService.list());
        final EducationalDecisionHeaderDTO.SpecRs specResponse = new EducationalDecisionHeaderDTO.SpecRs();
        specResponse.setData(data)
                .setStartRow(0)
                .setEndRow(data.size())
                .setTotalRows(data.size());

        final EducationalDecisionHeaderDTO.EducationDecisionHeaderSpecRs specRs = new EducationalDecisionHeaderDTO.EducationDecisionHeaderSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            iEducationalDecisionHeaderService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }
}
