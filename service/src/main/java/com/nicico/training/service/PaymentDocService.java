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
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolationException;

@Service
@RequiredArgsConstructor
public class PaymentDocService implements IPaymentDocService {

//    private final ModelMapper modelMapper;
    private final PaymentDocDAO paymentDocDAO;
    private final PaymentDocMapper paymentDocMapper;


//    @Override
//    public Agreement get(Long id) {
//        return agreementDAO.findById(id).orElse(null);
//    }
//
    @Transactional
    @Override
    public PaymentDTO.Info create(PaymentDTO.Create request) {

         try {
            Long agreementId = request.getAgreementId();
            if (agreementId!=null){
                PaymentDoc paymentDoc =new PaymentDoc();
                paymentDoc.setAgreementId(agreementId);
                paymentDoc.setPaymentDocStatusId(PaymentDocStatus.registration.getId());
                PaymentDoc savedPayment= paymentDocDAO.save(paymentDoc);
                return paymentDocMapper.toDtoInfo(savedPayment);
            }else {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
     }
//
//    @Transactional
//    @Override
//    public Agreement update(AgreementDTO.Update update, Long id) {
//
//        Optional<Agreement> agreementOptional = agreementDAO.findById(id);
//        Agreement agreement = agreementOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
//
//        Long complexId = update.getComplexId();
//        String complexTitle = complexDAO.getComplexTitleByComplexId(complexId);
//        update.setComplexTitle(complexTitle);
//
//        Agreement updating = new Agreement();
//        modelMapper.map(agreement, updating);
//        modelMapper.map(update, updating);
//        return agreementDAO.saveAndFlush(updating);
//    }
//
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
//
//    @Transactional
//    @Override
//    public void delete(Long id) {
//
//        List<AgreementClassCost> agreementClassCostList = agreementClassCostService.findAllByAgreementId(id);
//        agreementClassCostList.forEach(item -> {
//            agreementClassCostService.delete(item.getId());
//        });
//        agreementDAO.deleteById(id);
//    }

}
