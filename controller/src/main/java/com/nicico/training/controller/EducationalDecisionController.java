package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationalDecisionDTO;
import com.nicico.training.iservice.IEducationalDecisionService;
import com.nicico.training.mapper.EducationalDecisionMapper.EducationalDecisionMapper;
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
@RequestMapping(value = "/api/decision")
public class EducationalDecisionController {
    private final IEducationalDecisionService iEducationalDecisionService;
    private final EducationalDecisionMapper mapper;

    @Loggable
    @PostMapping
    public ResponseEntity<BaseResponse> create(@RequestBody EducationalDecisionDTO request){
        BaseResponse res = new BaseResponse();
        try {
            res = iEducationalDecisionService.create(mapper.toModel(request));
        }catch (TrainingException ex){
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));

    }

    @Loggable
    @GetMapping(value = "/list/{ref}/{header}")
//    @PreAuthorize("hasAuthority('r_country')")
    public ResponseEntity<EducationalDecisionDTO.EducationDecisionSpecRs> list( @PathVariable String ref,@PathVariable long header) {
        List<EducationalDecisionDTO.Info> data=  mapper.toDtosInfos(iEducationalDecisionService.list(ref,header));
        final EducationalDecisionDTO.SpecRs specResponse = new EducationalDecisionDTO.SpecRs();
        specResponse.setData(data)
                .setStartRow(0)
                .setEndRow(data.size())
                .setTotalRows(data.size());

        final EducationalDecisionDTO.EducationDecisionSpecRs specRs = new EducationalDecisionDTO.EducationDecisionSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            iEducationalDecisionService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }
}
