package com.nicico.training.service;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PaymentDTO;
import com.nicico.training.iservice.IPaymentDocService;
import com.nicico.training.mapper.paymentDocMapper.PaymentDocMapper;
import com.nicico.training.model.PaymentDoc;
import com.nicico.training.model.enums.PaymentDocStatus;
import com.nicico.training.repository.PaymentDocDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import javax.validation.ConstraintViolationException;
import java.util.Optional;

import static com.nicico.training.model.enums.PaymentDocStatus.registration;

@Service
@RequiredArgsConstructor
public class PaymentDocService implements IPaymentDocService {

    private final ModelMapper modelMapper;
    private final PaymentDocDAO paymentDocDAO;
    private final PaymentDocMapper paymentDocMapper;


    @Override
    public PaymentDoc get(Long id) {
        return paymentDocDAO.findById(id).orElse(null);
    }
//
    @Transactional
    @Override
    public PaymentDTO.Info create(PaymentDTO.Create request) {

         try {
            Long agreementId = request.getAgreementId();
            if (agreementId!=null){
                PaymentDoc paymentDoc =new PaymentDoc();
                paymentDoc.setAgreementId(agreementId);
                paymentDoc.setPaymentDocStatus(registration);
                PaymentDoc savedPayment= paymentDocDAO.save(paymentDoc);
                return paymentDocMapper.toDtoInfo(savedPayment);
            }else {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
     }

    @Transactional
    @Override
    public PaymentDoc update(PaymentDTO.Update update, Long id) {

        Optional<PaymentDoc> paymentDocOptional = paymentDocDAO.findById(id);
        PaymentDoc paymentDoc = paymentDocOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        PaymentDoc updating = new PaymentDoc();
        modelMapper.map(paymentDoc, updating);
        modelMapper.map(update, updating);
        updating.setPaymentDocStatus(PaymentDocStatus.fromString(update.getPaymentDocStatus()));
        return paymentDocDAO.saveAndFlush(updating);
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PaymentDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException {
        return BaseService.optimizedSearch(paymentDocDAO, paymentDocMapper::toDtoInfo, request);

    }

    @Transactional
    @Override
    public void delete(Long id) {
        paymentDocDAO.deleteById(id);
    }

    @Transactional
    @Override
    public BaseResponse changePaymentStatus(Long id) {
        BaseResponse baseResponse = new BaseResponse();
        Optional<PaymentDoc> paymentDocOptional = paymentDocDAO.findById(id);
        if (paymentDocOptional.isEmpty()){
            baseResponse.setStatus(404);
            baseResponse.setMessage("سند یافت نشد");
            return baseResponse;
        }else {
            PaymentDoc paymentDoc =  paymentDocOptional.get();
            if (paymentDoc.getPaymentDocClassList().isEmpty()){
                baseResponse.setStatus(406);
                baseResponse.setMessage("سند کلاسی برای اضافه شدن به سند پرداخت ندارد");
                return baseResponse;
            }
            boolean notCompleteClassAdded = paymentDoc.getPaymentDocClassList().stream().anyMatch(o -> o.getFinalAmount()==null || o.getFinalAmount()==0);

            if (notCompleteClassAdded){
                baseResponse.setStatus(406);
                baseResponse.setMessage("در بعضی از کلاس های سند پرداخت مبلغ کل محاسبه نشده است");
                return baseResponse;
            }
            if (paymentDoc.getPaymentDocStatus().equals(registration)){
                try {
                    baseResponse.setStatus(200);
                    paymentDoc.setPaymentDocStatus(PaymentDocStatus.paid);
                    return baseResponse;
                }catch (Exception e){
                    baseResponse.setStatus(500);
                    baseResponse.setMessage("تغییر وضعیت انجام نشد");
                    return baseResponse;
                }

            }else {
                baseResponse.setStatus(406);
                baseResponse.setMessage("وضعیت سند پرداخت پرداخت شده است و قابل تغییر نمی باشد");
                return baseResponse;

            }

        }


    }

}
