package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.mapper.attendance.AttendanceBeanMapper;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.Student;
import com.nicico.training.service.*;
import dto.evaluuation.EvalTargetUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import request.attendance.AttendanceListSaveRequest;
import response.attendance.AttendanceListSaveResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/attendance")
public class AttendanceRestController {

    private final AttendanceService attendanceService;
    private final ClassSessionService classSessionService;
    private final TclassService tclassService;
    //    private final ClassStudent classStudent;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ClassAlarmService classAlarmService;
    private final AttendanceBeanMapper mapper;

    @Loggable
    @GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_attendance')")
    public ResponseEntity<AttendanceDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(attendanceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_attendance')")
    public ResponseEntity<List<AttendanceDTO.Info>> list() {
        return new ResponseEntity<>(attendanceService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<AttendanceDTO.Info> create(@RequestBody Object req) {
        AttendanceDTO.Create create = (new ModelMapper()).map(req, AttendanceDTO.Create.class);
        return new ResponseEntity<>(attendanceService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @GetMapping(value = "/auto-create")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<List<List<Map>>> autoCreate(@RequestParam("classId") Long classId, @RequestParam("date") String date) {
        List<List<Map>> maps = attendanceService.autoCreate(classId, date);
        return new ResponseEntity<>(maps, HttpStatus.CREATED);
    }

    @Loggable
    @GetMapping(value = "/student")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<List<List<Map>>> attendanceForStudent(@RequestParam("classId") Long classId, @RequestParam("studentId") Long studentId) {
        List<List<Map>> maps = attendanceService.getAttendanceByStudent(classId, studentId);
        return new ResponseEntity<>(maps, HttpStatus.CREATED);
    }

    @Loggable
    @GetMapping(value = "/accept-absent-student")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<Boolean> acceptAbsent(@RequestParam("classId") Long classId,
                                                @RequestParam("studentId") Long studentId,
                                                @RequestParam("sessionId") List<Long> sessionId) throws ParseException {

        return new ResponseEntity<>(attendanceService.studentAbsentSessionsInClass(classId, sessionId, studentId), HttpStatus.CREATED);//true
    }

    @Loggable
    @PostMapping(value = "/save-attendance")
    public ResponseEntity<AttendanceListSaveResponse> createAndSave(@RequestBody AttendanceListSaveRequest request) {
      //  attendanceService.convertToModelAndSave(req, classId, date);
 /*       classAlarmService.alarmAttendanceUnjustifiedAbsence(classId);
        classAlarmService.saveAlarms();*/
        List<Attendance> attendances =mapper.ToAttendanceList(request);
        attendanceService.saveOrUpdateList(attendances);
        AttendanceListSaveResponse response = new AttendanceListSaveResponse();
        response.setStatus(HttpStatus.CREATED.value());
        response.setMessage("با موفقیت ایجاد شد");
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @Loggable
    @PostMapping(value = "/student-attendance-save")
    public ResponseEntity studentAttendanceSave(@RequestBody List<List<Map<String, String>>> req) {
        attendanceService.studentAttendanceSave(req);
        return new ResponseEntity(HttpStatus.CREATED);
    }

    @Loggable
    @GetMapping(value = "/session-date")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<AttendanceDTO.AttendanceSpecRs> getDateForOneClass(@RequestParam(value = "classId", required = false) Long classId) {
        if (classId == null || classId == 0) {
            return new ResponseEntity<>(new AttendanceDTO.AttendanceSpecRs(), HttpStatus.OK);
        }
        List<ClassSessionDTO.ClassSessionsDateForOneClass> list = classSessionService.getDateForOneClass(classId);
        final AttendanceDTO.SpecRs specResponse = new AttendanceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final AttendanceDTO.AttendanceSpecRs specRs = new AttendanceDTO.AttendanceSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/students")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<AttendanceDTO.AttendanceSpecRs> getStudentForOneClass(@RequestParam(value = "classId", required = false) Long classId) {
        if (classId == null || classId == 0) {
            return new ResponseEntity<>(new AttendanceDTO.AttendanceSpecRs(), HttpStatus.OK);
        }
        List<ClassStudentDTO.AttendanceInfo> students = tclassService.getStudents(classId);
        final AttendanceDTO.SpecRs specResponse = new AttendanceDTO.SpecRs();
        specResponse.setData(students)
                .setStartRow(0)
                .setEndRow(students.size())
                .setTotalRows(students.size());

        final AttendanceDTO.AttendanceSpecRs specRs = new AttendanceDTO.AttendanceSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/session-in-date")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<List<ClassSessionDTO.Info>> getSessionsForDate(@RequestParam("classId") Long classId, @RequestParam("date") String date) {
        List<ClassSessionDTO.Info> list = classSessionService.getSessionsForDate(classId, date);
//        final AttendanceDTO.SpecRs specResponse = new AttendanceDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final AttendanceDTO.AttendanceSpecRs specRs = new AttendanceDTO.AttendanceSpecRs();
//        specRs.setResponse(specResponse);
        return new ResponseEntity<>(list, HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_attendance')")
    public ResponseEntity<AttendanceDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        AttendanceDTO.Update update = (new ModelMapper()).map(request, AttendanceDTO.Update.class);
        return new ResponseEntity<>(attendanceService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_attendance')")
    public ResponseEntity delete(@PathVariable Long id) {
        attendanceService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_attendance')")
    public ResponseEntity delete(@Validated @RequestBody AttendanceDTO.Delete request) {
        attendanceService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_attendance')")
    public ResponseEntity<AttendanceDTO.AttendanceSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                               @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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
        SearchDTO.SearchRs<AttendanceDTO.Info> response = attendanceService.search(request);
        final AttendanceDTO.SpecRs specResponse = new AttendanceDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final AttendanceDTO.AttendanceSpecRs specRs = new AttendanceDTO.AttendanceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_attendance')")
    public ResponseEntity<SearchDTO.SearchRs<AttendanceDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(attendanceService.search(request), HttpStatus.OK);
    }

    // -----------------

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Attendance.jasper", params, response);
    }

    @Loggable
    @GetMapping(value = "/studentUnknownSessionsInClass")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<String> studentUnknownSessionsInClass(@RequestParam("classId") Long classId) {
        return new ResponseEntity<>(attendanceService.studentUnknownSessionsInClass(classId), HttpStatus.OK);
    }
    @Loggable
    @GetMapping(value = "/studentAbsentSessionsInClass")
//	@PreAuthorize("hasAuthority('c_attendance')")
    public ResponseEntity<List<EvalTargetUser>> studentAbsentSessionsInClass(@RequestParam("classId") Long classId) {

        List<Student> students=    attendanceService.studentAbsentSessionsInClass(classId);
        if (students.isEmpty())
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        else
        {
          List<EvalTargetUser> targetUsers=mapper.toTargetUsers(students);
            return new ResponseEntity<>(targetUsers, HttpStatus.OK);
        }

    }
}
