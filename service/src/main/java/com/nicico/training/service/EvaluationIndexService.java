package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationIndexDTO;
import com.nicico.training.iservice.IEvaluationIndexService;
import com.nicico.training.model.EvaluationIndex;
import com.nicico.training.repository.EvaluationIndexDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EvaluationIndexService implements IEvaluationIndexService {
    private final ModelMapper modelMapper;
    private final EvaluationIndexDAO evaluationIndexDAO;

    @Transactional(readOnly = true)
    @Override
    public EvaluationIndexDTO.Info get(Long id) {
        final Optional<EvaluationIndex> gById = evaluationIndexDAO.findById(id);
        final EvaluationIndex evaluationIndex = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CountryNotFound));
        return modelMapper.map(evaluationIndex, EvaluationIndexDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationIndexDTO.Info> list() {
        final List<EvaluationIndex> gAll = evaluationIndexDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<EvaluationIndexDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EvaluationIndexDTO.Info create(EvaluationIndexDTO.Create request) {
        final EvaluationIndex evaluationIndex = modelMapper.map(request, EvaluationIndex.class);
        return save(evaluationIndex);
    }

    @Transactional
    @Override
    public EvaluationIndexDTO.Info update(Long id, EvaluationIndexDTO.Update request) {
        final Optional<EvaluationIndex> cById = evaluationIndexDAO.findById(id);
        final EvaluationIndex evaluationIndex = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        EvaluationIndex updating = new EvaluationIndex();
        modelMapper.map(evaluationIndex, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EvaluationIndex> one = evaluationIndexDAO.findById(id);
        final EvaluationIndex evaluationIndex = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        evaluationIndexDAO.delete(evaluationIndex);
    }

    @Transactional
    @Override
    public void delete(EvaluationIndexDTO.Delete request) {
        final List<EvaluationIndex> gAllById = evaluationIndexDAO.findAllById(request.getIds());
        evaluationIndexDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EvaluationIndexDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(evaluationIndexDAO, request, country -> modelMapper.map(country, EvaluationIndexDTO.Info.class));
    }

    // ------------------------------

    private EvaluationIndexDTO.Info save(EvaluationIndex country) {
        final EvaluationIndex saved = evaluationIndexDAO.saveAndFlush(country);
        return modelMapper.map(saved, EvaluationIndexDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationIndex> getListByIds(List<Long> ids) {
        return evaluationIndexDAO.findAllById(ids);
    }
}
