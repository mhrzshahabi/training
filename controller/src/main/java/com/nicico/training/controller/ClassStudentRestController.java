package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.mapper.student.ClassStudentBeanMapper;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.student.UpdatePreTestScoreRequest;
import request.student.UpdateStudentScoreRequest;
import response.student.UpdatePreTestScoreResponse;
import response.student.UpdateStudentScoreResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.*;
import java.util.function.Function;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/class-student")
public class ClassStudentRestController {

    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final ClassStudentService classStudentService;
    private final ClassStudentDAO classStudentDAO;
    private final ModelMapper modelMapper;
    private final ParameterService parameterService;
    private final ClassAlarmService classAlarmService;
    private final ViewCoursesPassedPersonnelReportService iViewCoursesPassedPersonnelReportService;
    private final ViewPersonnelCourseNaReportService viewPersonnelCourseNaReportService;
    private final ContinuousStatusReportViewService continuousStatusReportViewService;
    private final ClassStudentBeanMapper mapper;
//    private final SearchDTO.SearchRq searchRq;
//    private final SearchDTO.CriteriaRq criteriaRq;
//    private final List<SearchDTO.CriteriaRq> list;


    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = classStudentService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    private <E, T> ResponseEntity<ISC<T>> search1(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, converter);
       int n= Integer.parseInt(parameterService.getByCode("FEL").getResponse().getData().get(3).getValue());
        searchRs.getList().forEach(x->{if (x.getPreTestScore() != null && x.getPreTestScore()>=n){x.setWarning("Ok");}else x.setWarning("NotOk");});
        return new ResponseEntity(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    private ResponseEntity<ISC<ClassStudentDTO.evaluationAnalysistLearning>> searchEvaluationAnalysistLearning(HttpServletRequest iscRq,Long classId, SearchDTO.CriteriaRq criteria) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchRs = classStudentService.searchEvaluationAnalysistLearning(searchRq,classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/students-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return search1(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));
    }

    @Loggable
    @GetMapping(value = "/attendance-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.AttendanceInfo>> attendanceList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return search(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.AttendanceInfo.class));
    }

