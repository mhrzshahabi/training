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
import net.sf.jasperreports.engine.JRException;
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
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/attendance")
public class AttendanceFormController {

    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final TclassService tclassService;
    private final ModelMapper modelMapper;
    private final StudentDAO studentDAO;

    @Transactional(readOnly = true)
    @PostMapping(value = {"/clear-print/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "list") String list,
                                  @RequestParam(value = "classId") Long classId,
                                  @RequestParam(value = "page") String page
    ) throws Exception {
        //-------------------------------------
        Gson gson = new Gson();
        Type resultType = new TypeToken<List<ClassSessionDTO.AttendanceClearForm>>() {
        }.getType();
        List<ClassSessionDTO.AttendanceClearForm> allData = gson.fromJson(list, resultType);

        Tclass tClass = tclassService.getTClass(classId);
        TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
        Set<ClassStudent> students = tClass.getClassStudents();
        List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
        List<StudentDTO.clearAttendance> studentArrayList = new ArrayList<>();
        for (Long studentId : studentsId) {
            Optional<Student> byId = studentDAO.findById(studentId);
            Student student = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
            StudentDTO.clearAttendance st = modelMapper.map(student, StudentDTO.clearAttendance.class);
            st.setFullName(st.getFirstName() + " " + st.getLastName());
            studentArrayList.add(st);
        }
        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());
        int pages = (int)Math.ceil(sessionList.stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).size() / 5)+1;
        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());
        final Map<String, Object> params = print(allData);
//        final Map<String, Object> params = print(modelMapper.map(list, new TypeToken<List<ClassSessionDTO.AttendanceClearForm>>(){}.getType()));
        params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
        params.put("titleClass", tclassDTO.getTitleClass());
        params.put("code", tclassDTO.getCode());
        params.put("startDate", tclassDTO.getStartDate());
        params.put("endDate", tclassDTO.getEndDate());
        params.put("teacher", tclassDTO.getTeacher());
        params.put("page", page);
        params.put("pages", String.valueOf(pages));
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/attendanceClear.jasper", params, jsonDataSource, response);
    }

    protected HashMap<String, Object> print(List<ClassSessionDTO.AttendanceClearForm> sessionList) {
        final HashMap<String, Object> params = new HashMap<>();
        String date = sessionList.get(0).getSessionDate();
        int d = 1;
        double se = 1;
        params.put("d" + d, date);
        for (ClassSessionDTO.AttendanceClearForm session : sessionList) {
            if (session.getSessionDate().equals(date)) {
                params.put("se" + (int) se, session.getSessionStartHour() + " - " + session.getSessionEndHour());
                se++;
            } else {
                date = session.getSessionDate();
                d++;
//                if(d == 6){
//                    print(sessionList.subList(sessionList.indexOf(session),sessionList.size()), students, response);
//                }
                params.put("d" + d, date);
                se = Math.ceil(se / 5) * 5 + 1;
                params.put("se" + (int) se, session.getSessionStartHour() + " - " + session.getSessionEndHour());
                se++;
            }
        }
        return params;
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/full-clear-print/{type}"})
    public void printFullClear(HttpServletResponse response,
                               @PathVariable String type,
                               @RequestParam(value = "list") String list) throws JRException, IOException, SQLException {
        final Map<String, Object> params = new HashMap<>();
        String data = "{" + "\"content\": " + list + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/attendanceFullClear.jasper", params, jsonDataSource, response);
    }

}
