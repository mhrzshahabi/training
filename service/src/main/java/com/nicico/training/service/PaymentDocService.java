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

import javax.validation.ConstraintViolationException;
import java.util.Optional;

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
                paymentDoc.setPaymentDocStatus(PaymentDocStatus.registration);
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

//    @Transactional
//    @Override
//    public Agreement upload(AgreementDTO.Upload upload) {
//
//        Optional<Agreement> agreementOptional = agreementDAO.findById(upload.getId());
//        Agreement agreement = agreementOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
//        agreement.setFileName(upload.getFileName());
//        agreement.setGroup_id(upload.getGroup_id());
//        agreement.setKey(upload.getKey());
//        return agreementDAO.saveAndFlush(agreement);
//    }
//
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

}
