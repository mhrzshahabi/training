package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.iservice.IAgreementClassCostService;
import com.nicico.training.model.AgreementClassCost;
import com.nicico.training.repository.AgreementClassCostDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AgreementClassCostService implements IAgreementClassCostService {

    private final ModelMapper modelMapper;
    private final AgreementClassCostDAO agreementClassCostDAO;


    @Override
    public AgreementClassCostDTO.Info create(AgreementClassCostDTO.Create request) {

        final AgreementClassCost agreementClassCost = modelMapper.map(request, AgreementClassCost.class);
        try {
            return modelMapper.map(agreementClassCostDAO.saveAndFlush(agreementClassCost), AgreementClassCostDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public AgreementClassCost update(AgreementClassCostDTO.Update update, Long id) {

        Optional<AgreementClassCost> agreementOptional = agreementClassCostDAO.findById(id);
        AgreementClassCost agreementClassCost = agreementOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return agreementClassCostDAO.saveAndFlush(agreementClassCost);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AgreementClassCostDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(agreementClassCostDAO, request, agreementClassCost -> modelMapper.map(agreementClassCost, AgreementClassCostDTO.Info.class));
    }

    @Transactional
    @Override
    public void delete(Long id) {
        agreementClassCostDAO.deleteById(id);
    }

    @Override
    public List<AgreementClassCost> findAllByAgreementId(Long agreementId) {
        return agreementClassCostDAO.findAllByAgreement_Id(agreementId);
    }

    @Override
    public List<AgreementClassCost> findAll() { return agreementClassCostDAO.findAll(); }

}
