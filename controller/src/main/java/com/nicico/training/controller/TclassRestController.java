package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.EvaluationAnalysistLearningService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/tclass")
public class TclassRestController {

    private final ITclassService tclassService;
    private final TclassService tClassService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ClassAlarmService classAlarmService;
    private final StudentDAO studentDAO;
    private final CourseDAO courseDAO;
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(tclassService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<List<TclassDTO.Info>> list() {
        return new ResponseEntity<>(tclassService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<TclassDTO.Info> create(@Validated @RequestBody TclassDTO.Create request) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tclassService.create(request), HttpStatus.CREATED);

        //*****check alarms*****
        if (infoResponseEntity.getStatusCodeValue() == 201) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getId());
        }
        return infoResponseEntity;
    }

    @Loggable
    @PostMapping("/safeCreate")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<TclassDTO.Info> safeCreate(@Validated @RequestBody TclassDTO.Create request,HttpServletResponse response) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tClassService.safeCreate(request,response), HttpStatus.CREATED);

        //*****check alarms*****
        if (infoResponseEntity.getStatusCodeValue() == 201) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getId());
        }
        return infoResponseEntity;
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<TclassDTO.Info> update(@PathVariable Long id, @RequestBody TclassDTO.Update request) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tclassService.update(id, request), HttpStatus.OK);

        //*****check alarms*****
        if (infoResponseEntity.getStatusCodeValue() == 200) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
        }

        return infoResponseEntity;
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            tclassService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@Validated @RequestBody TclassDTO.Delete request) {
        tclassService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);

        //*********************************
        //******old code for alarms********
