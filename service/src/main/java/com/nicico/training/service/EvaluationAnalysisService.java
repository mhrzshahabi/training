package com.nicico.training.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationAnalysisDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.EvaluationAnalysisDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.modelmapper.TypeToken;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
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
    private final IEvaluationService evaluationService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;

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

        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        Map<String,Object> learningResult = this.evaluationAnalysistLearningResult(classId,scoringMethod);
        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if(evaluationAnalyses != null && evaluationAnalyses.size() > 0){
            evaluationAnalysis = evaluationAnalyses.get(0);
            evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            Map<String,Object> effectivenessResult = calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                                                    learningResult.get("felGrade").toString(),evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
        }
        else{
            evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult =  calculateEffectivenessEvaluation(null,
                    learningResult.get("felGrade").toString(),null, tclass.getEvaluation());
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

        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if(evaluationAnalyses != null && evaluationAnalyses.size() > 0){
            evaluationAnalysis = evaluationAnalyses.get(0);
            evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());
            evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));
            evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());
            evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));
            Map<String,Object> effectivenessResult = calculateEffectivenessEvaluation(reactionResult.get("FERGrade").toString(),
                    evaluationAnalysis.getLearningGrade(),evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
        }
        else{
            evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());
            evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));
            evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());
            evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = calculateEffectivenessEvaluation(reactionResult.get("FERGrade").toString(),
                    null,null, tclass.getEvaluation());
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    @Transactional
    @Override
    public void updateBehavioral(Long classId) {
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findByTClassId(classId);
        EvaluationDTO.BehavioralResult behavioralResult =  evaluationService.getBehavioralEvaluationResult(classId);
        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if(evaluationAnalyses != null && evaluationAnalyses.size() > 0){
            evaluationAnalysis = evaluationAnalyses.get(0);
            evaluationAnalysis.setBehavioralGrade(behavioralResult.getBehavioralGrade().toString());
            evaluationAnalysis.setBehavioralPass(behavioralResult.getBehavioralPass());
            Map<String,Object> effectivenessResult = calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                    evaluationAnalysis.getLearningGrade(),behavioralResult.getBehavioralGrade().toString(), tclass.getEvaluation());
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
        }
        else{
            evaluationAnalysis.setBehavioralGrade(behavioralResult.getBehavioralGrade().toString());
            evaluationAnalysis.setBehavioralPass(behavioralResult.getBehavioralPass());
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getOne(classId));
            Map<String,Object> effectivenessResult = calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                    evaluationAnalysis.getLearningGrade(),behavioralResult.getBehavioralGrade().toString(), tclass.getEvaluation());
            if(effectivenessResult != null) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    @Transactional
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


    @Transactional
    public Map<String,Object> calculateEffectivenessEvaluation(String reactionGrade_s,String learningGrade_s, String behavioralGrade_s, String classEvaluation){
        Double effectivenessGrade = 0.0;
        Boolean effectivenessPass = false;
        Map<String,Object> finalResult = new HashMap<>();

        double reactionGrade = 0.0;
        double learningGrade = 0.0;
        double behavioralGrade = 0.0;

        if(reactionGrade_s != null)
            reactionGrade = Double.parseDouble(reactionGrade_s);
        if(learningGrade_s != null)
            learningGrade = Double.parseDouble(learningGrade_s);
        if(behavioralGrade_s != null)
            behavioralGrade = Double.parseDouble(behavioralGrade_s);

        if(classEvaluation != null && classEvaluation.equalsIgnoreCase("1")){
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
            effectivenessGrade = (reactionGrade * FECRZ)/100;
            if (effectivenessGrade >= minScoreFECR)
                effectivenessPass = true;
        }
        else if(classEvaluation != null && classEvaluation.equalsIgnoreCase("2")){
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

            effectivenessGrade = (reactionGrade * FECLZ1 + learningGrade * FECLZ2)/100;

            if(effectivenessGrade >= minScoreFECR)
                effectivenessPass = true;
            else
                effectivenessPass = false;
        }
        else if(classEvaluation != null && classEvaluation.equalsIgnoreCase("3")){
            Double FECBZ1 = 0.0;
            Double FECBZ2 = 0.0;
            Double FECBZ3 = 0.0;
            Double minScoreFECR = 0.0;
            TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_B");
            List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues) {
                if (parameterValue.getCode().equalsIgnoreCase("FECBZ1"))
                    FECBZ1 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECBZ2"))
                    FECBZ2 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECBZ3"))
                    FECBZ3 = Double.parseDouble(parameterValue.getValue());
            }

            parameters = parameterService.getByCode("FEC_R");
            parameterValues = parameters.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues) {
                if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                    minScoreFECR = Double.parseDouble(parameterValue.getValue());
            }

            effectivenessGrade = (reactionGrade * FECBZ1 + learningGrade * FECBZ2 + behavioralGrade * FECBZ3)/100;

            if(effectivenessGrade >= minScoreFECR)
                effectivenessPass = true;
            else
                effectivenessPass = false;
        }

        finalResult.put("EffectivenessGrade", effectivenessGrade);
        finalResult.put("EffectivenessPass",effectivenessPass);
        return finalResult;
    }

    @Transactional
    @Override
    public void print (HttpServletResponse response, String type , String fileName, Long classId, String receiveParams, String suggestions, String opinion) throws Exception {
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        List<Map> studentsList = new ArrayList();
        for (ClassStudent student : tclass.getClassStudents()) {
            Map<String,String> std = new HashMap<>();
            std.put("studentFullName",student.getStudent().getFirstName() + " " + student.getStudent().getLastName());
            std.put("personnelCode",student.getStudent().getPersonnelNo());
            studentsList.add(std);
        }

        EvaluationDTO.BehavioralResult result = evaluationService.getBehavioralEvaluationResult(classId);
        List<Map> indicesList = new ArrayList();
        List<Map> behavioralChart = new ArrayList();
        int i = 1;
        for (Goal goal : tclass.getCourse().getGoalSet()) {
            Map<String,String> indice = new HashMap<>();
            indice.put("indicatorEx",goal.getTitleFa());
            indice.put("indicatorNo", "شاخص " +i);
            indicesList.add(indice);

            Map<String,Object> behavior = new HashMap<>();
            behavior.put("behaviorVal",result.getIndicesGrade().get("g"+goal.getId()));
            behavior.put("behaviorCat","شاخص " +i);
            behavioralChart.add(behavior);

            i++;
        }
        for (Skill skill : tclass.getCourse().getSkillSet()) {
            Map<String,String> indice = new HashMap<>();
            indice.put("indicatorEx",skill.getTitleFa());
            indice.put("indicatorNo", "شاخص " + i);
            indicesList.add(indice);

            Map<String,Object> behavior = new HashMap<>();
            behavior.put("behaviorVal",result.getIndicesGrade().get("s"+skill.getId()));
            behavior.put("behaviorCat","شاخص " + i);
            behavioralChart.add(behavior);

            i++;
        }

        List<Map> behavioralScoreChart = new ArrayList();
        String[] classStudentsName = result.getClassStudentsName();
        Double[] behavioralGrades = result.getBehavioralGrades();
        for(int z=0;z<result.getClassStudentsName().length;z++){
            Map<String,Object> behavior = new HashMap<>();
            behavior.put("scoreVal",behavioralGrades[z]);
            behavior.put("scoreCat",classStudentsName[z]);
            behavioralScoreChart.add(behavior);
        }

        Map<String,Object> behavior = new HashMap<>();
        behavior.put("scoreVal",result.getBehavioralGrade());
        behavior.put("scoreCat","میانگین تغییر رفتار دوره");
        behavioralScoreChart.add(behavior);

        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
        String data = "";
        data = "{" + "\"courseRegistered\": " +  objectMapper.writeValueAsString(studentsList) + ","  +
                "\"behavioralIndicators\": " + objectMapper.writeValueAsString(indicesList) + ","  +
                "\"behavioralChart\": " + objectMapper.writeValueAsString(behavioralChart) + ","  +
                "\"behavioralScoreChart\": " + objectMapper.writeValueAsString(behavioralScoreChart) + "}";
        params.put("today", DateUtil.todayDate());
        params.put("course", tclass.getCourse().getTitleFa());
        params.put("courseRegisteredCount", tclass.getClassStudents().size() + "");
        params.put("criticisim", suggestions);
        params.put("comment", opinion);
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

}