    @Loggable
    @GetMapping(value = "/classes-of-student/{nationalCode}")
    public ResponseEntity<ISC<ClassStudentDTO.CoursesOfStudent>> classesOfStudentList(HttpServletRequest iscRq, @PathVariable String nationalCode) throws IOException {
        return search(iscRq, makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class));
    }

    @Loggable
    @GetMapping(value = "/class-list-of-student/{nationalCode}")
    public ResponseEntity<ISC<TclassDTO.StudentClassList>> classesOfStudentJustClassList(HttpServletRequest iscRq, @PathVariable String nationalCode) throws IOException {
        return search(iscRq, makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null), c -> (modelMapper.map(c, ClassStudentDTO.StudentClassList.class)).getTclass());
    }

    @Loggable
    @GetMapping(value = "/scores-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.ScoresInfo>> scoresList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return search(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.ScoresInfo.class));
    }

    @Loggable
    @GetMapping(value = "/pre-test-score-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.PreTestScoreInfo>> pre_test_scoreList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return search(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.PreTestScoreInfo.class));
    }

    @Loggable
    @GetMapping(value = "/evaluationAnalysistLearning/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.evaluationAnalysistLearning>> evaluationAnalysistLearning(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return searchEvaluationAnalysistLearning(iscRq,classId, makeNewCriteria("tclassId", classId, EOperator.equals, null));
    }


    @Loggable
    @PostMapping(value = "/register-students/{classId}")
    public ResponseEntity registerStudents(@RequestBody List<ClassStudentDTO.Create> request, @PathVariable Long classId) {
        try {
            Map<String, String> result;
            result = classStudentService.registerStudents(request, classId);
            //// cancel alarms
//            classAlarmService.alarmClassCapacity(classId);
//            classAlarmService.alarmStudentConflict(classId);
//            classAlarmService.saveAlarms();
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }
    @Loggable
    @PostMapping(value = "/check-register-students/{courseId}")
    public ResponseEntity checkRegisterStudents(@RequestBody List<ClassStudentDTO.RegisterInClass> request, @PathVariable Long courseId) {
//        List<Long> ids = request.stream().map(s -> s.getId()).collect(Collectors.toList());

        for (ClassStudentDTO.RegisterInClass s : request) {
            List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("courseId", courseId, EOperator.equals, null));
            list.add(makeNewCriteria("nationalCode", s.getNationalCode(), EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            criteriaRq.setCriteria(list);
            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            SearchDTO.SearchRs<ViewCoursesPassedPersonnelReportDTO.Grid> search = iViewCoursesPassedPersonnelReportService.search(searchRq.setCriteria(criteriaRq));
            SearchDTO.SearchRs<ContinuousStatusReportViewDTO.Grid> search2 = continuousStatusReportViewService.search(searchRq.setCriteria(criteriaRq));
            SearchDTO.SearchRs<ViewPersonnelCourseNaReportDTO.Grid> search1 = viewPersonnelCourseNaReportService.search(searchRq.setCriteria(criteriaRq));

            s.setIsNeedsAssessment(!search1.getList().isEmpty());
            s.setIsPassed(!search.getList().isEmpty());
            s.setIsRunning(!search2.getList().isEmpty());
        }
        return new ResponseEntity<>(request, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<UpdateStudentScoreResponse> update(@PathVariable Long id, @RequestBody UpdateStudentScoreRequest request) {
        UpdateStudentScoreResponse response = new UpdateStudentScoreResponse();
        try {
            classStudentService.saveOrUpdate(mapper.updateScoreClassStudent(request, classStudentService.getClassStudent(id)));
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("ویرایش موفقیت آمیز");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }
    @Loggable
    @PutMapping(value = "/update-presence-type-id/{id}/{presenceTypeId}")
    public ResponseEntity<UpdateStudentScoreResponse> update(@PathVariable Long id, @PathVariable Long presenceTypeId ) {
        UpdateStudentScoreResponse response = new UpdateStudentScoreResponse();
        try {
            classStudentService.setPeresenceTypeId(presenceTypeId,id);
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("ویرایش موفقیت آمیز");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/score-pre-test/{id}")
    public ResponseEntity<UpdatePreTestScoreResponse> updateScorePreTest(@PathVariable Long id, @RequestBody UpdatePreTestScoreRequest request) {
        UpdatePreTestScoreResponse response = new UpdatePreTestScoreResponse();
        try {
            classStudentService.saveOrUpdate(mapper.updatePreTestScoreClassStudent(request, classStudentService.getClassStudent(id)));
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("ویرایش موفقیت آمیز");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }


//    @Loggable
//    @PutMapping(value = "/score-pre-test/{id}")
//    public ResponseEntity updateScorePreTest(@PathVariable Long id, @RequestBody Object request) {
//        try {
//            return new ResponseEntity<>(classStudentService.update(id, request, ClassStudentDTO.PreTestScoreInfo.class), HttpStatus.OK);
//        } catch (TrainingException ex) {
//            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
//        }
//    }


    @Loggable
    @DeleteMapping
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity removeStudents(@RequestBody ClassStudentDTO.Delete request) {
        try {
            classStudentService.delete(request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{studentIds}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Set<Long> studentIds) {
        try {
            Long classId = null;
            for (Long studentId : studentIds) {
                classId = classStudentService.getClassIdByClassStudentId(studentId);
                classStudentService.delete(studentId);
            }

//// cancel alarms
//            if (classId != null) {
//                classAlarmService.alarmClassCapacity(classId);
//                classAlarmService.alarmStudentConflict(classId);
//                classAlarmService.saveAlarms();
//            }

            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }


//    @Loggable
//    @PutMapping(value = "/setStudentFormIssuance/{idClassStudent}/{reaction}")
//    public Integer setStudentFormIssuance(@PathVariable Long idClassStudent, @PathVariable Integer reaction) {
//        return classStudentService.setStudentFormIssuance(idClassStudent, reaction);
//    }


    @Loggable
    @PutMapping(value = "/setStudentFormIssuance")
    public Integer setStudentFormIssuance(@RequestBody Map<String, String> formIssuance) {
        return classStudentService.setStudentFormIssuance(formIssuance);
    }


    @Loggable
    @GetMapping(value = "/checkEvaluationStudentInClass/{studentId}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Long> checkEvaluationStudentInClass(@PathVariable Long studentId, @PathVariable Long classId) {

        if (((classStudentDAO.findEvaluationStudentInClass(studentId, classId)) == null)) {
            return null;
        }
        List<Long> evalList = (classStudentDAO.findEvaluationStudentInClass(studentId, classId));
        return new ResponseEntity<>(evalList.get(0), HttpStatus.OK);

    }

    @Loggable
    @PutMapping(value = "/setTotalStudentWithOutScore/{classId}")
    public ResponseEntity setTotalStudentWithOutScore(@PathVariable Long classId) {
        classStudentService.setTotalStudentWithOutScore(classId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getScoreState/{classId}")
    public ResponseEntity<List<Long>> getScoreState(@PathVariable Long classId) {
        if (classStudentService.getScoreState(classId).size() == 0)
            return new ResponseEntity<>(classStudentService.getScoreState(classId), HttpStatus.OK);
        else
            return new ResponseEntity<>(classStudentService.getScoreState(classId), HttpStatus.NOT_ACCEPTABLE);

    }

    @Loggable
    @PostMapping(value = {"/print/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "formData") String formData,
                                  @RequestParam(value = "params") String receiveParams,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);

        String nationalCode = gson.fromJson(formData, String.class);
        final SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null));

        if (!criteriaStr.equalsIgnoreCase("{}")) {
            criteriaRq.getCriteria().add(objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class));
        }

        final SearchDTO.SearchRs<ClassStudentDTO.CoursesOfStudent> searchRs = classStudentService.search(new SearchDTO.SearchRq().setCriteria(criteriaRq), c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class));

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        reportUtil.export("/reports/trainingFile.jasper", params, jsonDataSource, response);
    }

}