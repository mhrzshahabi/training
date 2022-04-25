package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IAgreementClassCostService;
import com.nicico.training.iservice.ITclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/agreement-class-cost")
public class AgreementClassCostRestController {

    private final ITclassService classService;
    private final IAgreementClassCostService agreementClassCostService;

    @Loggable
    @PostMapping
    public ResponseEntity<AgreementClassCostDTO.Info> create(@RequestBody AgreementClassCostDTO.Create create) {
        return new ResponseEntity<>(agreementClassCostService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@RequestBody AgreementClassCostDTO.Update update, @PathVariable Long id) {
        try {
            agreementClassCostService.update(update, id);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/list-by-agreementId/{agreementId}")
    public ResponseEntity<List<AgreementClassCostDTO.Info>> agreementClassCostListByAgreementId(HttpServletRequest iscRq, @PathVariable Long agreementId) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();

        criteriaRq.setFieldName("agreementId");
        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setValue(agreementId);
        searchRq.setCriteria(criteriaRq);

        SearchDTO.SearchRs<AgreementClassCostDTO.Info> result = agreementClassCostService.search(searchRq);
        result.getList().forEach(item -> {
            TclassDTO.TClassForAgreement classForAgreement = classService.getTClassDataForAgreement(item.getClassId());
            item.setCode(classForAgreement.getCode());
            item.setTitleClass(classForAgreement.getTitleClass());
        });
        return new ResponseEntity<>(result.getList(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<AgreementClassCostDTO.Info>> agreementClassCostList(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<AgreementClassCostDTO.Info> result = agreementClassCostService.search(searchRq);

        ISC.Response<AgreementClassCostDTO.Info> response = new ISC.Response<>();
        response.setStartRow(0);
        response.setEndRow(result.getList().size());
        response.setTotalRows(result.getList().size());
        response.setData(result.getList());
        ISC<AgreementClassCostDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
