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
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.EvaluationAnalysisDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.repository.ClassEvaluationGoalsDAO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.EvaluationAnalysisDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.utility.PersianCharachtersUnicode;
import io.netty.util.internal.MathUtil;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.math3.util.MathUtils;
import org.modelmapper.ModelMapper;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.modelmapper.TypeToken;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class EvaluationAnalysisService implements IEvaluationAnalysisService {

    private final ModelMapper modelMapper;
    private final EvaluationAnalysisDAO evaluationAnalysisDAO;
    private final ParameterService parameterService;
    private final TclassDAO tclassDAO;
    private final ITclassService tclassService;
    private final IEvaluationService evaluationService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ClassStudentDAO classStudentDAO;
    private DecimalFormat numberFormat = new DecimalFormat("#.00");
    private final ClassEvaluationGoalsDAO classEvaluationGoalsDAO;

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
        return modelMapper.map(evaluationAnalysisDAO.saveAndFlush(request), EvaluationAnalysisDTO.Info.class);
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
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findAllBytClassId(classId);

        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        Map<String, Object> learningResult = this.evaluationAnalysistLearningResult(classId, scoringMethod);
        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if (evaluationAnalyses != null && evaluationAnalyses.size() > 0) {
            evaluationAnalysis = evaluationAnalyses.get(0);
            if (learningResult.get("felGrade") != null)
                evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            else
                evaluationAnalysis.setLearningGrade(null);
            if (learningResult.get("felPass") != null)
                evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            else
                evaluationAnalysis.setLearningPass(null);

            Map<String, Object> effectivenessResult = null;

            if (learningResult.get("felGrade") != null)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        learningResult.get("felGrade").toString(), evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        null, evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());

            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            } else {
                evaluationAnalysis.setEffectivenessGrade(null);
                evaluationAnalysis.setEffectivenessPass(null);
            }
        } else {
            if (learningResult.containsKey("felGrade") && learningResult.get("felGrade") != null)
                evaluationAnalysis.setLearningGrade(learningResult.get("felGrade").toString());
            if (learningResult.containsKey("felPass") && learningResult.get("felPass") != null)
                evaluationAnalysis.setLearningPass(Boolean.parseBoolean(learningResult.get("felPass").toString()));
            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getById(classId));

            Map<String, Object> effectivenessResult = null;

            if (learningResult.get("felGrade") != null)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        learningResult.get("felGrade").toString(), evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        null, evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());

            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }

            create(evaluationAnalysis);
        }
    }

    @Transactional
    @Override
    public void updateReactionEvaluation(Long classId) {
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findAllBytClassId(classId);
        Map<String, Object> reactionResult = tclassService.getFERAndFETGradeResult(classId);

        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if (evaluationAnalyses != null && evaluationAnalyses.size() > 0) {
            evaluationAnalysis = evaluationAnalyses.get(0);

            if (reactionResult.containsKey("FERGrade") && reactionResult.get("FERGrade") != null)
                evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());
            else
                evaluationAnalysis.setReactionGrade(null);

            if (reactionResult.containsKey("FERPass") && reactionResult.get("FERPass") != null)
                evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));
            else
                evaluationAnalysis.setReactionPass(null);

            if (reactionResult.containsKey("FETGrade") && reactionResult.get("FETGrade") != null)
                evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());
            else
                evaluationAnalysis.setTeacherGrade(null);

            if (reactionResult.containsKey("FETPass") && reactionResult.get("FETPass") != null)
                evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));
            else
                evaluationAnalysis.setTeacherPass(null);

            Map<String, Object> effectivenessResult = null;

            if (reactionResult.containsKey("FERGrade") && reactionResult.get("FERGrade") != null)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(reactionResult.get("FERGrade").toString(),
                        evaluationAnalysis.getLearningGrade(), evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(null,
                        evaluationAnalysis.getLearningGrade(), evaluationAnalysis.getBehavioralGrade(), tclass.getEvaluation());

            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            } else {
                evaluationAnalysis.setEffectivenessGrade(null);
                evaluationAnalysis.setEffectivenessPass(null);
            }
        } else {
            if (reactionResult.containsKey("FERGrade") && reactionResult.get("FERGrade") != null)
                evaluationAnalysis.setReactionGrade(reactionResult.get("FERGrade").toString());

            if (reactionResult.containsKey("FERPass") && reactionResult.get("FERPass") != null)
                evaluationAnalysis.setReactionPass(Boolean.parseBoolean(reactionResult.get("FERPass").toString()));

            if (reactionResult.containsKey("FETGrade") && reactionResult.get("FETGrade") != null)
                evaluationAnalysis.setTeacherGrade(reactionResult.get("FETGrade").toString());

            if (reactionResult.containsKey("FETPass") && reactionResult.get("FETPass") != null)
                evaluationAnalysis.setTeacherPass(Boolean.parseBoolean(reactionResult.get("FETPass").toString()));

            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getById(classId));
            Map<String, Object> effectivenessResult = null;

            if (reactionResult.containsKey("FERGrade") && reactionResult.get("FERGrade") != null)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(reactionResult.get("FERGrade").toString(),
                        null, null, tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(null,
                        null, null, tclass.getEvaluation());
            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    @Transactional
    @Override
    public void updateBehavioral(Long classId) {
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findAllBytClassId(classId);
        EvaluationDTO.BehavioralResult behavioralResult = evaluationService.getBehavioralEvaluationResult(classId);
        final Optional<Tclass> sById = tclassDAO.findById(classId);
        final Tclass tclass = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        EvaluationAnalysis evaluationAnalysis = new EvaluationAnalysis();
        if (evaluationAnalyses != null && evaluationAnalyses.size() > 0) {
            evaluationAnalysis = evaluationAnalyses.get(0);
            if (behavioralResult.getBehavioralGrade() != 0) {
                evaluationAnalysis.setBehavioralGrade(behavioralResult.getBehavioralGrade().toString());
                evaluationAnalysis.setBehavioralPass(behavioralResult.getBehavioralPass());
            } else {
                evaluationAnalysis.setBehavioralGrade(null);
                evaluationAnalysis.setBehavioralPass(null);
            }

            Map<String, Object> effectivenessResult = null;
            if (behavioralResult.getBehavioralGrade() != 0)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        evaluationAnalysis.getLearningGrade(), behavioralResult.getBehavioralGrade().toString(), tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        evaluationAnalysis.getLearningGrade(), null, tclass.getEvaluation());

            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            } else {
                evaluationAnalysis.setEffectivenessGrade(null);
                evaluationAnalysis.setEffectivenessPass(null);
            }
        } else {
            if (behavioralResult.getBehavioralGrade() != 0) {
                evaluationAnalysis.setBehavioralGrade(behavioralResult.getBehavioralGrade().toString());
                evaluationAnalysis.setBehavioralPass(behavioralResult.getBehavioralPass());
            }

            evaluationAnalysis.setTClassId(classId);
            evaluationAnalysis.setTClass(tclassDAO.getById(classId));
            Map<String, Object> effectivenessResult = null;
            if (behavioralResult.getBehavioralGrade() != null && behavioralResult.getBehavioralGrade() != 0)
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        evaluationAnalysis.getLearningGrade(), behavioralResult.getBehavioralGrade().toString(), tclass.getEvaluation());
            else
                effectivenessResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalysis.getReactionGrade(),
                        evaluationAnalysis.getLearningGrade(), null, tclass.getEvaluation());

            if (effectivenessResult != null && effectivenessResult.containsKey("EffectivenessGrade") && effectivenessResult.containsKey("EffectivenessPass")) {
                evaluationAnalysis.setEffectivenessGrade(effectivenessResult.get("EffectivenessGrade").toString());
                evaluationAnalysis.setEffectivenessPass(Boolean.parseBoolean(effectivenessResult.get("EffectivenessPass").toString()));
            }
            create(evaluationAnalysis);
        }
    }

    @Transactional
    public Map<String, Object> evaluationAnalysistLearningResult(Long classId, String scoringMethod) {
        Float[] result = getStudents(classId, scoringMethod);
        Map<String, Object> finalResult = new HashMap<>();

        Double minScoreEL = 0.0;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEL");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreEL"))
                minScoreEL = Double.parseDouble(parameterValue.getValue());
        }

        Float felGrade = null;

        if (result != null && result.length > 2 && result[3] != null)
            felGrade = result[3];

        finalResult.put("felGrade", felGrade);
        if (felGrade != null && felGrade >= minScoreEL)
            finalResult.put("felPass", true);
        else if (felGrade != null && felGrade < minScoreEL)
            finalResult.put("felPass", false);
        else
            finalResult.put("felPass", null);

        return finalResult;
    }

    @Transactional
    @Override
    public void print(HttpServletResponse response, String type, String fileName, Long classId, String receiveParams, String suggestions, String opinion) throws Exception {
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        List<Map> studentsList = new ArrayList();
        for (ClassStudent student : tclass.getClassStudents()) {
            Map<String, String> std = new HashMap<>();
            std.put("studentFullName", student.getStudent().getFirstName() + " " + student.getStudent().getLastName());
            std.put("personnelCode", student.getStudent().getPersonnelNo());
            studentsList.add(std);
        }

        EvaluationDTO.BehavioralResult result = evaluationService.getBehavioralEvaluationResult(classId);
        List<Map> indicesList = new ArrayList();
        List<Map> behavioralChart = new ArrayList();
        int i = 1;

        List<ClassEvaluationGoals> editedGoalList = classEvaluationGoalsDAO.findByClassId(tclass.getId());
        if (editedGoalList != null && editedGoalList.size() != 0) {
            for (ClassEvaluationGoals classEvaluationGoals : editedGoalList) {
                if (classEvaluationGoals.getSkillId() != null) {
                    Map<String, String> indice = new HashMap<>();
                    indice.put("indicatorEx", classEvaluationGoals.getQuestion());
                    indice.put("indicatorNo", "شاخص " + i);
                    indicesList.add(indice);

                    Map<String, Object> behavior = new HashMap<>();
                    behavior.put("behaviorVal", result.getIndicesGrade().get("s" + classEvaluationGoals.getSkillId()));
                    behavior.put("behaviorCat", "شاخص " + i);
                    behavioralChart.add(behavior);

                    i++;
                }
                if (classEvaluationGoals.getGoalId() != null) {
                    Map<String, String> indice = new HashMap<>();
                    indice.put("indicatorEx", classEvaluationGoals.getQuestion());
                    indice.put("indicatorNo", "شاخص " + i);
                    indicesList.add(indice);

                    Map<String, Object> behavior = new HashMap<>();
                    behavior.put("behaviorVal", result.getIndicesGrade().get("g" + classEvaluationGoals.getGoalId()));
                    behavior.put("behaviorCat", "شاخص " + i);
                    behavioralChart.add(behavior);

                    i++;
                }
            }
        } else {
            for (Goal goal : tclass.getCourse().getGoalSet()) {
                Map<String, String> indice = new HashMap<>();
                indice.put("indicatorEx", goal.getTitleFa());
                indice.put("indicatorNo", "شاخص " + i);
                indicesList.add(indice);

                Map<String, Object> behavior = new HashMap<>();
                behavior.put("behaviorVal", result.getIndicesGrade().get("g" + goal.getId()));
                behavior.put("behaviorCat", "شاخص " + i);
                behavioralChart.add(behavior);

                i++;
            }
            for (Skill skill : tclass.getCourse().getSkillSet()) {
                Map<String, String> indice = new HashMap<>();
                indice.put("indicatorEx", skill.getTitleFa());
                indice.put("indicatorNo", "شاخص " + i);
                indicesList.add(indice);

                Map<String, Object> behavior = new HashMap<>();
                behavior.put("behaviorVal", result.getIndicesGrade().get("s" + skill.getId()));
                behavior.put("behaviorCat", "شاخص " + i);
                behavioralChart.add(behavior);

                i++;
            }

        }

        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        List<Map> behavioralScoreChart = new ArrayList();
        String[] classStudentsName = result.getClassStudentsName();
        Double[] behavioralGrades = result.getBehavioralGrades();
        for (int z = 0; z < result.getClassStudentsName().length; z++) {
            Map<String, Object> behavior = new HashMap<>();
            behavior.put("scoreVal", behavioralGrades[z]);
            behavior.put("scoreCat", PersianCharachtersUnicode.bidiReorder(classStudentsName[z]));
            behavioralScoreChart.add(behavior);
        }

        Map<String, Object> behavior = new HashMap<>();
        behavior.put("scoreVal", result.getBehavioralGrade());
        behavior.put("scoreCat", "میانگین تغییر رفتار دوره ");
        behavioralScoreChart.add(behavior);

        String data = "";
        data = "{" + "\"courseRegistered\": " + objectMapper.writeValueAsString(studentsList) + "," +
                "\"behavioralIndicators\": " + objectMapper.writeValueAsString(indicesList) + "," +
                "\"behavioralChart\": " + objectMapper.writeValueAsString(behavioralChart) + "," +
                "\"behavioralScoreChart\": " + objectMapper.writeValueAsString(behavioralScoreChart) + "}";
        params.put("today", DateUtil.todayDate());
        params.put("course", tclass.getCourse().getTitleFa());
        params.put("courseRegisteredCount", tclass.getClassStudents().size() + "");
        params.put("criticisim", suggestions);
        params.put("comment", opinion);
        params.put("course_code", tclass.getCourse().getCode());
        params.put("class_code", tclass.getCode());
        params.put("report_header", "گزارش تغییر رفتار دوره ");
        params.put("with_code", " با کد ");
        params.put("and_class_code", " و کد کلاس ");
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    public void printBehaviorChangeReport(HttpServletResponse response, String type, String fileName, Long classId, String receiveParams, String suggestions, String opinion) throws Exception {
        Tclass tclass = tclassDAO.findById(classId)
                .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        List<Map<String, Object>> studentsEvalResults = new ArrayList<>();
        Map<String, Object> results = new HashMap<>();

        results.put("supervisorGrade", params.get("supervisorGrade"));
        results.put("coWorkerGrade", params.get("coWorkerGrade"));
        results.put("servitorGrade", params.get("servitorGrade"));
        results.put("trainingGrade", params.get("trainingGrade"));
        results.put("studentGrade", params.get("studentGrade"));
        results.put("evaluatedFullName", params.get("evaluatedFullName"));
        results.put("evaluatedPersonnelNo", params.get("evaluatedPersonnelNo"));
        results.put("evaluatedNationalCode", params.get("evaluatedNationalCode"));

        double[] grades = {
                Double.parseDouble(!params.get("studentGrade").toString().equalsIgnoreCase("عدم تکميل فرم") ? params.get("studentGrade").toString() : String.valueOf(0)),
                Double.parseDouble(!params.get("supervisorGrade").toString().equalsIgnoreCase("عدم تکميل فرم") ? params.get("supervisorGrade").toString() : String.valueOf(0)),
                Double.parseDouble(!params.get("coWorkerGrade").toString().equalsIgnoreCase("عدم تکميل فرم") ? params.get("coWorkerGrade").toString() : String.valueOf(0)),
                Double.parseDouble(!params.get("servitorGrade").toString().equalsIgnoreCase("عدم تکميل فرم") ? params.get("servitorGrade").toString() : String.valueOf(0)),
                Double.parseDouble(!params.get("trainingGrade").toString().equalsIgnoreCase("عدم تکميل فرم") ? params.get("trainingGrade").toString() : String.valueOf(0))
        };
        double sum = 0;
        int count = 0;

        for (double value : grades) {
            sum += value;
            if (value != 0) {
                count++;
            }
        }
        double averageGrade = (sum) / (count);

        params.put("today", DateUtil.todayDate());
        params.put("course", tclass.getCourse().getTitleFa());
        params.put("criticisim", suggestions);
        params.put("comment", opinion);
        params.put("course_code", tclass.getCourse().getCode());
        params.put("class_code", tclass.getCode());
        params.put("report_header", "گزارش تغییر رفتار دوره ");
        params.put("with_code", " با کد ");
        params.put("and_class_code", " و کد کلاس ");
        params.put(ConstantVARs.REPORT_TYPE, type);
        results.put("no", 1);
        results.put("average_scores", String.valueOf(averageGrade));

        studentsEvalResults.add(results);

        String data = "{" + "\"studentsEvaluationResult\": " + objectMapper.writeValueAsString(studentsEvalResults) + "}";

        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    private static String bidiReorder(String text) {
        PersianCharachtersUnicode unicode = new PersianCharachtersUnicode();
        String textinverse = "";
        int k = 0;
        int i = 0;
        for (int j = text.length() - 1; j >= 0; j--) {
            unicode.setCharc(text.charAt(j));
            k = j + 1;
            i = j - 1;
            if (j == text.length() - 1 && PersianCharachtersUnicode.getNextInitial(text.charAt(i)))
                textinverse += unicode.getIsolatedForm_Unicode();
            else if (j == text.length() - 1)
                textinverse += unicode.getFinalForm_Unicode();
            else if (j == 0)
                textinverse += unicode.getInitialFom_Unicode();
            else if (PersianCharachtersUnicode.getPrevInitial(text.charAt(k)) && PersianCharachtersUnicode.getNextInitial(text.charAt(i)))
                textinverse += unicode.getIsolatedForm_Unicode();
            else if (PersianCharachtersUnicode.getPrevInitial(text.charAt(k)))
                textinverse += unicode.getFinalForm_Unicode();
            else if (PersianCharachtersUnicode.getNextInitial(text.charAt(i)))
                textinverse += unicode.getInitialFom_Unicode();
            else
                textinverse += unicode.getMedialForm_Unicode();
        }

        return textinverse;
    }

    @Transactional
    @Override
    public Float[] getStudents(Long id, String scoringMethod) {
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("0", 0);
        map.put("1001", 40);
        map.put("1002", 60);
        map.put("1003", 80);
        map.put("1004", 100);
        DecimalFormat df = new DecimalFormat("0.00");
        Float[] ans = new Float[4];
        Float sumScore = Float.valueOf(0);
        Float sumPreScore = Float.valueOf(0);
        Float ScoreEvaluation = Float.valueOf(0);
        Float sumValence = Float.valueOf(0);
        int preTestVariable = 0;
        int pastTestVariable = 0;
        int scoreEvaluationVariable = 0;
        List<ClassStudent> classStudents = classStudentDAO.findByTclassId(id);
        List<ClassStudentDTO.evaluationAnalysistLearning> list = new ArrayList<>();
        for (ClassStudent classStudent : classStudents) {
            list.add(modelMapper.map(classStudent, ClassStudentDTO.evaluationAnalysistLearning.class));
        }
        if (list.size() == 0) {
            ans[0] = null;
            ans[1] = null;
            ans[2] = null;
            ans[3] = null;
            return ans;
        }

        if (scoringMethod.equals("1")) { // ارزشی
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if (score.getValence() != null && score.getPreTestScore() != null) {
                    ScoreEvaluation = ScoreEvaluation + map.get(score.getValence()) - score.getPreTestScore();
                    scoreEvaluationVariable++;
                    sumValence += map.get(score.getValence());
                    sumPreScore += score.getPreTestScore();
                } else if (score.getValence() != null && score.getPreTestScore() == null) {
                    ScoreEvaluation = ScoreEvaluation + map.get(score.getValence());
                    scoreEvaluationVariable++;
                    sumValence += map.get(score.getValence());
                }

            }
            if (scoreEvaluationVariable != 0) {
                ans[0] = Float.valueOf(df.format(sumValence / scoreEvaluationVariable));
                ans[1] = Float.valueOf(df.format(sumPreScore / scoreEvaluationVariable));
                ans[2] = Float.valueOf(scoreEvaluationVariable);
                ans[3] = Float.valueOf(df.format(ScoreEvaluation / (scoreEvaluationVariable)));
            } else {
                ans[0] = null;
                ans[1] = null;
                ans[2] = null;
                ans[3] = null;
            }

            pastTestVariable = 0;
            preTestVariable = 0;
            return ans;
        }


        if (scoringMethod.equals("2")) { // نمره از 100
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if (score.getScore() != null && score.getPreTestScore() != null) {
                    ScoreEvaluation += Math.abs((score.getScore() - score.getPreTestScore()));
                    scoreEvaluationVariable++;
                    sumScore += score.getScore();
                    sumPreScore += score.getPreTestScore();
                } else if (score.getScore() != null && score.getPreTestScore() == null) {
                    ScoreEvaluation += Math.abs(score.getScore());
                    scoreEvaluationVariable++;
                    sumScore += score.getScore();
                }

            }

            ans[0] = Float.valueOf(df.format(sumScore / (list.size() - pastTestVariable)));
            ans[1] = Float.valueOf(df.format(sumPreScore / (list.size() - preTestVariable)));
            ans[2] = Float.valueOf(scoreEvaluationVariable);
            if (scoreEvaluationVariable != 0)
                ans[3] = Float.valueOf(df.format((sumScore / (list.size() - pastTestVariable)) - (sumPreScore / (list.size() - preTestVariable))));
            else
                ans[3] = null;
            pastTestVariable = 0;
            preTestVariable = 0;
            scoreEvaluationVariable = 0;
            return ans;
        }
        if (scoringMethod.equals("3"))  //نمره از 20
        {
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if (score.getScore() != null && score.getPreTestScore() != null) {
                    ScoreEvaluation = ScoreEvaluation + ((score.getScore() * 5) - score.getPreTestScore());
                    scoreEvaluationVariable++;
                    sumScore += (score.getScore() * 5);
                    sumPreScore += score.getPreTestScore();
                } else if (score.getScore() != null && score.getPreTestScore() == null) {
                    ScoreEvaluation = ScoreEvaluation + ((score.getScore() * 5));
                    scoreEvaluationVariable++;
                    sumScore += (score.getScore() * 5);
                }
            }
            if (scoreEvaluationVariable != 0) {
                ans[0] = Float.valueOf(df.format(sumScore / scoreEvaluationVariable));
                ans[1] = Float.valueOf(df.format((sumPreScore / scoreEvaluationVariable) * 5));
                ans[2] = Float.valueOf(scoreEvaluationVariable);
                ans[3] = Float.valueOf(df.format(Math.abs((sumScore / scoreEvaluationVariable) - ((sumPreScore / scoreEvaluationVariable) * 5))));
            } else {
                ans[0] = null;
                ans[1] = null;
                ans[2] = null;
                ans[3] = null;
            }
            return ans;
        }
        if (scoringMethod.equals("4")) // بدون نمره
        {
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if (score.getPreTestScore() != null) {
                    sumPreScore += score.getPreTestScore();
                    scoreEvaluationVariable++;
                } else if (score.getPreTestScore() == null) {
                    scoreEvaluationVariable++;
                }
            }

            ans[0] = null;
            if (scoreEvaluationVariable != 0)
                ans[1] = Float.valueOf(df.format(sumPreScore / scoreEvaluationVariable));
            else
                ans[1] = null;
            ans[2] = Float.valueOf(scoreEvaluationVariable);
            ans[3] = null;
            return ans;
        }

        return null;
    }

    @Transactional
    @Override
    public List<ClassStudentDTO.evaluationAnalysistLearning> getStudentWithOutPreTest(Long id) {
        List<ClassStudent> classStudents = classStudentDAO.findByTclassIdAndPreTestScoreIsNull(id);
        return (modelMapper.map(classStudents, new TypeToken<List<ClassStudentDTO.evaluationAnalysistLearning>>() {
        }.getType()));
    }

    @Override
    @Transactional
    public EvaluationDTO.EvaluationLearningResult evaluationAnalysistLearningResultTemp(Long classId, String scoringMethod) {
        Float[] result = getStudents(classId, scoringMethod);
        EvaluationDTO.EvaluationLearningResult resultSet = new EvaluationDTO.EvaluationLearningResult();

        Double minScoreEL = 0.0;
        Double minPasTestEL = 0.0;
        Double minPreTestEL = 0.0;
        Double FECRGrade = null;
        Boolean FECRPass = null;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEL");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreEL"))
                minScoreEL = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minPasTestEL"))
                minPasTestEL = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minPreTestEL"))
                minPreTestEL = Double.parseDouble(parameterValue.getValue());
        }


        Float postTestMeanGrade = null;
        Float preTestMeanGrade = null;
        Float felGrade = null;
        String felGradeS = null;

        if (result != null && result.length > 0)
            postTestMeanGrade = result[0];
        if (result != null && result.length > 1)
            preTestMeanGrade = result[1];
        if (result != null && result.length > 2)
            felGrade = result[3];

        if (felGrade != null)
            felGradeS = felGrade.toString();

        Tclass tclass = tclassService.getTClass(classId);
        Map<String, Object> FECRResult = null;
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findAllBytClassId(classId);
        if (evaluationAnalyses != null && evaluationAnalyses.size() != 0) {
            FECRResult = tclassService.calculateEffectivenessEvaluation(evaluationAnalyses.get(0).getReactionGrade(), felGradeS, evaluationAnalyses.get(0).getBehavioralGrade(), tclass.getEvaluation());
        } else {
            FECRResult = tclassService.calculateEffectivenessEvaluation(null, felGradeS, null, tclass.getEvaluation());
        }

        if (FECRResult.get("EffectivenessGrade") != null)
            FECRGrade = (Double) FECRResult.get("EffectivenessGrade");
        if (FECRResult.get("EffectivenessPass") != null)
            FECRPass = (Boolean) FECRResult.get("EffectivenessPass");


        if (felGrade != null)
            resultSet.setFelgrade(numberFormat.format(felGrade).toString());
        else
            resultSet.setFelgrade(null);

        if (felGrade != null && felGrade >= minScoreEL)
            resultSet.setFelpass("true");
        else
            resultSet.setFelpass("false");
        resultSet.setLimit(minScoreEL + "");

        if (postTestMeanGrade != null)
            resultSet.setPostTestMeanScore(numberFormat.format(postTestMeanGrade).toString());
        else
            resultSet.setPostTestMeanScore(null);
        if (preTestMeanGrade != null)
            resultSet.setPreTestMeanScore(numberFormat.format(preTestMeanGrade).toString());
        else
            resultSet.setPreTestMeanScore(null);

        if (FECRGrade != null)
            resultSet.setFeclgrade(FECRGrade.toString());

        if (FECRPass != null)
            resultSet.setFeclpass(FECRPass.toString());

        Integer classHasPreTest = tclassDAO.checkIfClassHasPreTest(classId);
        if (classHasPreTest != null && classHasPreTest.equals(new Integer(1))) {
            resultSet.setHavePreTest("true");
        } else
            resultSet.setHavePreTest("false");

        resultSet.setHavePostTest("false");

        if (result[2] != null)
            resultSet.setStudentCount(result[2]);
        else
            resultSet.setStudentCount(new Float(0));

        List<ClassStudent> classStudents = classStudentDAO.findByTclassId(classId);
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("0", 0);
        map.put("1001", 40);
        map.put("1002", 60);
        map.put("1003", 80);
        map.put("1004", 100);

        int studentCount = 0;
        float maxPastScore = 0;
        float learningRate = 0;
        float minPreScore = 0;
        List<Double> preScores = new ArrayList<>();
        List<Double> postScores = new ArrayList<>();
        int index = 0;
        for (ClassStudent classStudent : classStudents) {
            if (classStudent.getPreTestScore() != null && index == 0) {
                minPreScore = classStudent.getPreTestScore();
                index++;
            }

            if (classStudent.getScore() != null || classStudent.getValence() != null) {
                resultSet.setHavePostTest("true");
                if (classStudent.getScore() > maxPastScore) {
                    maxPastScore = classStudent.getScore();
                }
                if (classStudent.getPreTestScore() != null && classStudent.getPreTestScore() < minPreScore) {
                    minPreScore = classStudent.getPreTestScore();
                }

            }

            if (scoringMethod.equalsIgnoreCase("1") && classStudent.getValence() != null) {
                if (classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else
                    preScores.add(new Double(0));
                postScores.add(Double.valueOf(map.get(classStudent.getValence())));
                studentCount++;
            } else if (scoringMethod.equalsIgnoreCase("2") && classStudent.getScore() != null) {
                postScores.add(Double.valueOf(classStudent.getScore()) * 5);
                if (classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else
                    preScores.add(new Double(0));
                studentCount++;
            } else if (classStudent.getScore() != null) {
                postScores.add(Double.valueOf(classStudent.getScore()));
                if (classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else
                    preScores.add(new Double(0));
                studentCount++;
            }
        }

        Map<String, Boolean> tStudentResult = new HashMap<String, Boolean>();
        if (studentCount != 0)
            tStudentResult = calculateTStudentResult(preScores, postScores, studentCount);
        if (tStudentResult.containsKey("hasDiffer") && tStudentResult.get("hasDiffer")) {
            if (tStudentResult.get("positiveDiffer"))
                resultSet.setTstudent("بر اساس توزیع تی استیودنت  با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت چشمگیر مثبتی داشته اند.");
            else
                resultSet.setTstudent("بر اساس توزیع تی استیودنت با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت  چشمگیر منفی داشته اند.");
        } else
            resultSet.setTstudent("بر اساس توزیع تی استیودنت با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت چشمگیری نداشته اند.");

        if (scoringMethod.equalsIgnoreCase("3")) {
            minPreScore = minPreScore * 5;
            maxPastScore = maxPastScore * 5;
        }
        resultSet.setMinPreTest(minPreScore);
        resultSet.setMaxPastTest(maxPastScore);
        resultSet.setLearningRate(calculateLearningRate(resultSet.getPostTestMeanScore(), resultSet.getPreTestMeanScore(), minPreScore, maxPastScore));

        return resultSet;
    }

    private Float calculateLearningRate(String postTestMeanScore, String preTestMeanScore, float minPreScore, float maxPastScore) {
        DecimalFormat df = new DecimalFormat("0.00");
        float pastMean = postTestMeanScore != null && !postTestMeanScore.isEmpty() ? Float.parseFloat(postTestMeanScore) : 0F;
        float preMean = preTestMeanScore != null && !preTestMeanScore.isEmpty() ? Float.parseFloat(preTestMeanScore) : 0F;

        if (maxPastScore - minPreScore == 0)
            return 0F;
        else {
            return Float.valueOf(df.format(Math.abs(((pastMean - preMean) / (maxPastScore - minPreScore)) * 100)));
        }
    }

    //------------------------------------------------TStudent----------------------------------------------------------
    //Confidence Level = 95%
    public Map<String, Boolean> calculateTStudentResult(List<Double> preScores, List<Double> postScores, int studentCount) {
        HashMap<Integer, Double> tStudentTable = new HashMap<>();
        tStudentTable.put(1, 12.71);
        tStudentTable.put(2, 4.303);
        tStudentTable.put(3, 3.182);
        tStudentTable.put(4, 2.776);
        tStudentTable.put(5, 2.571);
        tStudentTable.put(6, 2.447);
        tStudentTable.put(7, 2.365);
        tStudentTable.put(8, 2.306);
        tStudentTable.put(9, 2.262);
        tStudentTable.put(10, 2.228);
        tStudentTable.put(11, 2.201);
        tStudentTable.put(12, 2.179);
        tStudentTable.put(13, 2.160);
        tStudentTable.put(14, 2.145);
        tStudentTable.put(15, 2.131);
        tStudentTable.put(16, 2.120);
        tStudentTable.put(17, 2.110);
        tStudentTable.put(18, 2.101);
        tStudentTable.put(19, 2.093);
        tStudentTable.put(20, 2.086);
        tStudentTable.put(21, 2.080);
        tStudentTable.put(22, 2.074);
        tStudentTable.put(23, 2.069);
        tStudentTable.put(24, 2.064);
        tStudentTable.put(25, 2.060);
        tStudentTable.put(26, 2.056);
        tStudentTable.put(27, 2.052);
        tStudentTable.put(28, 2.048);
        tStudentTable.put(29, 2.045);
        tStudentTable.put(30, 2.042);
        tStudentTable.put(40, 2.021);
        tStudentTable.put(60, 2.000);
        tStudentTable.put(80, 1.990);
        tStudentTable.put(100, 1.984);

        Double preScores_mean = getMean(preScores, studentCount);
        Double postScores_mean = getMean(postScores, studentCount);

        Double preScores_deviation = getDeviation(preScores, studentCount, preScores_mean);
        Double postScores_deviation = getDeviation(postScores, studentCount, postScores_mean);

        Double difference_sum = getDifference(preScores, postScores, studentCount);
        Double difference_average = difference_sum / studentCount;
        Double difference_deviation = getDifferenceDeviation(preScores, postScores, studentCount, difference_sum);
        Double t = difference_sum / difference_deviation;
        Double t_table = 0.0;
        if (studentCount <= 30)
            t_table = tStudentTable.get(studentCount);
        else if (studentCount > 30 && studentCount <= 40)
            t_table = tStudentTable.get(40);
        else if (studentCount > 40 && studentCount <= 60)
            t_table = tStudentTable.get(60);
        else if (studentCount > 60 && studentCount <= 80)
            t_table = tStudentTable.get(80);
        else if (studentCount > 80 && studentCount <= 100)
            t_table = tStudentTable.get(100);
        Boolean hasDiffer = false;
        if (Math.abs(t) < t_table)
            hasDiffer = false;
        else if (Math.abs(t) >= t_table)
            hasDiffer = true;
        Boolean positiveDiffer = false;
        if (t < 0)
            positiveDiffer = true;
        else if (t > 0)
            positiveDiffer = false;

        Map<String, Boolean> result = new HashMap<>();
        result.put("positiveDiffer", positiveDiffer);
        result.put("hasDiffer", hasDiffer);
        return result;
    }

    public Double getMean(List<Double> list, int n) {
        Double sum = 0.0;
        for (Double aDouble : list) {
            sum += aDouble;
        }
        return sum / n;
    }

    public Double getDeviation(List<Double> list, int n, Double average) {
        Double dv = 0.0;
        for (Double aDouble : list) {
            double dm = aDouble - average;
            dv += dm * dm;
        }
        return Math.sqrt(dv / n);
    }

    public Double getDifference(List<Double> list1, List<Double> list2, int n) {
        Double sum = 0.0;
        for (int i = 0; i < n; i++) {
            sum += list1.get(i) - list2.get(i);

        }
        return sum;
    }

    public Double getDifferenceDeviation(List<Double> list1, List<Double> list2, int n, Double differenceSum) {
        Double t1 = 0.0;
        for (int i = 0; i < n; i++) {
            Double dm = list1.get(i) - list2.get(i);
            t1 += dm * dm;
        }
        return Math.sqrt(((n * t1) - (differenceSum * differenceSum)) / (n - 1));
    }

    //------------------------------------------------------------------------------------------------------------------

}
