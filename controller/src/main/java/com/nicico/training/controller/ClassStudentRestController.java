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
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.student.ClassStudentBeanMapper;
import com.nicico.training.mapper.tclass.TclassStudentMapper;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.ClassStudentHistory;
import com.nicico.training.model.ContactInfo;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.ParameterValueDAO;
import com.nicico.training.utility.persianDate.CalendarTool;
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
import response.BaseResponse;
import response.exam.ExtendedUserDto;
import response.exam.ResendExamTimes;
import response.student.UpdatePreTestScoreResponse;
import response.student.UpdateStudentScoreResponse;
import response.tclass.dto.SessionConflictDto;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.utility.persianDate.PersianDate.convertFtomTimeZone;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/class-student")
public class ClassStudentRestController {

    private final ObjectMapper objectMapper;
    private final IClassStudentHistoryService iClassStudentHistoryService;
    private final TclassStudentMapper tclassStudentMapper;
    private final ReportUtil reportUtil;
    private final IClassStudentService iClassStudentService;
    private final ModelMapper modelMapper;
    private final IParameterService parameterService;
    private final ParameterValueDAO parameterValueDAO;
    private final IViewCoursesPassedPersonnelReportService iViewCoursesPassedPersonnelReportService;
    private final IViewPersonnelCourseNaReportService viewPersonnelCourseNaReportService;
    private final IContinuousStatusReportViewService continuousStatusReportViewService;
    private final IClassSessionService iClassSessionService;
    private final ClassStudentBeanMapper mapper;
    private final ElsClient client;
    private final IContactInfoService contactInfoService;

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
        SearchDTO.SearchRs<T> searchRs = iClassStudentService.search(searchRq, converter);
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
        SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = iClassStudentService.search(searchRq, converter);
        int n = Integer.parseInt(parameterService.getByCode("FEL").getResponse().getData().get(3).getValue());
        searchRs.getList().forEach(x -> {
            if (x.getPreTestScore() != null && x.getPreTestScore() >= n) {
                x.setWarning("Ok");
            } else x.setWarning("NotOk");
        });
        return new ResponseEntity(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    private ResponseEntity<ISC<ClassStudentDTO.evaluationAnalysistLearning>> searchEvaluationAnalysistLearning(HttpServletRequest iscRq, Long classId, SearchDTO.CriteriaRq criteria) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchRs = iClassStudentService.searchEvaluationAnalysistLearning(searchRq, classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/students-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException, ParseException {
        ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> list = search1(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

        List<ClassStudentDTO.ClassStudentInfo> tmplist = (List<ClassStudentDTO.ClassStudentInfo>) list.getBody().getResponse().getData();
        List<Long> studentIds = tmplist.stream().map(ClassStudentDTO.ClassStudentInfo::getStudentId).collect(Collectors.toList());
        Map<Long, ContactInfo> contactInfoMap = contactInfoService.fetchAndUpdateLastHrMobile(studentIds, "Student", iscRq.getHeader("Authorization"));
        for (ClassStudentDTO.ClassStudentInfo studentInfo : tmplist) {
            studentInfo.getStudent().setContactInfo(modelMapper.map(contactInfoMap.get(studentInfo.getStudentId()), ContactInfoDTO.Info.class));
            studentInfo.setClassAttendanceStatus(iClassStudentService.IsStudentAttendanceAllowable(studentInfo.getId()));
        }

        if (tmplist.size() > 0 && (tmplist.get(0).getTclass().getClassStatus().equals("1") || tmplist.get(0).getTclass().getClassStatus().equals("2"))) {

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1);
            searchRq.setStartIndex(0);

            List<String> sortBy = new ArrayList<>();
            sortBy.add("sessionDate");
            sortBy.add("sessionStartHour");

            searchRq.setSortBy(sortBy);
            SearchDTO.SearchRs<ClassSessionDTO.Info> result = iClassSessionService.searchWithCriteria(searchRq, classId);

            if (result.getList().size() > 0) {
                String str = DateUtil.convertKhToMi1(result.getList().get(0).getSessionDate());
                LocalDate date = LocalDate.parse(str);

                if ((date.isBefore(LocalDate.now().plusDays(7)) || date.equals(LocalDate.now().plusDays(7))) && (date.isAfter(LocalDate.now()) || date.equals(LocalDate.now()))) {
                    Map<String, Integer> mobiles = iClassStudentService.getStatusSendMessageStudents(classId);

                    tmplist.forEach(p -> {
                        if (p.getStudent().getContactInfo().getSmSMobileNumber() != null && mobiles.get(p.getStudent().getContactInfo().getSmSMobileNumber()) != null && mobiles.get(p.getStudent().getContactInfo().getSmSMobileNumber()) > 0) {
                            p.setIsSentMessage("");
                        } else {
                            p.setIsSentMessage("warning");
                        }
                    });
                }
            }
        }

        return list;
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
        return search(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> {
            ClassStudentDTO.ScoresInfo scoresInfo = modelMapper.map(c, ClassStudentDTO.ScoresInfo.class);
            Long classStudentId = scoresInfo.getId();
            Boolean isScoreEditable = iClassStudentService.isScoreEditable(classStudentId);
            scoresInfo.setIsScoreEditable(isScoreEditable);
            return scoresInfo;
        });
    }

    @Loggable
    @GetMapping(value = "/pre-test-score-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.PreTestScoreInfo>> pre_test_scoreList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return search(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.PreTestScoreInfo.class));
    }

    @Loggable
    @GetMapping(value = "/evaluationAnalysistLearning/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.evaluationAnalysistLearning>> evaluationAnalysistLearning(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        return searchEvaluationAnalysistLearning(iscRq, classId, makeNewCriteria("tclassId", classId, EOperator.equals, null));
    }


    @Loggable
    @PostMapping(value = "/register-students/{classId}")
    public ResponseEntity registerStudents(@RequestBody List<ClassStudentDTO.Create> request, @PathVariable Long classId) {
        try {
            Map<String, String> result;
            result = iClassStudentService.registerStudents(request, classId);
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
            iClassStudentService.saveOrUpdate(mapper.updateScoreClassStudent(request, iClassStudentService.getClassStudent(id)));
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
    public ResponseEntity<UpdateStudentScoreResponse> update(@PathVariable Long id, @PathVariable Long presenceTypeId) {
        UpdateStudentScoreResponse response = new UpdateStudentScoreResponse();
        try {
            iClassStudentService.setPeresenceTypeId(presenceTypeId, id);
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
            iClassStudentService.saveOrUpdate(mapper.updatePreTestScoreClassStudent(request, iClassStudentService.getClassStudent(id)));
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
//            return new ResponseEntity<>(iClassStudentService.update(id, request, ClassStudentDTO.PreTestScoreInfo.class), HttpStatus.OK);
//        } catch (TrainingException ex) {
//            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
//        }
//    }


    @Loggable
    @DeleteMapping
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity removeStudents(@RequestBody ClassStudentDTO.Delete request) {
        try {
            iClassStudentService.delete(request);
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
            //Long classId = null;
            boolean haveError = false;
            StringBuilder message = new StringBuilder();
            for (Long studentId : studentIds) {
                String error = iClassStudentService.delete(studentId);

                if (!error.equals("")) {
                    haveError = true;
                    message.append(error).append("<br />");
                }
            }

//// cancel alarms
//            if (classId != null) {
//                classAlarmService.alarmClassCapacity(classId);
//                classAlarmService.alarmStudentConflict(classId);
//                classAlarmService.saveAlarms();
//            }
            if (haveError) {
                return new ResponseEntity<>(message.toString(), HttpStatus.NOT_ACCEPTABLE);
            } else {
                return new ResponseEntity<>(HttpStatus.OK);
            }

        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }


//    @Loggable
//    @PutMapping(value = "/setStudentFormIssuance/{idClassStudent}/{reaction}")
//    public Integer setStudentFormIssuance(@PathVariable Long idClassStudent, @PathVariable Integer reaction) {
//        return iClassStudentService.setStudentFormIssuance(idClassStudent, reaction);
//    }


    @Loggable
    @PutMapping(value = "/setStudentFormIssuance")
    public Integer setStudentFormIssuance(@RequestBody Map<String, String> formIssuance) {
        return iClassStudentService.setStudentFormIssuance(formIssuance);
    }


    @Loggable
    @GetMapping(value = "/checkEvaluationStudentInClass/{studentId}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Long> checkEvaluationStudentInClass(@PathVariable Long studentId, @PathVariable Long classId) {
        List<Long> evalList = iClassStudentService.findEvaluationStudentInClass(studentId, classId);

        if (evalList == null || evalList.size() == 0) {
            return null;
        }
        return new ResponseEntity<>(evalList.get(0), HttpStatus.OK);

    }

    @Loggable
    @PutMapping(value = "/setTotalStudentWithOutScore/{classId}")
    public ResponseEntity setTotalStudentWithOutScore(@PathVariable Long classId) {
        iClassStudentService.setTotalStudentWithOutScore(classId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getScoreState/{classId}")
    public ResponseEntity<List<Long>> getScoreState(@PathVariable Long classId) {
        if (iClassStudentService.getScoreState(classId).size() == 0)
            return new ResponseEntity<>(iClassStudentService.getScoreState(classId), HttpStatus.OK);
        else
            return new ResponseEntity<>(iClassStudentService.getScoreState(classId), HttpStatus.NOT_ACCEPTABLE);

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

        final SearchDTO.SearchRs<ClassStudentDTO.CoursesOfStudent> searchRs = iClassStudentService.search(new SearchDTO.SearchRq().setCriteria(criteriaRq), c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class));

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        reportUtil.export("/reports/trainingFile.jasper", params, jsonDataSource, response);
    }


    @Loggable
    @GetMapping(value = "/students-iscList/resend/{classId}/{sourceExamId}")
    public ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> resendExamStudents(HttpServletRequest iscRq, @PathVariable Long classId, @PathVariable Long sourceExamId) throws IOException, ParseException {
        ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> list = search1(iscRq, makeNewCriteria("tclassId", classId, EOperator.equals, null), c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

        List<ClassStudentDTO.ClassStudentInfo> tmplist = (List<ClassStudentDTO.ClassStudentInfo>) list.getBody().getResponse().getData();

        if (tmplist.size() > 0 && (tmplist.get(0).getTclass().getClassStatus().equals("1") || tmplist.get(0).getTclass().getClassStatus().equals("2"))) {

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1);
            searchRq.setStartIndex(0);

            List<String> sortBy = new ArrayList<>();
            sortBy.add("sessionDate");
            sortBy.add("sessionStartHour");

            searchRq.setSortBy(sortBy);
            SearchDTO.SearchRs<ClassSessionDTO.Info> result = iClassSessionService.searchWithCriteria(searchRq, classId);

            if (result.getList().size() > 0) {
                String str = DateUtil.convertKhToMi1(result.getList().get(0).getSessionDate());
                LocalDate date = LocalDate.parse(str);

                if ((date.isBefore(LocalDate.now().plusDays(7)) || date.equals(LocalDate.now().plusDays(7))) && (date.isAfter(LocalDate.now()) || date.equals(LocalDate.now()))) {
                    Map<String, Integer> mobiles = iClassStudentService.getStatusSendMessageStudents(classId);

                    tmplist.forEach(p -> {
                        if (p.getStudent().getContactInfo().getSmSMobileNumber() != null && mobiles.get(p.getStudent().getContactInfo().getSmSMobileNumber()) != null && mobiles.get(p.getStudent().getContactInfo().getSmSMobileNumber()) > 0) {
                            p.setIsSentMessage("");
                        } else {
                            p.setIsSentMessage("warning");
                        }
                    });
                }
            }
        }
        try {
            if (list.getBody() != null && list.getBody().getResponse() != null && list.getBody().getResponse().getData() != null && list.getBody().getResponse().getData().size() > 0) {
                ResendExamTimes resendExamTimes = client.getResendExamTimes(sourceExamId);

                if (resendExamTimes.getStatus() == HttpStatus.OK.value()) {
                    if (resendExamTimes.getExtendedUsers() != null && resendExamTimes.getExtendedUsers().size() > 0) {
                        List<ClassStudentDTO.ClassStudentInfo> classStudentInfos = (List<ClassStudentDTO.ClassStudentInfo>) list.getBody().getResponse().getData();
                        List<ExtendedUserDto> dataList = resendExamTimes.getExtendedUsers().stream().filter(data -> data.getStartDate() != null).collect(Collectors.toList());
                        for (ExtendedUserDto data : dataList) {
                            ClassStudentDTO.ClassStudentInfo classStudentInfo = classStudentInfos.stream().filter(a -> a.getStudent().getNationalCode() != null && a.getStudent().getNationalCode().equals(data.getUser().getNationalCode())).findFirst().get();
                            LocalDate date =
                                    Instant.ofEpochMilli(data.getStartDate()).atZone(ZoneId.systemDefault()).toLocalDate();
                            CalendarTool calendarTool = new CalendarTool(date.getYear(), date.getMonthValue(), date.getDayOfMonth());
                            Calendar cal = Calendar.getInstance();
                            cal.setTimeInMillis(data.getStartDate());
                            cal.setTimeZone(TimeZone.getTimeZone(ZoneId.systemDefault()));
                            ParameterValue zone = parameterValueDAO.findByCode("gmtTime");
                            String newTime = convertFtomTimeZone(cal.get(Calendar.HOUR_OF_DAY) + ":" + cal.get(Calendar.MINUTE), Integer.parseInt(zone.getValue()));
                            classStudentInfo.setExtendTime(" ( " + newTime + " ) " + " --- " + calendarTool.getIranianDate());
                        }

                    }

                }

            }
            return list;
        } catch (Exception e) {
            return list;
        }

    }

    @Loggable
    @GetMapping(value = "/history/{classId}")
    public ResponseEntity<ClassStudentHistoryDTO.InfoForAudit.TclassAuditSpecRs> history(@PathVariable Long classId) throws IOException, ParseException {

        List<ClassStudentHistory> list = iClassStudentHistoryService.getAllHistoryWithClassId(classId);
        List<ClassStudentHistoryDTO.InfoForAudit> dto = tclassStudentMapper.toTclassesResponse(list);
        final ClassStudentHistoryDTO.SpecAuditRs specResponse = new ClassStudentHistoryDTO.SpecAuditRs();
        final ClassStudentHistoryDTO.TclassAuditSpecRs specRs = new ClassStudentHistoryDTO.TclassAuditSpecRs();
        specResponse.setData(dto)
                .setStartRow(0)
                .setEndRow(dto.size())
                .setTotalRows(dto.size());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/add/history/{classId}")
    public ResponseEntity<ClassStudentHistoryDTO.InfoForAudit.TclassAuditSpecRs> historyAdd(@PathVariable Long classId) throws IOException, ParseException {

        List<ClassStudent> list = iClassStudentService.getClassStudents(classId);
        List<ClassStudentHistoryDTO.InfoForAudit> dto = tclassStudentMapper.toTclassesStudentResponse(list);
        final ClassStudentHistoryDTO.SpecAuditRs specResponse = new ClassStudentHistoryDTO.SpecAuditRs();
        final ClassStudentHistoryDTO.TclassAuditSpecRs specRs = new ClassStudentHistoryDTO.TclassAuditSpecRs();
        specResponse.setData(dto)
                .setStartRow(0)
                .setEndRow(dto.size())
                .setTotalRows(dto.size());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/getSessionConflict")
    public ResponseEntity<List<SessionConflictDto>> getSessionConflictViaClassStudent(@RequestParam(value = "nationalCode") String nationalCode, @RequestBody List<ClassSessionDTO.ClassStudentSession> classStudentSessions) {
        List<ClassSessionDTO.ClassStudentSession> classStudentSessionsMap = new ArrayList<>();
        classStudentSessions.forEach(classStudentSession -> {
            classStudentSessionsMap.add(modelMapper.map(classStudentSession, ClassSessionDTO.ClassStudentSession.class));
        });
        List<SessionConflictDto> sessionConflicts = iClassStudentService.getSessionConflictViaClassStudent(nationalCode, classStudentSessionsMap);

        return new ResponseEntity<>(sessionConflicts, HttpStatus.OK);

    }

    @Loggable
    @PutMapping(value = "/sync-personnel-data/{id}")
    public ResponseEntity<BaseResponse> syncPersonnelData(@PathVariable Long id) {
        BaseResponse response = new BaseResponse();
        try {
            response = iClassStudentService.syncPersonnelData(id);

            return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
        }
    }

}