package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.iservice.IEvaluation;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.model.Course;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.EvaluationDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluationService {

    private final ModelMapper modelMapper;
    private final EvaluationDAO evaluationDAO;
    private final EnumsConverter.EDomainTypeConverter eDomainTypeConverter = new EnumsConverter.EDomainTypeConverter();
    private final CourseDAO courseDAO;

    @Transactional(readOnly = true)
    @Override
    public EvaluationDTO.Info get(Long id) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));
        return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationDTO.Info> list() {
        final List<Evaluation> sAll = evaluationDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<EvaluationDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EvaluationDTO.Info create(EvaluationDTO.Create request) {
        final Evaluation evaluation = modelMapper.map(request, Evaluation.class);
        return save(evaluation);
    }

    @Transactional
    @Override
    public EvaluationDTO.Info update(Long id, EvaluationDTO.Update request) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));
        Evaluation updating = new Evaluation();
        modelMapper.map(evaluation, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        evaluationDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(EvaluationDTO.Delete request) {
        final List<Evaluation> sAllById = evaluationDAO.findAllById(request.getIds());

        evaluationDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EvaluationDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(evaluationDAO, request, evaluation -> modelMapper.map(evaluation, EvaluationDTO.Info.class));
    }


    // ------------------------------

    private EvaluationDTO.Info save(Evaluation evaluation) {

        final Evaluation saved = evaluationDAO.saveAndFlush(evaluation);
        return modelMapper.map(saved, EvaluationDTO.Info.class);
    }
}
