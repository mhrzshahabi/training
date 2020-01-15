/*
ghazanfari_f, 9/7/2019, 10:57 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTOOld;
import com.nicico.training.iservice.ICompetenceService;
import com.nicico.training.model.CompetenceOld;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CompetenceDAOOld;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CompetenceServiceOld implements ICompetenceService {

    private final CompetenceDAOOld competenceDAO;
    private final ModelMapper modelMapper;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ECompetenceInputTypeConverter eCompetenceInputTypeConverter = new EnumsConverter.ECompetenceInputTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public CompetenceDTOOld.Info get(Long id) {
        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(id);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        return modelMapper.map(competence, CompetenceDTOOld.Info.class);
    }

    @Transactional
    @Override
    public CompetenceDTOOld.Info create(CompetenceDTOOld.Create request) {
        CompetenceOld competence = modelMapper.map(request, CompetenceOld.class);
        competence.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getEtechnicalTypeId()));
        competence.setECompetenceInputType(eCompetenceInputTypeConverter.convertToEntityAttribute(request.getEcompetenceInputTypeId()));
        return modelMapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTOOld.Info.class);
    }

    @Transactional
    @Override
    public CompetenceDTOOld.Info update(Long id, CompetenceDTOOld.Update request) {
        Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(id);
        CompetenceOld currentCompetence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        CompetenceOld competence = new CompetenceOld();
        modelMapper.map(currentCompetence, competence);
        modelMapper.map(request, competence);
        return modelMapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTOOld.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        competenceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CompetenceDTOOld.Delete request) {
        final List<CompetenceOld> competenceList = competenceDAO.findAllById(request.getIds());
        competenceDAO.deleteAll(competenceList);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTOOld.Info> list() {
        List<CompetenceOld> competenceList = competenceDAO.findAll();
        return modelMapper.map(competenceList, new TypeToken<List<CompetenceDTOOld.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CompetenceDTOOld.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(competenceDAO, request, competence -> modelMapper.map(competence, CompetenceDTOOld.Info.class));
    }

}
