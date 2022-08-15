package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.model.AgreementClassCost;

import java.util.List;

public interface IAgreementClassCostService {

    AgreementClassCostDTO.Info create(AgreementClassCostDTO.Create request);

    void createOrUpdateClassCostList(List<AgreementClassCostDTO.Create> costList, Long agreementId);

    AgreementClassCostDTO.Info update(AgreementClassCostDTO.Update update, Long id);

    void updateTeachingCostPerHourAuto(Long id, Double teachingCostPerHourAuto);

    SearchDTO.SearchRs<AgreementClassCostDTO.Info> search(SearchDTO.SearchRq request);

    void delete(Long id);

    List<AgreementClassCost> findAllByAgreementId(Long agreementId);

    List<AgreementClassCost> findAll();

    void calculateTeachingCost(AgreementClassCostDTO.CalcTeachingCostList calcInfoList);
}
