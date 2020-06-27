package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/controlForm")
public class ControlFormController {

    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final TclassService tclassService;
    private final ModelMapper modelMapper;
    private final StudentDAO studentDAO;

    @Transactional(readOnly = true)
    @PostMapping(value = {"/score-print/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "classId") Long classId,
                                  @RequestParam(value = "dataStatus") String dataStatus
    ) throws Exception {
        //-------------------------------------
        Tclass tClass = tclassService.getTClass(classId);
        TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
        Set<ClassStudent> students = tClass.getClassStudents();
        final Map<String, Object> params = new HashMap<String, Object>();
        List<ClassStudent> listClassStudents = new ArrayList<ClassStudent>();
        listClassStudents.addAll(students);

        List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
        List<StudentDTO.scoreAttendance> studentArrayList = new ArrayList<>();

        int i=0;
        for (Long studentId : studentsId) {
            Optional<Student> byId = studentDAO.findById(studentId);
            Student student = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
            StudentDTO.scoreAttendance st = modelMapper.map(student, StudentDTO.scoreAttendance.class);

            st.setFullName(st.getFirstName() + " " + st.getLastName());
            st.setScoreA(listClassStudents.get(i).getScore() != null && dataStatus.equals("true") ? listClassStudents.get(i).getScore().toString() : "");
            st.setScoreB(st.calScoreB(st.getScoreA()));

            studentArrayList.add(st);
            i++;
        }

        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());

        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

        params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
        params.put("titleClass", tclassDTO.getTitleClass());
        params.put("code", tclassDTO.getCode());
        params.put("startDate", tclassDTO.getStartDate());
        params.put("endDate", tclassDTO.getEndDate());
        params.put("teacher", tclassDTO.getTeacher());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/scoreControl.jasper", params, jsonDataSource, response);
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/control-print/{type}"})
    public void printScoreWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "classId") Long classId
    ) throws Exception {
        //-------------------------------------
        Tclass tClass = tclassService.getTClass(classId);
        TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
        Set<ClassStudent> students = tClass.getClassStudents();
        final Map<String, Object> params = new HashMap<String, Object>();
        List<ClassStudent> listClassStudents = new ArrayList<ClassStudent>();
        listClassStudents.addAll(students);

        List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
        List<StudentDTO.controlAttendance> studentArrayList = new ArrayList<>();

        int i=0;
        for (Long studentId : studentsId) {
            Optional<Student> byId = studentDAO.findById(studentId);
            Student student = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
            StudentDTO.controlAttendance st = modelMapper.map(student, StudentDTO.controlAttendance.class);
            st.setFullName(st.getFirstName() + " " + st.getLastName());
            studentArrayList.add(st);
            i++;
        }

        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());

        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

        params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
        params.put("titleClass", tclassDTO.getTitleClass());
        params.put("code", tclassDTO.getCode());
        params.put("startDate", tclassDTO.getStartDate());
        params.put("endDate", tclassDTO.getEndDate());
        params.put("teacher", tclassDTO.getTeacher());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/control.jasper", params, jsonDataSource, response);
    }

}
