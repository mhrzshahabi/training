package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.model.Agreement;
import com.nicico.training.model.enums.AgreementStatus;
import dto.bpms.AgreementParamsDto;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;

public interface IAgreementService {

    Agreement get(Long id);

    AgreementDTO.Info create(AgreementDTO.Create request);

    Agreement update(AgreementDTO.Update update, Long id);

    Agreement upload(AgreementDTO.Upload upload);

    SearchDTO.SearchRs<AgreementDTO.Info> search(SearchDTO.SearchRq request);

    void delete(Long id);

    BaseResponse startAgreementProcess(AgreementParamsDto params, HttpServletResponse response, ProcessInstance processInstance);

    AgreementDTO getAgreementDetailByProcessInstanceId(String processInstanceId);

    BaseResponse updateAgreement(AgreementStatus agreementStatus ,String processInstanceId, String returnReason);
}
