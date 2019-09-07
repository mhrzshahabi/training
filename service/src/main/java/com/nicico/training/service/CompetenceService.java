/*
ghazanfari_f, 9/7/2019, 10:57 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.iservice.ICompetenceService;
import com.nicico.training.model.Competence;
import com.nicico.training.repository.CompetenceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CompetenceService implements ICompetenceService {

    private final CompetenceDAO competenceDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public CompetenceDTO.Info get(Long id) {

        final Optional<Competence> optionalCompetence = competenceDAO.findById(id);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        return modelMapper.map(competence, CompetenceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTO.Info> list() {
        List<Competence> competenceList = competenceDAO.findAll();
        return modelMapper.map(competenceList, new TypeToken<List<CompetenceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CompetenceDTO.Info create(CompetenceDTO.Create request) {
        Competence competence = modelMapper.map(request, Competence.class);
        return modelMapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTO.Info.class);
    }

    @Transactional
    @Override
    public CompetenceDTO.Info update(Long id, CompetenceDTO.Update request) {
        Optional<Competence> optionalCompetence = competenceDAO.findById(id);
        Competence currentCompetence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        Competence competence = new Competence();
        modelMapper.map(currentCompetence, competence);
        modelMapper.map(request, competence);
        return modelMapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        competenceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CompetenceDTO.Delete request) {
        final List<Competence> competenceList = competenceDAO.findAllById(request.getIds());
        competenceDAO.deleteAll(competenceList);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(competenceDAO, request, competence -> modelMapper.map(competence, CompetenceDTO.Info.class));
    }
}
