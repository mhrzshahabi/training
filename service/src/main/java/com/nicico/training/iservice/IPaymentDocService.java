package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PaymentDTO;

public interface IPaymentDocService {

//    Agreement get(Long id);
//
    PaymentDTO.Info create(PaymentDTO.Create request);
//
//    Agreement update(AgreementDTO.Update update, Long id);
//
//    Agreement upload(AgreementDTO.Upload upload);
//
    SearchDTO.SearchRs<PaymentDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException;
//
//    void delete(Long id);

}
