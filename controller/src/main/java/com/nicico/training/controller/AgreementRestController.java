package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.iservice.IAgreementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/agreement")
public class AgreementRestController {

    private final IAgreementService agreementService;

    @Loggable
    @PostMapping
    public ResponseEntity<AgreementDTO.Info> create(@RequestBody AgreementDTO.Create create) {
        return new ResponseEntity<>(agreementService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@RequestBody AgreementDTO.Update update, @PathVariable Long id) {
        try {
            agreementService.update(update, id);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        agreementService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<AgreementDTO.Info>> agreementList(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<AgreementDTO.Info> result = agreementService.search(searchRq);

        ISC.Response<AgreementDTO.Info> response = new ISC.Response<>();
        response.setStartRow(0);
        response.setEndRow(result.getList().size());
        response.setTotalRows(result.getList().size());
        response.setData(result.getList());
        ISC<AgreementDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
