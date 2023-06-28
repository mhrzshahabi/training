package com.nicico.training.service;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.iservice.IAgreementClassCostService;
import com.nicico.training.iservice.IAgreementService;
import com.nicico.training.model.Agreement;
import com.nicico.training.model.AgreementClassCost;
import com.nicico.training.model.enums.AgreementStatus;
import com.nicico.training.repository.AgreementDAO;
import com.nicico.training.repository.ComplexDAO;
import dto.bpms.AgreementParamsDto;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;

import static com.nicico.training.model.enums.AgreementStatus.*;

@Service
@RequiredArgsConstructor
public class AgreementService implements IAgreementService {

    private final ModelMapper modelMapper;
    private final AgreementDAO agreementDAO;
    private final IAgreementClassCostService agreementClassCostService;
    private final ComplexDAO complexDAO;


    @Override
    public Agreement get(Long id) {
        return agreementDAO.findById(id).orElse(null);
    }

    @Transactional
    @Override
    public AgreementDTO.Info create(AgreementDTO.Create request) {

        final Agreement agreement = modelMapper.map(request, Agreement.class);
        try {
            Long complexId = request.getComplexId();
            String complexTitle = complexDAO.getComplexTitleByComplexId(complexId);
            agreement.setComplexId(complexId);
            agreement.setComplexTitle(complexTitle);
            agreement.setAgreementStatus(registration);
            Agreement savedAgreement = agreementDAO.saveAndFlush(agreement);
            AgreementDTO.Info info = modelMapper.map(savedAgreement, AgreementDTO.Info.class);
            return info;
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public Agreement update(AgreementDTO.Update update, Long id) {

        Optional<Agreement> agreementOptional = agreementDAO.findById(id);
        Agreement agreement = agreementOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        Long complexId = update.getComplexId();
        String complexTitle = complexDAO.getComplexTitleByComplexId(complexId);
        update.setComplexTitle(complexTitle);

        Agreement updating = new Agreement();
        modelMapper.map(agreement, updating);
        modelMapper.map(update, updating);
        return agreementDAO.saveAndFlush(updating);
    }

    @Transactional
    @Override
    public Agreement upload(AgreementDTO.Upload upload) {

        Optional<Agreement> agreementOptional = agreementDAO.findById(upload.getId());
        Agreement agreement = agreementOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        agreement.setFileName(upload.getFileName());
        agreement.setGroup_id(upload.getGroup_id());
        agreement.setKey(upload.getKey());
        return agreementDAO.saveAndFlush(agreement);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AgreementDTO.Info> search(SearchDTO.SearchRq request) {
        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion != null) {
                    if (criterion.getFieldName().equals("agreementStatus.titleFa")) {
                        criterion.setFieldName("agreementStatus");
                        criterion.setValue(AgreementStatus.fromString(String.valueOf(criterion.getValue().get(0))));
                    }

                }

            }
        }
        return SearchUtil.search(agreementDAO, request, agreement -> modelMapper.map(agreement, AgreementDTO.Info.class));
    }

    @Transactional
    @Override
    public void delete(Long id) {

        List<AgreementClassCost> agreementClassCostList = agreementClassCostService.findAllByAgreementId(id);
        agreementClassCostList.forEach(item -> {
            agreementClassCostService.delete(item.getId());
        });
        agreementDAO.deleteById(id);
    }

    @Override
    @Transactional
    public BaseResponse startAgreementProcess(AgreementParamsDto params, HttpServletResponse response,ProcessInstance processInstance) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            Long id = Long.valueOf(params.getData().get("id").toString());
            Agreement agreement = get(id);
            if (agreement!=null){
                agreement.setProcessInstanceId(processInstance.getId());
                agreement.setAgreementStatus(waiting);
                agreementDAO.saveAndFlush(agreement);
                baseResponse.setStatus(200);
            }else {
                baseResponse.setStatus(404);
                baseResponse.setMessage("تفاهم نامه یافت نشد");
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            baseResponse.setStatus(404);
            baseResponse.setMessage("مشکلی در ارسال به گردش کار  وجود دارد");
        } catch (TrainingException trainingException) {
            if (trainingException.getHttpStatusCode().equals(403)) {
                baseResponse.setStatus(403);
                baseResponse.setMessage("مدیر مالی تعریف نشده است یا بیش از یک مدیر تعریف شده است");
            } else
                baseResponse.setStatus(406);
        } catch (Exception e) {
            baseResponse.setStatus(406);
            baseResponse.setMessage("ارسال به گردش کار انجام نشد، لطفا دوباره تلاش کنيد");
        }
        return baseResponse;
    }

    @Override
    public AgreementDTO getAgreementDetailByProcessInstanceId(String processInstanceId) {
        Optional<Agreement> optionalAgreement = agreementDAO.findByProcessInstanceId(processInstanceId);
        Agreement agreement = optionalAgreement.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(agreement, AgreementDTO.class);
    }

    @Override
    public BaseResponse updateAgreement(AgreementStatus agreementStatus,String processInstanceId, String returnReason) {
        BaseResponse response = new BaseResponse();

        Optional<Agreement> optionalAgreement = agreementDAO.findByProcessInstanceId(processInstanceId);
         try {

             if (optionalAgreement.isPresent()){

                 Agreement agreement = optionalAgreement.get();
                 agreement.setAgreementStatus(agreementStatus);
                 if (returnReason!=null)
                 agreement.setReturnDetail(returnReason);
                 response.setStatus(200);
                 agreementDAO.saveAndFlush(agreement);

             }else {
                 response.setStatus(406);

             }

         }catch (Exception e){
             response.setStatus(406);
         }
         return response;
     }

}
