package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PaymentDocClassDTO;
import response.BaseResponse;

import java.util.List;

public interface IPaymentDocClassService {


    BaseResponse create(List<PaymentDocClassDTO.Create> request);

    SearchDTO.SearchRs<PaymentDocClassDTO.Info> search(SearchDTO.SearchRq searchRq) throws IllegalAccessException, NoSuchFieldException;

    void delete(Long id);


}
