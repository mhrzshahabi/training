package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.EvaluationAnswerDAO;
import com.nicico.training.repository.EvaluationDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluationService {

    private final ModelMapper modelMapper;
    private final EvaluationDAO evaluationDAO;
    private final ClassStudentDAO classStudentDAO;
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
        studentEvaluationRegister(updating);

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
        studentEvaluationRegister(evaluation);

        return modelMapper.map(saved, EvaluationDTO.Info.class);
    }

    @Override
    public Evaluation getStudentEvaluationForClass(Long classId, Long studentId) {
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("32"))
                evaluatorTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId, studentId, evaluatorTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getTeacherEvaluationForClass(Long teacherId, Long classId) {
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("11"))
                evaluatorTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId, teacherId, evaluatorTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getTrainingEvaluationForTeacher(Long teacherId, Long classId, Long trainingId) {
        Long evaluatorTypeId = null;
        Long evaluatedTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("4"))
                evaluatorTypeId = parameterValue.getId();
            if (parameterValue.getCode().equalsIgnoreCase("11"))
                evaluatedTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(
                classId, trainingId, evaluatorTypeId, teacherId, evaluatedTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getBehavioralEvaluationByStudent(Long studentId, Long classId) {
        Long evaluationLevelId = Long.parseLong(156 + "");
        Long questionnaireTypeId = Long.parseLong(139 + "");
        Long evaluatorTypeId = Long.parseLong(188 + "");
        Long evaluatorId = studentId;
        List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluatorTypeIdAndEvaluatorIdAndEvaluationLevelIdAndQuestionnaireTypeId
                (classId,
                        evaluatorTypeId,
                        evaluatorId,
                        evaluationLevelId,
                        questionnaireTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    //    @Override
    public EvaluationDTO.Info getEvaluationByData(Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId, Long evaluatedTypeId, Long evaluationLevelId) {
        final Evaluation evaluation = evaluationDAO.findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(questionnaireTypeId, classId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);
        return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    private void studentEvaluationRegister(Evaluation evaluation) {
        if (evaluation.getQuestionnaireTypeId().equals(139L)) {
            Integer x;
            if (evaluation.getEvaluationFull()) {
                x = 2;
            } else {
                x = 3;
            }
            Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatorId());
            ClassStudent classStudent = byId.orElseGet(() -> classStudentDAO.findByTclassIdAndStudentId(evaluation.getClassId(), evaluation.getEvaluatorId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound)));
            if (evaluation.getEvaluationLevelId() == 154L) {
                classStudent.setEvaluationStatusReaction(x);
            } else if (evaluation.getEvaluationLevelId() == 155L) {
                classStudent.setEvaluationStatusLearning(x);
            } else if (evaluation.getEvaluationLevelId() == 156L) {
                classStudent.setEvaluationStatusBehavior(x);
            } else if (evaluation.getEvaluationLevelId() == 157L) {
                classStudent.setEvaluationStatusResults(x);
            }
        }
    }

}
