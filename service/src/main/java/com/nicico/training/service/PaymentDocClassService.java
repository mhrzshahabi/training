package com.nicico.training.service;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PaymentDocClassDTO;
import com.nicico.training.iservice.IPaymentDocClassService;
import com.nicico.training.mapper.paymentDocMapper.PaymentDocClassMapper;
import com.nicico.training.model.PaymentDocClass;
import com.nicico.training.model.enums.PaymentDocStatus;
import com.nicico.training.repository.PaymentDocClassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import javax.validation.ConstraintViolationException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PaymentDocClassService implements IPaymentDocClassService {

    private final PaymentDocClassDAO paymentDocClassDAO;
    private final PaymentDocClassMapper paymentDocClassMapper;


    @Transactional
    @Override
    public BaseResponse create(List<PaymentDocClassDTO.Create> list) {
        BaseResponse response = new BaseResponse();

         try {
                list.forEach(request->{
                    PaymentDocClass paymentDocClass =new PaymentDocClass();
                    paymentDocClass.setPaymentDocId(request.getPaymentDocId());
                    paymentDocClass.setClassCode(request.getCode());
                    paymentDocClass.setClassDuration(request.getClassDuration());
                    paymentDocClass.setFinalAmount(Long.valueOf(request.getFinalAmount()));
                    paymentDocClass.setTeachingCostPerHour(request.getTeachingCostPerHour());
                    paymentDocClass.setTimeSpent(request.getTimeSpent());
                    paymentDocClassDAO.save(paymentDocClass);
                });
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
             response.setStatus(406);
             response.setMessage("کلاس به سند پرداخت اضافه نشد");
        }
        response.setStatus(200);
         return response;
     }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PaymentDocClassDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException {
        return BaseService.optimizedSearch(paymentDocClassDAO, paymentDocClassMapper::toDtoInfo, request);

    }

    @Transactional
    @Override
    public void delete(Long id) {
        PaymentDocClass paymentDocClass =paymentDocClassDAO.getById(id);
        if (paymentDocClass.getPaymentDoc().getPaymentDocStatus().equals(PaymentDocStatus.registration))
                paymentDocClassDAO.deleteById(id);
    }

}