////        for (TclassDTO.Info tclassDTO : response.getList()) {
////            if (classAlarmService.hasAlarm(tclassDTO.getId(), httpResponse).size() > 0)
////                tclassDTO.setHasWarning("alarm");
////           else
////              tclassDTO.setHasWarning("");
////        }
        //*********************************

        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/tuple-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> tupleList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                            @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                            @RequestParam(value = "_constructor", required = false) String constructor,
                                                            @RequestParam(value = "operator", required = false) String operator,
                                                            @RequestParam(value = "criteria", required = false) String criteria,
                                                            @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow).setCount(endRow - startRow);
        request.setDistinct(true);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);
        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list-evaluated")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassEvaluatedSpecRs> evaluatedList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> response = tclassService.evaluatedSearch(request);

        final TclassDTO.EvaluatedSpecRs specResponse = new TclassDTO.EvaluatedSpecRs();
        final TclassDTO.TclassEvaluatedSpecRs specRs = new TclassDTO.TclassEvaluatedSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SearchDTO.SearchRs<TclassDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(tclassService.search(request), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<TclassDTO.Info> searchRs = tclassService.search(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
    }
    //----------------------------------------------------

    @Loggable
    @GetMapping(value = "/end_group/{courseId}/{termId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Long> getEndGroup(@PathVariable Long courseId, @PathVariable Long termId) {
        return new ResponseEntity<>(tclassService.getEndGroup(courseId, termId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/checkStudentInClass/{nationalCode}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Long> checkStudentInClass(@PathVariable String nationalCode, @PathVariable Long classId) {

        if (((studentDAO.findOneByNationalCodeInClass(nationalCode, classId)) != null)) {
            return null;
        }
        List<Long> classList = (studentDAO.findOneByNationalCodeInClass(nationalCode, classId));
        return new ResponseEntity<Long>((MultiValueMap<String, String>) classList, HttpStatus.OK);

    }


    @Loggable
    @GetMapping(value = "/checkEndingClass/{classId}/{endDate}")
    public String checkEndingClass(@PathVariable Long classId, @PathVariable String endDate, HttpServletResponse response) throws IOException {
        return classAlarmService.checkAlarmsForEndingClass(classId, endDate, response);
    }

    @Loggable
    @GetMapping(value = "/hasClassStarted/{classId}")
    public boolean hasClassStarted(@PathVariable Long classId) throws IOException {
        return tClassService.compareTodayDate(classId);
    }

    @Loggable
    @GetMapping(value = "/getWorkflowEndingStatusCode/{classId}")
    public Integer getWorkflowEndingStatusCode(@PathVariable Long classId) {
        return tclassService.getWorkflowEndingStatusCode(classId);
    }

    @Loggable
    @GetMapping(value = "/reactionEvaluationResult/{classId}/{userId}")
    public ResponseEntity<TclassDTO.ReactionEvaluationResult> getReactionEvaluationResult(@PathVariable Long classId, @PathVariable Long userId) {
        return new ResponseEntity<TclassDTO.ReactionEvaluationResult>(tclassService.getReactionEvaluationResult(classId, userId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/behavioralEvaluationResult/{classId}")
    public ResponseEntity<TclassDTO.BehavioralEvaluationResult> getBehavioralEvaluationResult(@PathVariable Long classId) {
        return new ResponseEntity<TclassDTO.BehavioralEvaluationResult>(tclassService.getBehavioralEvaluationResult(classId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity<List<String>> getPreCourseTestQuestions(@PathVariable Long classId) {
        return new ResponseEntity<>(tclassService.getPreCourseTestQuestions(classId), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity updatePreCourseTestQuestions(@PathVariable Long classId, @RequestBody List<String> request) {
        try {
            tclassService.updatePreCourseTestQuestions(classId, request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/personnel-training/{national_code}")
    public ResponseEntity<TclassDTO.PersonnelClassInfo_TclassSpecRs> personnelTraining(@PathVariable String national_code) {

        List<TclassDTO.PersonnelClassInfo> list = tClassService.findAllPersonnelClass(national_code);

        final TclassDTO.PersonnelClassInfo_SpecRs specResponse = new TclassDTO.PersonnelClassInfo_SpecRs();
        final TclassDTO.PersonnelClassInfo_TclassSpecRs specRs = new TclassDTO.PersonnelClassInfo_TclassSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/listByteacherID/{teacherId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassTeachingHistorySpecRs> listByTeacherID(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                                 HttpServletResponse httpResponse,
                                                                                 @PathVariable Long teacherId) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }

        SearchDTO.SearchRs<TclassDTO.TeachingHistory> response = tclassService.searchByTeachingHistory(request, teacherId);

        final TclassDTO.TeachingHistorySpecRs specResponse = new TclassDTO.TeachingHistorySpecRs();
        final TclassDTO.TclassTeachingHistorySpecRs specRs = new TclassDTO.TclassTeachingHistorySpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    private SearchDTO.SearchRq setSearchCriteria(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                 @RequestParam(value = "operator", required = false) String operator,
                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                 @RequestParam(value = "id", required = false) Long id,
                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        return request;
    }


    @Loggable
    @GetMapping(value = "/list-training-report")
    public ResponseEntity<TclassDTO.TclassReportSpecRs> reportList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                   @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                                   @RequestParam(value = "id", required = false) Long id,
                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);


        List<Object> removedObjects = new ArrayList<>();
        Object courseStatus = null;
        Object reactionEvaluationOperator = null;
        Object reactionEvaluationGrade = null;
        Object behavioralEvaluationOperator = null;
        Object behavioralEvaluationGrade = null;
        Object learningEvaluationOperator = null;
        Object learningEvaluationGrade = null;
        Object evaluationOperator = null;
        Object evaluationGrade = null;

        for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
            if (criterion.getFieldName().equalsIgnoreCase("courseStatus")) {
                courseStatus = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("reactionEvaluationOperator")) {
                reactionEvaluationOperator = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("reactionEvaluationGrade")) {
                reactionEvaluationGrade = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("behavioralEvaluationOperator")) {
                behavioralEvaluationOperator = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("behavioralEvaluationGrade")) {
                behavioralEvaluationGrade = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("learningEvaluationOperator")) {
                learningEvaluationOperator = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("learningEvaluationGrade")) {
                learningEvaluationGrade = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("evaluationOperator")) {
                evaluationOperator = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if (criterion.getFieldName().equalsIgnoreCase("evaluationGrade")) {
                evaluationGrade = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
        }

        for (Object removedObject : removedObjects) {
            request.getCriteria().getCriteria().remove(removedObject);
        }

        SearchDTO.SearchRs<TclassDTO.TClassReport> response = tclassService.reportSearch(request);

        List<TclassDTO.TClassReport> listRemovedObjects = new ArrayList<>();
        if (courseStatus != null && !courseStatus.equals("3")) {
            for (TclassDTO.TClassReport datum : response.getList()) {
                List<Long> courseNeedAssessmentStatus = courseDAO.getCourseNeedAssessmentStatus(datum.getCourse().getId());
                if (courseStatus.equals("1") && courseNeedAssessmentStatus.size() == 0)
                    listRemovedObjects.add(datum);
                if (courseStatus.equals("2") && courseNeedAssessmentStatus.size() != 0)
                    listRemovedObjects.add(datum);
            }
        }
        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();

        if (reactionEvaluationOperator != null && reactionEvaluationGrade != null) {
            double grade = Double.parseDouble(reactionEvaluationGrade.toString());
            for (TclassDTO.TClassReport datum : response.getList()) {
                double classReactionGrade = tclassService.getClassReactionEvaluationGrade(datum.getId(), datum.getTeacherId());
                if (reactionEvaluationOperator.equals("1")) {
                    if (classReactionGrade >= grade)
                        listRemovedObjects.add(datum);
                }
                if (reactionEvaluationOperator.equals("2")) {
                    if (classReactionGrade <= grade)
                        listRemovedObjects.add(datum);
                }
            }
        }
        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();

        if (behavioralEvaluationOperator != null && behavioralEvaluationGrade != null) {
            double grade = Double.parseDouble(behavioralEvaluationGrade.toString());
            for (TclassDTO.TClassReport datum : response.getList()) {
                double classBehavioralGrade = tclassService.getBehavioralEvaluationResult(datum.getId()).getFEBGrade();
                if (behavioralEvaluationOperator.equals("1")) {
                    if (classBehavioralGrade >= grade)
                        listRemovedObjects.add(datum);
                }
                if (behavioralEvaluationOperator.equals("2")) {
                    if (classBehavioralGrade <= grade)
                        listRemovedObjects.add(datum);
                }
            }
        }
        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();

        if (learningEvaluationOperator != null && learningEvaluationGrade != null) {
            double grade = Double.parseDouble(learningEvaluationGrade.toString());
            for (TclassDTO.TClassReport datum : response.getList()) {
                double classLearningGrade = Math.abs(evaluationAnalysistLearningService.getStudents(datum.getId(), datum.getScoringMethod())[3]);
                if (learningEvaluationOperator.equals("1")) {
                    if (classLearningGrade >= grade)
                        listRemovedObjects.add(datum);
                }
                if (learningEvaluationOperator.equals("2")) {
                    if (classLearningGrade <= grade)
                        listRemovedObjects.add(datum);
                }
            }
        }
        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();

        if (evaluationOperator != null && evaluationGrade != null) {
            double grade = Double.parseDouble(evaluationGrade.toString());
            for (TclassDTO.TClassReport datum : response.getList()) {
                double classEvaluationGrade = tclassService.getBehavioralEvaluationResult(datum.getId()).getFECBGrade();
                if (evaluationOperator.equals("1")) {
                    if (classEvaluationGrade >= grade)
                        listRemovedObjects.add(datum);
                }
                if (evaluationOperator.equals("2")) {
                    if (classEvaluationGrade <= grade)
                        listRemovedObjects.add(datum);
                }
            }
        }
        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();


        final TclassDTO.ReportSpecRs specResponse = new TclassDTO.ReportSpecRs();
        final TclassDTO.TclassReportSpecRs specRs = new TclassDTO.TclassReportSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = {"/reportPrint/{type}"})
    public void reportPrint(HttpServletResponse response,
                            @PathVariable String type,
                            @RequestParam String CriteriaStr,
                            @RequestParam String courseInfo,
                            @RequestParam String classTimeInfo,
                            @RequestParam String executionInfo,
                            @RequestParam String evaluationInfo
    ) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (CriteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(CriteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        final SearchDTO.SearchRs<TclassDTO.TClassReport> searchRs = tclassService.reportSearch(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put("courseInfo", courseInfo);
        params.put("classTimeInfo", classTimeInfo);
        params.put("executionInfo", executionInfo);
        params.put("evaluationInfo", evaluationInfo);

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/TClassReportPrint.jasper", params, jsonDataSource, response);
    }

}
