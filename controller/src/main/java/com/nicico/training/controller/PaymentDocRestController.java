package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PaymentDTO;
import com.nicico.training.iservice.IPaymentDocService;
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
@RequestMapping(value = "/api/payment-doc")
public class PaymentDocRestController {

    private final IPaymentDocService paymentDocService;

    @Loggable
    @PostMapping
    public ResponseEntity<PaymentDTO.Info> create(@RequestBody PaymentDTO.Create create) {
        return new ResponseEntity<>(paymentDocService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@RequestBody PaymentDTO.Update update, @PathVariable Long id) {
        try {
            paymentDocService.update(update, id);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        paymentDocService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }


//
    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<PaymentDTO.Info>> agreementList(HttpServletRequest iscRq,
                                                              @RequestParam(value = "_startRow", required = false) Integer startRow,
                                                              @RequestParam(value = "_endRow", required = false) Integer endRow) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);
        SearchDTO.SearchRs<PaymentDTO.Info> result = paymentDocService.search(searchRq);

        ISC.Response<PaymentDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + result.getList().size());
        response.setTotalRows(result.getTotalCount().intValue());
        response.setData(result.getList());
        ISC<PaymentDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
