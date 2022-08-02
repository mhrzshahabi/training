package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.AgreementDAO;
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
public class AgreementService implements IAgreementService {

    private final ModelMapper modelMapper;
    private final AgreementDAO agreementDAO;
    private final IAgreementClassCostService agreementClassCostService;


    @Override
    public Agreement get(Long id) {
        return agreementDAO.findById(id).orElse(null);
    }

    @Transactional
    @Override
    public AgreementDTO.Info create(AgreementDTO.Create request) {

        final Agreement agreement = modelMapper.map(request, Agreement.class);
        List<AgreementClassCostDTO.Create> classCostCreate = request.getClassCostList();
        try {
            AgreementDTO.Info info = modelMapper.map(agreementDAO.saveAndFlush(agreement), AgreementDTO.Info.class);
            classCostCreate.forEach(item -> {
                item.setAgreementId(info.getId());
                agreementClassCostService.create(item);
            });
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
        List<AgreementClassCostDTO.Create> classCostCreate = update.getClassCostList();

        List<AgreementClassCost> costList =  agreementClassCostService.findAllByAgreementId(id);

        if (update.isChanged()) {

            costList.forEach(item -> agreementClassCostService.delete(item.getId()));
            if (classCostCreate.size() != 0) {
                classCostCreate.forEach(item -> {
                    item.setAgreementId(agreement.getId());
                    agreementClassCostService.create(item);
                });
            }
        }

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

}
