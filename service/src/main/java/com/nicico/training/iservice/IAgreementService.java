package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.model.Agreement;

import java.util.List;

public interface IAgreementService {

    AgreementDTO.Info create(AgreementDTO.Create request);

    Agreement update(AgreementDTO.Update update, Long id);

    SearchDTO.SearchRs<AgreementDTO.Info> search(SearchDTO.SearchRq request);

    void delete(Long id);

    List<Agreement> findAll();
}
