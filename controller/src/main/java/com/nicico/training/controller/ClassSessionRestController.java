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
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.ClassSessionService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sessionService")
public class ClassSessionRestController {


    private final ClassSessionService classSessionService;
    private final ClassAlarmService classAlarmService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final TclassDAO tclassDAO;
    private final TclassService tclassService;

    //*********************************

    @Loggable
    @PostMapping(value = "/generateSessions/{classId}")
    public void generateSessions(@PathVariable Long classId, @Validated @RequestBody TclassDTO.Create autoSessionsRequirement, HttpServletResponse response) {
        classSessionService.generateSessions(classId, autoSessionsRequirement, response);
        classAlarmService.alarmSumSessionsTimes(classId);
        classAlarmService.alarmTeacherConflict(classId);
        classAlarmService.alarmTrainingPlaceConflict(classId);
        classAlarmService.saveAlarms();
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<ClassSessionDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(classSessionService.get(id), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<ClassSessionDTO.Info>> list() {
        return new ResponseEntity<>(classSessionService.list(), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping
    public ResponseEntity<ClassSessionDTO.Info> create(@RequestBody ClassSessionDTO.ManualSession req, HttpServletResponse response) {
        ClassSessionDTO.ManualSession create = modelMapper.map(req, ClassSessionDTO.ManualSession.class);
        ResponseEntity<ClassSessionDTO.Info> infoResponseEntity = new ResponseEntity<>(classSessionService.create(create, response), HttpStatus.CREATED);
        //*****check alarms*****
        if (infoResponseEntity.getStatusCodeValue() == 201) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmTeacherConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmStudentConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmTrainingPlaceConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.saveAlarms();
        }

        return infoResponseEntity;
    }

    //*********************************

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<ClassSessionDTO.Info> update(@PathVariable Long id, @RequestBody ClassSessionDTO.Update request, HttpServletResponse response) {
        ClassSessionDTO.Update update = modelMapper.map(request, ClassSessionDTO.Update.class);
        ResponseEntity<ClassSessionDTO.Info> infoResponseEntity = new ResponseEntity<>(classSessionService.update(id, update, response), HttpStatus.OK);
        //*****check alarms*****
        if (infoResponseEntity.getStatusCodeValue() == 200) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmTeacherConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmStudentConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.alarmTrainingPlaceConflict(infoResponseEntity.getBody().getClassId());
            classAlarmService.saveAlarms();
        }
        return infoResponseEntity;
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id, HttpServletResponse response) {
        Long classId = classSessionService.getClassIdBySessionId(id);
        classSessionService.delete(id, response);
        //*****check alarms*****
        classAlarmService.alarmSumSessionsTimes(classId);
        classAlarmService.alarmTeacherConflict(classId);
        classAlarmService.alarmStudentConflict(classId);
        classAlarmService.alarmTrainingPlaceConflict(classId);
        classAlarmService.saveAlarms();
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Transactional
    @DeleteMapping(value = "/deleteSessions/cId{classId}/sIds{sessionIds}")
    public ResponseEntity<ClassSessionDTO.DeleteStatus> deleteSessions(@PathVariable Long classId,@PathVariable List<Long> sessionIds) {
        ClassSessionDTO.DeleteStatus deleteStatus = classSessionService.deleteSessions(classId, sessionIds);
        return new ResponseEntity<>(deleteStatus,HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody ClassSessionDTO.Delete request) {
        //////if use this method you must use calulate alarms to here/ with alarmSumSessionsTimes method
        ////// classAlarmService.alarmSumSessionsTimes(classId);
        ////// classAlarmService.alarmTeacherConflict(classId);
        ////// classAlarmService.alarmStudentConflict(classId);
        ////// classAlarmService.alarmTrainingPlaceConflict(classId);
        ////// classAlarmService.saveAlarms();
        classSessionService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ClassSessionDTO.ClassSessionsSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                    @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                    @RequestParam(value = "_constructor", required = false) String constructor,
                                                                    @RequestParam(value = "operator", required = false) String operator,
                                                                    @RequestParam(value = "criteria", required = false) String criteria,
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

        SearchDTO.SearchRs<ClassSessionDTO.Info> response = classSessionService.search(request);

        final ClassSessionDTO.SpecRs specResponse = new ClassSessionDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final ClassSessionDTO.ClassSessionsSpecRs specRs = new ClassSessionDTO.ClassSessionsSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}/{classId}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr,
                                  @PathVariable String classId) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        List<ClassSessionDTO.Info> infos = classSessionService.loadSessions(Long.parseLong(classId));


//////        final SearchDTO.SearchRs<ClassSessionDTO.Info> searchRs = classSessionService.search(searchRq);

        Tclass tclass = tclassDAO.findTclassByIdEquals(Long.parseLong(classId));
        String sessionTitle = tclass.getCode() + "لیست جلسات کلاس '" + tclass.getTitleClass() + "' با کد ";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("sessionTitle", sessionTitle);

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(infos) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/SessionsList.jasper", params, jsonDataSource, response);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/load-sessions/{classId}")
    public ResponseEntity<ClassSessionDTO.ClassSessionsSpecRs> getClassSessions(@PathVariable Long classId) {

        List<ClassSessionDTO.Info> list = classSessionService.loadSessions((classId));

        final ClassSessionDTO.SpecRs specResponse = new ClassSessionDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final ClassSessionDTO.ClassSessionsSpecRs specRs = new ClassSessionDTO.ClassSessionsSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

    @GetMapping(value = "/iscList/{classId}")
    public ResponseEntity<ISC<ClassSessionDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassSessionDTO.Info> searchRs = classSessionService.searchWithCriteria(searchRq, classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/specListWeeklyTrainingSchedule/{userNationalCode}")
    public ResponseEntity<ISC<ClassSessionDTO.WeeklySchedule>> getWeeklyTrainingSchedule(HttpServletRequest iscRq, @PathVariable String userNationalCode) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassSessionDTO.WeeklySchedule> searchRs = null;
            searchRs = classSessionService.searchWeeklyTrainingSchedule(searchRq, userNationalCode);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

//    @Transactional(readOnly = true)
    @GetMapping(value = "/sessions/{classId}")
    public ResponseEntity<List<ClassSessionDTO.AttendanceClearForm>> sessionsOfClass(@PathVariable Long classId) {
        List<ClassSessionDTO.AttendanceClearForm> sessions = classSessionService.loadSessionsForClearAttendance(classId);
//        Tclass tClass = tclassService.getTClass(classId);
//        Set<ClassSession> sessions = tClass.getClassSessions();
//        List<ClassSessionDTO.AttendanceClearForm> sessionClear = modelMapper.map(sessions, new TypeToken<List<ClassSessionDTO.AttendanceClearForm>>() {
//        }.getType());
        List<ClassSessionDTO.AttendanceClearForm> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSessionDTO.AttendanceClearForm::getSessionDate)
                .thenComparing(ClassSessionDTO.AttendanceClearForm::getSessionStartHour))
                .collect(Collectors.toList());
        return new ResponseEntity<>(sessionList , HttpStatus.OK);
    }

    @GetMapping(value = "/classHasAnySession/{classId}")
    public ResponseEntity<String> classHasAnySession(@PathVariable Long classId) {
        return new ResponseEntity<>(classSessionService.loadSessions(classId).stream().collect(Collectors.toList()).size() > 0 ? Boolean.TRUE.toString() : Boolean.FALSE.toString() , HttpStatus.OK);
    }
}
