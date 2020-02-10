package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IEvaluation;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.model.Course;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.EvaluationAnswerDAO;
import com.nicico.training.repository.EvaluationDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluationService {

    private final ModelMapper modelMapper;
    private final EvaluationDAO evaluationDAO;
    private final EvaluationAnswerDAO evaluationAnswerDAO;
    private final EnumsConverter.EDomainTypeConverter eDomainTypeConverter = new EnumsConverter.EDomainTypeConverter();
    private final ParameterService parameterService;
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

        return save(modelMapper.map(request, Evaluation.class));
    }

    @Transactional
    @Override
    public EvaluationDTO.Info update(Long id, EvaluationDTO.Update request) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));

        Evaluation updating = new Evaluation();
        modelMapper.map(evaluation, updating);
        modelMapper.map(request, updating);

        updating.setVersion(evaluation.getVersion());

        for (EvaluationAnswer evaluationAnswer : updating.getEvaluationAnswerList()) {
            evaluationAnswer.setEvaluationId(id);
        }

        return modelMapper.map(evaluationDAO.save(updating), EvaluationDTO.Info.class);
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

        List<EvaluationAnswer> evaluationAnswers = evaluation.getEvaluationAnswerList();

        evaluation.setEvaluationAnswerList(null);
        final Evaluation saved = evaluationDAO.saveAndFlush(evaluation);

        Long evaluationId = saved.getId();
        for (EvaluationAnswer evaluationAnswer : evaluationAnswers) {
            evaluationAnswer.setEvaluationId(evaluationId);
        }

        evaluationAnswerDAO.saveAll(evaluationAnswers);

        return modelMapper.map(saved, EvaluationDTO.Info.class);
    }

    @Override
    public Evaluation getStudentEvaluationForClass(Long classId,Long studentId){
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters =  parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if(parameterValue.getCode().equalsIgnoreCase("3"))
                evaluatorTypeId = parameterValue.getId();
        }
        return evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId,studentId,evaluatorTypeId).get(0);
    }

    @Override
    public Evaluation getTeacherEvaluationForClass(Long teacherId,Long classId){
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters =  parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if(parameterValue.getCode().equalsIgnoreCase("1"))
                evaluatorTypeId = parameterValue.getId();
        }
        return evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId,teacherId,evaluatorTypeId).get(0);
    }
}
