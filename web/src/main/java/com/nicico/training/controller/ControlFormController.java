package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.service.AttendanceService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
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
    private final AttendanceDAO attendanceDOA;

    @Transactional(readOnly = true)
    @PostMapping(value = {"/clear-print/{type}"})
    public void printAttendanceWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "list") String list,
                                  @RequestParam(value = "classId") Long classId,
                                  @RequestParam(value = "page") String page,
                                  @RequestParam(value = "dataStatus") String dataStatus
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

        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());


        for (Long studentId : studentsId) {
            Optional<Student> byId = studentDAO.findById(studentId);
            Student student = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
            StudentDTO.clearAttendanceWithState st = modelMapper.map(student, StudentDTO.clearAttendanceWithState.class);
            st.setFullName(st.getFirstName() + " " + st.getLastName());

            if (dataStatus.equals("true")) {
                String dayName = sessionList.get(0).getDayName() != null ? sessionList.get(0).getDayName() : "";

                int z = 0;
                int ztemp = 0;
                Map<String, String> statePerStudent = new HashMap<>();

                for (int i = 0; i < allData.size(); i++) {
                    final int j = i;
                    ClassSession classSession=null;

                    ClassSessionDTO.AttendanceClearForm data=allData.get(j);

                    if (data!=null)
                    {
                        classSession = sessionList.stream().filter(x ->
                                        x.getDayName().equals(data.getDayName()) &&
                                        x.getSessionDate().equals(data.getSessionDate()) &&
                                        x.getSessionStartHour().equals(data.getSessionStartHour()) &&
                                        x.getSessionEndHour().equals(data.getSessionEndHour())).findFirst().get();
                    }

                    if (classSession != null) {
                        if (!sessionList.get(i).getDayName().equals(dayName)) {
                            dayName = sessionList.get(i).getDayName();
                            ztemp += 5;
                            z = ztemp;
                        }

                        List<AttendanceDTO> attendanceDTOS = modelMapper.map(attendanceDOA.findBySessionIdAndStudentId(classSession.getId(), studentId), new TypeToken<List<AttendanceDTO>>() {
                        }.getType());
                        AttendanceDTO attendanceDTO = attendanceDTOS.size() != 0 && attendanceDTOS.get(0) != null ? attendanceDTOS.get(0) : null;

                        if (attendanceDTO != null) {
                            statePerStudent.put("z" + z, attendanceDTO.statusName(Integer.parseInt(attendanceDTO.getState())));
                        }//end if

                    }//end if
                    z++;
                }//end inner for

                st.setStates(statePerStudent);
            }
            studentArrayList.add(st);
        }//end outer for

        int pages = (int)Math.ceil(sessionList.stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).size() / 5)+1;
        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

        final Map<String, Object> params = print(allData);
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
        reportUtil.export("/reports/attendanceData.jasper", params, jsonDataSource, response);
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
                params.put("d" + d, date);
                se = Math.ceil(se / 5) * 5 + 1;
                params.put("se" + (int) se, session.getSessionStartHour() + " - " + session.getSessionEndHour());
                se++;
            }
        }
        return params;

    }


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
