package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
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
//        final Evaluation evaluation = modelMapper.map(request, Evaluation.class);
//        return save(evaluation);


//        Parent parent = new Parent();
//...
//        Child c1 = new Child();
//...
//        c1.setParent(parent);
//
//        List<Child> children = new ArrayList<Child>();
//        children.add(c1);
//        parent.setChildren(children);
//
//        session.save(parent);

        HashMap evaluationData = modelMapper.map(request, HashMap.class);

        Evaluation evaluation = new Evaluation();
        evaluation.setClassId(Long.parseLong(evaluationData.get("id").toString()));
        evaluation.setEvaluatedId(1L);
        evaluation.setEvaluatedTypeId(42L);
        evaluation.setEvaluationLevelId(42L);
        evaluation.setEvaluatorId(1L);
        evaluation.setEvaluatorTypeId(42L);
        evaluation.setDescription("desc");

//        HashMap<String, String> evaluationAnswer = modelMapper.map(evaluationData.get("evaluationAnswerList"), HashMap.class);
//        List<EvaluationAnswer> evaluationAnswerList = new ArrayList<>();
//
//        evaluationAnswer.forEach((questionId, answer) -> {
//            EvaluationAnswer evalAnswer = new EvaluationAnswer();
//            evalAnswer.setAnswerId(Long.parseLong(answer));
//            evalAnswer.setQuestionnaireQuestionId(Long.parseLong(questionId.replace("Q", "")));
//            evalAnswer.setCreatedDate(date);
//            evalAnswer.setCreatedBy("h.ras");
//            evalAnswer.setVersion(0);
//
//            evalAnswer.setEvaluation(evaluation);
//
//            evaluationAnswerList.add(evalAnswer);
//        });

//        evaluation.setEvaluationAnswerList(evaluationAnswerList);

        return save(modelMapper.map(evaluation, Evaluation.class));
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
//        return modelMapper.map(saved, EvaluationDTO.Info.class);
        return null;
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
}
