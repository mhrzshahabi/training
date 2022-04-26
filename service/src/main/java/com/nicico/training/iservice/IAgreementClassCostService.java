package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.model.AgreementClassCost;

import java.util.List;

public interface IAgreementClassCostService {

    AgreementClassCostDTO.Info create(AgreementClassCostDTO.Create request);

    AgreementClassCost update(AgreementClassCostDTO.Update update, Long id);

    SearchDTO.SearchRs<AgreementClassCostDTO.Info> search(SearchDTO.SearchRq request);

    void delete(Long id);

    List<AgreementClassCost> findAllByAgreementId(Long agreementId);

    List<AgreementClassCost> findAll();
}
