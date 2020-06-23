package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationAnalysisDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.EvaluationAnalysis;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.EvaluationAnalysisDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.modelmapper.TypeToken;

import java.util.*;

@Service
@RequiredArgsConstructor
public class EvaluationAnalysisService implements IEvaluationAnalysisService {

    private final ModelMapper modelMapper;
    private final EvaluationAnalysisDAO evaluationAnalysisDAO;
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final ParameterService parameterService;
    private final TclassDAO tclassDAO;
    private final ITclassService tclassService;

    @Transactional(readOnly = true)
    @Override
    public EvaluationAnalysisDTO.Info get(Long id) {
        final Optional<EvaluationAnalysis> sById = evaluationAnalysisDAO.findById(id);
        final EvaluationAnalysis evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));
        return modelMapper.map(evaluation, EvaluationAnalysisDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationAnalysisDTO.Info> list() {
        final List<EvaluationAnalysis> sAll = evaluationAnalysisDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<EvaluationAnalysisDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EvaluationAnalysisDTO.Info create(EvaluationAnalysis request) {
        return modelMapper.map(evaluationAnalysisDAO.saveAndFlush(request),EvaluationAnalysisDTO.Info.class);
    }

    @Transactional
    @Override
    public EvaluationAnalysisDTO.Info update(Long id, EvaluationAnalysisDTO.Update request) {
        final Optional<EvaluationAnalysis> sById = evaluationAnalysisDAO.findById(id);
        final EvaluationAnalysis evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));

        EvaluationAnalysis updating = new EvaluationAnalysis();
        modelMapper.map(evaluation, updating);
        modelMapper.map(request, updating);

        return modelMapper.map(evaluationAnalysisDAO.save(updating), EvaluationAnalysisDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        evaluationAnalysisDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(EvaluationAnalysisDTO.Delete request) {
        final List<EvaluationAnalysis> sAllById = evaluationAnalysisDAO.findAllById(request.getIds());
        evaluationAnalysisDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EvaluationAnalysisDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(evaluationAnalysisDAO, request, evaluation -> modelMapper.map(evaluation, EvaluationAnalysisDTO.Info.class));
    }

    @Transactional
    @Override
    public void updateLearningEvaluation(Long classId, String scoringMethod) {
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findByTClassId(classId);
        Map<String,Object> learningResult = this.evaluationAnalysistLearningResult(classId,scoringMethod);
        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if(evaluationAnalyses != null && evaluationAnalyses.size() > 0){
            evaluationAnalysis = evaluationAnalyses.get(0);
            evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = updateEffectivenessEvaluation(evaluationAnalysis);
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            update(evaluationAnalysis.getId(),modelMapper.map(evaluationAnalysis,EvaluationAnalysisDTO.Update.class));
        }
        else{
            evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = updateEffectivenessEvaluation(evaluationAnalysis);
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    @Transactional
    @Override
    public void updateReactionEvaluation(Long classId) {
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findByTClassId(classId);
        Map<String,Object> reactionResult = tclassService.getFERAndFETGradeResult(classId);
        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if(evaluationAnalyses != null && evaluationAnalyses.size() > 0){
            evaluationAnalysis = evaluationAnalyses.get(0);
            evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());
            evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));
            evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());
            evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = updateEffectivenessEvaluation(evaluationAnalysis);
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            update(evaluationAnalysis.getId(),modelMapper.map(evaluationAnalysis,EvaluationAnalysisDTO.Update.class));
        }
        else{
            evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());
            evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));
            evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());
            evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = updateEffectivenessEvaluation(evaluationAnalysis);
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    public Map<String,Object> evaluationAnalysistLearningResult(Long classId, String scoringMethod) {
        Float[] result =  evaluationAnalysistLearningService.getStudents(classId,scoringMethod);
        Map<String,Object> finalResult = new HashMap<>();

        Double minScoreEL = 0.0;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEL");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreEL"))
                minScoreEL = Double.parseDouble(parameterValue.getValue());
        }

        Float felGrade = null;

        if(result != null && result.length > 2)
            felGrade = result[3];

        finalResult.put("felGrade",felGrade);
        if(felGrade >= minScoreEL)
            finalResult.put("felPass",true);
        else
            finalResult.put("felPass",false);

        return finalResult;
    }


    public Map<String,Object> updateEffectivenessEvaluation(EvaluationAnalysis evaluationAnalysis){
        Double effectivenessGrade = 0.0;
        Boolean effectivenessPass = false;
        Map<String,Object> finalResult = new HashMap<>();
        if(evaluationAnalysis.getReactionGrade()==null && evaluationAnalysis.getLearningGrade()==null){
            return null;
        }
        else if(evaluationAnalysis.getReactionGrade()!=null && evaluationAnalysis.getLearningGrade()==null){
            double FECRZ = 0.0;
            double minScoreFECR = 0.0;
            TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_R");
            List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues) {
                if (parameterValue.getCode().equalsIgnoreCase("FECRZ"))
                    FECRZ = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                    minScoreFECR = Double.parseDouble(parameterValue.getValue());
            }
            effectivenessGrade = Double.parseDouble(evaluationAnalysis.getReactionGrade()) * FECRZ;
            if (effectivenessGrade >= minScoreFECR)
                effectivenessPass = true;
        }
        else if(evaluationAnalysis.getReactionGrade()==null && evaluationAnalysis.getLearningGrade()!=null){
            return null;
        }
        else if(evaluationAnalysis.getReactionGrade()!=null && evaluationAnalysis.getLearningGrade()!=null){
            Double FECLZ1 = 0.0;
            Double FECLZ2 = 0.0;
            Double minScoreFECR = 0.0;
            TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_L");
            List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues) {
                if (parameterValue.getCode().equalsIgnoreCase("FECLZ1"))
                    FECLZ1 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECLZ2"))
                    FECLZ2 = Double.parseDouble(parameterValue.getValue());
            }

            parameters = parameterService.getByCode("FEC_R");
            parameterValues = parameters.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues) {
                if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                    minScoreFECR = Double.parseDouble(parameterValue.getValue());
            }

            effectivenessGrade = Double.parseDouble(evaluationAnalysis.getLearningGrade()) * FECLZ2 + Double.parseDouble(evaluationAnalysis.getReactionGrade()) * FECLZ1;

            if(effectivenessGrade >= minScoreFECR)
                effectivenessPass = true;
            else
                effectivenessPass = false;
        }
        finalResult.put("EffectivenessGrade", effectivenessGrade);
        finalResult.put("EffectivenessPass",effectivenessPass);
        return finalResult;
    }




}
