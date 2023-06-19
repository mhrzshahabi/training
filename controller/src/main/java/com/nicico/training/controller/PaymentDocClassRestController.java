package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PaymentDocClassDTO;
import com.nicico.training.iservice.IPaymentDocClassService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.PaymentDocClass;
import com.nicico.training.model.Tclass;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

import static com.nicico.training.controller.util.CriteriaUtil.createCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/payment-doc-class")
public class PaymentDocClassRestController {

    private final IPaymentDocClassService service;
    private final ITclassService classService;

    @Loggable
    @PostMapping
    public ResponseEntity<BaseResponse> create(@RequestBody List<PaymentDocClassDTO.Create> list) {
        BaseResponse response =service.create(list);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }


    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/list-by-paymentId/{paymentDocId}")
    public  ResponseEntity<List<PaymentDocClassDTO.Info>> agreementClassCostListByAgreementId(HttpServletRequest iscRq, @PathVariable Long paymentDocId) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setCriteria(createCriteria(EOperator.equals, "paymentDocId", paymentDocId));

        SearchDTO.SearchRs<PaymentDocClassDTO.Info> result = service.search(searchRq);

        result.getList().forEach(item -> {
            Tclass tclass = classService.getClassByCode(item.getCode());
            item.setTitleClass(tclass.getTitleClass());
        });
        return new ResponseEntity<>(result.getList(), HttpStatus.OK);
    }
}
