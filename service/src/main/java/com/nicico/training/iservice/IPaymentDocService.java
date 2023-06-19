package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PaymentDTO;
import com.nicico.training.model.PaymentDoc;
import response.BaseResponse;

public interface IPaymentDocService {

    PaymentDoc get(Long id);

    PaymentDTO.Info create(PaymentDTO.Create request);

    PaymentDoc update(PaymentDTO.Update update, Long id);

    SearchDTO.SearchRs<PaymentDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException;

    void delete(Long id);

    BaseResponse changePaymentStatus(Long id);


}
