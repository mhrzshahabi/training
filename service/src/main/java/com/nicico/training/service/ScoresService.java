package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ScoresDTO;
import com.nicico.training.iservice.IScoresService;
import com.nicico.training.model.Scores;
import com.nicico.training.repository.ScoresDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScoresService implements IScoresService {

    private final ScoresDAO scoresDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public ScoresDTO.Info get(Long id) {
        final Optional<Scores> optionalScores = scoresDAO.findById(id);
        final Scores scores = optionalScores.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(scores, ScoresDTO.Info.class);
    }

    @Transactional
    @Override
    public List<ScoresDTO.Info> list() {
        List<Scores> scoresList = scoresDAO.findAll();
        return mapper.map(scoresList, new TypeToken<List<ScoresDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ScoresDTO.Info create(ScoresDTO.Create request) {
        Scores scores = mapper.map(request, Scores.class);
        return mapper.map(scoresDAO.saveAndFlush(scores), ScoresDTO.Info.class);
    }

    @Transactional
    @Override
    public ScoresDTO.Info update(Long id, ScoresDTO.Update request) {
        Optional<Scores> optionalScores = scoresDAO.findById(id);
        Scores currentCheckList = optionalScores.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        Scores scores = new Scores();
        mapper.map(currentCheckList, scores);
        mapper.map(request, scores);
        return mapper.map(scoresDAO.saveAndFlush(scores), ScoresDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        scoresDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(ScoresDTO.Delete request) {
        final List<Scores> scoresList = scoresDAO.findAllById(request.getIds());
        scoresDAO.deleteAll(scoresList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<ScoresDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(scoresDAO, request, scores -> mapper.map(scores, ScoresDTO.Info.class));
    }



}
