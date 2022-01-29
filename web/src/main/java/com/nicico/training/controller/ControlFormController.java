package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.*;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.service.ControlReportService;
import com.nicico.training.service.ExportToFileService;
import com.nicico.training.service.StudentService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
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
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@RequiredArgsConstructor
@Controller
@RequestMapping("/controlForm")
public class ControlFormController {

    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final TclassService tclassService;
    private final ModelMapper modelMapper;
    private final AttendanceDAO attendanceDOA;
    private final ControlReportService controlReportService;
    private final MessageSource messageSource;
    private final PersonnelDAO personnelDAO;
    private final StudentService studentService;
    private final ExportToFileService exportToFileService;

    @Transactional(readOnly = true)
    @PostMapping(value = {"/clear-print/{type}"})
    public void printAttendanceWithCriteria(HttpServletResponse response,
                                            @PathVariable String type,
                                            @RequestParam(value = "list") String list,
                                            @RequestParam(value = "classId") Long classId,
                                            @RequestParam(value = "page") String page,
                                            @RequestParam(value = "dataStatus") String dataStatus,
                                            @RequestParam(value = "fields") String fields
    ) throws Exception {
        //-------------------------------------
        Gson gson = new Gson();
        Type resultType = new TypeToken<List<ClassSessionDTO.AttendanceClearForm>>() {
        }.getType();
        List<ClassSessionDTO.AttendanceClearForm> allData = gson.fromJson(list, resultType);

        Tclass tClass = tclassService.getTClass(classId);
        TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
        Set<ClassStudent> classStudents = tClass.getClassStudents();
        List<Student> students = classStudents.stream().map(ClassStudent::getStudent).collect(Collectors.toList());
        List<StudentDTO.clearAttendance> studentArrayList = new ArrayList<>();

        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());

        int maxSessions = 0;

        String dayDate = sessionList.get(0).getSessionDate() != null ? sessionList.get(0).getSessionDate() : "";

        int sessionCounter = 0;

        for (int i = 0; i < sessionList.size(); i++) {
            ClassSession classSession = sessionList.get(i);
            ClassSessionDTO.AttendanceClearForm zaza = modelMapper.map(classSession,  ClassSessionDTO.AttendanceClearForm.class);

            if (classSession != null && allData.stream().anyMatch
                    (q -> q.getSessionDate().equals(zaza.getSessionDate()) &&
                            q.getSessionStartHour().equals(zaza.getSessionStartHour() )  &&
                            q.getDayName().equals(zaza.getDayName() ) &&
                            q.getSessionEndHour().equals(zaza.getSessionEndHour() ) ))  {
                if (!sessionList.get(i).getSessionDate().equals(dayDate)) {
                    dayDate = sessionList.get(i).getSessionDate();
                    sessionCounter = 0;
                }

                sessionCounter++;

                if (sessionCounter >= maxSessions)
                    maxSessions = sessionCounter;
            }//end if
        }//end inner for

        maxSessions = maxSessions >= 5 ? 5 : Math.max(maxSessions, 3);

        for (Student student : students) {
            StudentDTO.clearAttendanceWithState st = modelMapper.map(student, StudentDTO.clearAttendanceWithState.class);

            st.setFullName(st.getFirstName() + " " + st.getLastName());

            st.setCcpAffairs(student.getDepartment() != null ? student.getDepartment().getOmorTitle() : "");
            st.setJobTitle(student.getPost() != null ? (student.getPost().getJob() != null ? student.getPost().getJob().getTitleFa() : "") : "");

            dayDate = sessionList.get(0).getSessionDate() != null ? sessionList.get(0).getSessionDate() : "";

            int z = 0;
            int ztemp = 0;
            Map<String, String> statePerStudent = new HashMap<>();

            for (int i = 0; i < sessionList.size(); i++) {
                ClassSession classSession = sessionList.get(i);


                ClassSessionDTO.AttendanceClearForm zaza = modelMapper.map(classSession,  ClassSessionDTO.AttendanceClearForm.class);

                if (classSession != null && allData.stream().anyMatch
                        (q -> q.getSessionDate().equals(zaza.getSessionDate()) &&
                                q.getSessionStartHour().equals(zaza.getSessionStartHour() )  &&
                                q.getDayName().equals(zaza.getDayName() ) &&
                                q.getSessionEndHour().equals(zaza.getSessionEndHour() ) )) {
                    if (!sessionList.get(i).getSessionDate().equals(dayDate)) {
                        dayDate = sessionList.get(i).getSessionDate();
                        ztemp += maxSessions;
//                        z = ztemp;
                    }

                    Optional<Attendance> attendance = attendanceDOA.findBySessionIdAndStudentId(classSession.getId(), student.getId());

                    if (attendance.isPresent()) {
                        AttendanceDTO attendanceDTO = new AttendanceDTO();
                        attendanceDTO.setDescription(attendance.get().getDescription());
                        attendanceDTO.setState(attendance.get().getState());

                        String tempZ = "";
                        if (z <= 9)
                            tempZ = "0" + z;
                        else
                            tempZ = z + "";

                        if (dataStatus.equals("true"))
                            statePerStudent.put("z" + tempZ, attendanceDTO.statusName(Integer.parseInt(attendanceDTO.getState())));
                        else
                            statePerStudent.put("z" + tempZ, "");
                    z++;
                    } else {
                        z = ztemp;
                    }
                }//end if

            }//end inner for

            st.setStates(statePerStudent);

            studentArrayList.add(st);
        }//end outer for

        final int threshold = 24;
        int remainSize = threshold - studentArrayList.size();

        for (int i = 0; i < remainSize; i++)
            studentArrayList.add(new StudentDTO.clearAttendanceWithState());

        int pages = (int) Math.ceil(sessionList.stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).size() / 5) + 1;
        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

        final Map<String, Object> params = print(allData, maxSessions);

        if (type.equalsIgnoreCase("WORD")) {
            List fieldList = gson.fromJson(fields, List.class);
            List<String> days = params.keySet().stream().filter(s -> s.startsWith("d")).sorted().collect(Collectors.toList());
            List<String> ss = params.keySet().stream().filter(s -> !days.contains(s)).sorted().collect(Collectors.toList());
            int count = 1;
            Iterator<String> iterator = days.iterator();
            String day = iterator.next();
            for (String session : ss) {
                if (count > maxSessions) {
                    count = 1;
                    day = iterator.next();
                }
                count++;
                LinkedHashMap<String, String> map = new LinkedHashMap<>();
                map.put("name", String.format("z%02d", Integer.valueOf(session.replace("se", "")) - 1));
                map.put("title", "(" + params.get(day) + ") " + params.get(session));
                fieldList.add(map);
            }
            fields = objectMapper.writeValueAsString(fieldList);
            List ls = new ArrayList();
            for (StudentDTO.clearAttendance clearAttendance : studentArrayList) {
                Map states = (Map) gson.fromJson(objectMapper.writeValueAsString(clearAttendance), HashMap.class).get("states");
                ((StudentDTO.clearAttendanceWithState) clearAttendance).setStates(null);
                Map m = gson.fromJson(objectMapper.writeValueAsString(clearAttendance), HashMap.class);
                if (states != null && states.size() > 0)
                    m.putAll(states);
                ls.add(m);
            }
            Locale locale = LocaleContextHolder.getLocale();
            Map titles = new TreeMap();
            titles.put(messageSource.getMessage("class.days", null, locale), daysOnClass.toString());
            titles.put(messageSource.getMessage("class.title", null, locale), tclassDTO.getTitleClass());
            titles.put(messageSource.getMessage("class.code", null, locale), tclassDTO.getCode());
            titles.put(messageSource.getMessage("start.date", null, locale), tclassDTO.getStartDate());
            titles.put(messageSource.getMessage("end.date", null, locale), tclassDTO.getEndDate());
            titles.put(messageSource.getMessage("teacher", null, locale), tclassDTO.getTeacher());
            titles.put(messageSource.getMessage("duration", null, locale), (tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : ""));
            exportToFileService.exportToWord(response, fields, objectMapper.writeValueAsString(ls), null, null, titles);
            return;
        }
        params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
        params.put("titleClass", tclassDTO.getTitleClass());
        params.put("code", tclassDTO.getCode());
        params.put("startDate", tclassDTO.getStartDate());
        params.put("endDate", tclassDTO.getEndDate());
        params.put("teacher", tclassDTO.getTeacher());
        params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : "");
        params.put("page", page);
        params.put("pages", String.valueOf(pages));
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        if (maxSessions >= 1 && maxSessions <= 3)
            reportUtil.export("/reports/attendanceData3.jasper", params, jsonDataSource, response);

        else if (maxSessions == 4)
            reportUtil.export("/reports/attendanceData4.jasper", params, jsonDataSource, response);

        else
            reportUtil.export("/reports/attendanceData.jasper", params, jsonDataSource, response);
    }

    protected HashMap<String, Object> print(List<ClassSessionDTO.AttendanceClearForm> sessionList, int maxSessions) {
        final HashMap<String, Object> params = new HashMap<>();

        String date = sessionList.get(0).getSessionDate();
        int d = 1;
        int se = 1;
        int seTemp = 1;
        params.put("d" + d, date);
        boolean checkFirst = true;
        for (ClassSessionDTO.AttendanceClearForm session : sessionList) {
            if (session.getSessionDate().equals(date)) {

                if (checkFirst) {
                    IntStream.rangeClosed(1, maxSessions).forEach(i -> {
                        String strSe = "";
                        if (i <= 9)
                            strSe = "0" + i;
                        else
                            strSe = i + "";

                        params.put("se" + strSe, "فاقد جلسه");
                    });
                    checkFirst = !checkFirst;
                }

                String strSe = "";
                if (se <= 9)
                    strSe = "0" + se;
                else
                    strSe = se + "";

                params.put("se" + strSe, session.getSessionStartHour() + " - " + session.getSessionEndHour());
            } else {
                checkFirst = false;
                date = session.getSessionDate();
                d++;
                params.put("d" + d, date);
                seTemp += maxSessions;
                se = seTemp;

                String strSe = "";
                if (se <= 9)
                    strSe = "0" + se;
                else
                    strSe = se + "";

                params.put("se" + strSe, session.getSessionStartHour() + " - " + session.getSessionEndHour());

                IntStream.rangeClosed(se + 1, se + maxSessions - 1).forEach(i -> {
                    String strSe1 = "";
                    if (i <= 9)
                        strSe1 = "0" + i;
                    else
                        strSe1 = i + "";

                    params.put("se" + strSe1, "فاقد جلسه");
                });
            }
            se++;
        }
        return params;
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/score-print/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "classId") Long classId,
                                  @RequestParam(value = "dataStatus") String dataStatus,
                                  @RequestParam(value = "fields") String fields
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

        int i = 0;
        for (Long studentId : studentsId) {
            Student student = studentService.getStudent(studentId);
            StudentDTO.scoreAttendance st = modelMapper.map(student, StudentDTO.scoreAttendance.class);

            st.setFullName(st.getFirstName() + " " + st.getLastName());
            st.setScoreA(listClassStudents.get(i).getScore() != null && dataStatus.equals("true") ? listClassStudents.get(i).getScore().toString() : "");

            if (tclassDTO.getScoringMethod() != null && tclassDTO.getScoringMethod().equals("3"))
                st.setScoreB(st.calScoreB(st.getScoreA()));

            studentArrayList.add(st);
            i++;
        }

        final int threshold = 23;
        int remainSize = threshold - studentArrayList.size();

        for (int l = 0; l < remainSize; l++)
            studentArrayList.add(new StudentDTO.scoreAttendance());

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
        params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : "");
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        if (type.equalsIgnoreCase("WORD")) {
            Locale locale = LocaleContextHolder.getLocale();
            Map titles = new TreeMap();
            titles.put(messageSource.getMessage("class.days", null, locale), daysOnClass.toString());
            titles.put(messageSource.getMessage("class.title", null, locale), tclassDTO.getTitleClass());
            titles.put(messageSource.getMessage("class.code", null, locale), tclassDTO.getCode());
            titles.put(messageSource.getMessage("start.date", null, locale), tclassDTO.getStartDate());
            titles.put(messageSource.getMessage("end.date", null, locale), tclassDTO.getEndDate());
            titles.put(messageSource.getMessage("teacher", null, locale), tclassDTO.getTeacher());
            titles.put(messageSource.getMessage("duration", null, locale), (tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : ""));
            exportToFileService.exportToWord(response, fields, objectMapper.writeValueAsString(studentArrayList), null, null, titles);
        } else
        reportUtil.export("/reports/scoreControl.jasper", params, jsonDataSource, response);
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/control-print/{type}"})
    public void printScoreWithCriteria(HttpServletResponse response,
                                       @PathVariable String type,
                                       @RequestParam(value = "classId") Long classId,
                                       @RequestParam String fields
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

        int i = 0;
        for (Long studentId : studentsId) {
            Student student = studentService.getStudent(studentId);
            StudentDTO.controlAttendance st = modelMapper.map(student, StudentDTO.controlAttendance.class);

            st.setCcpAffairs(student.getDepartment() != null ? student.getDepartment().getOmorTitle() : "");

            st.setFullName(st.getFirstName() + " " + st.getLastName());
            studentArrayList.add(st);
            i++;
        }

        final int threshold = 23;
        int remainSize = threshold - studentArrayList.size();

        for (int l = 0; l < remainSize; l++)
            studentArrayList.add(new StudentDTO.controlAttendance());

        Set<ClassSession> sessions = tClass.getClassSessions();
        List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                .thenComparing(ClassSession::getSessionStartHour))
                .collect(Collectors.toList());

        studentArrayList = studentArrayList.stream().sorted((o2, o1) -> {
            if (o1.getCcpAffairs() == null) return -1;
            if (o2.getCcpAffairs() == null) return 1;
            return o1.getCcpAffairs().compareTo(o2.getCcpAffairs());
        }).collect(Collectors.toList());

        Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

        params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
        params.put("titleClass", tclassDTO.getTitleClass());
        params.put("code", tclassDTO.getCode());
        params.put("startDate", tclassDTO.getStartDate());
        params.put("endDate", tclassDTO.getEndDate());
        params.put("teacher", tclassDTO.getTeacher());
        params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : "");
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(studentArrayList) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        if (type.equalsIgnoreCase("WORD")) {
            Locale locale = LocaleContextHolder.getLocale();
            Map titles = new TreeMap();
            titles.put(messageSource.getMessage("class.days", null, locale), daysOnClass.toString());
            titles.put(messageSource.getMessage("class.title", null, locale), tclassDTO.getTitleClass());
            titles.put(messageSource.getMessage("class.code", null, locale), tclassDTO.getCode());
            titles.put(messageSource.getMessage("start.date", null, locale), tclassDTO.getStartDate());
            titles.put(messageSource.getMessage("end.date", null, locale), tclassDTO.getEndDate());
            titles.put(messageSource.getMessage("teacher", null, locale), tclassDTO.getTeacher());
            titles.put(messageSource.getMessage("duration", null, locale), (tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + " ساعت " : ""));
            exportToFileService.exportToWord(response, fields, objectMapper.writeValueAsString(studentArrayList), null, null, titles);
        } else
            reportUtil.export("/reports/control.jasper", params, jsonDataSource, response);
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/exportExcelAttendance"})
    public void exportExcelAttendance(final HttpServletResponse response,
                                      @RequestParam(value = "classId") String classId,
                                      @RequestParam(value = "dataStatus") String dataStatus
    ) throws IOException {
        Long[] idClasses = Arrays.stream(classId.split(",")).map(x -> Long.valueOf(x)).toArray(Long[]::new);
        List<Map<String, String>> listMaps = new ArrayList<>();
        List<List<StudentDTO.clearAttendanceWithState>> listStudentArray = new ArrayList<>();
        List<List<ClassSession>> listSessionList = new ArrayList<>();

        for (int m = 0; m < idClasses.length; m++) {
            Tclass tClass = tclassService.getTClass(idClasses[m]);
            TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
            Set<ClassStudent> students = tClass.getClassStudents();
            List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
            List<StudentDTO.clearAttendanceWithState> studentArrayList = new ArrayList<>();

            Set<ClassSession> sessions = tClass.getClassSessions();

            if (sessions == null || sessions.size() == 0)
                continue;

            List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                    .thenComparing(ClassSession::getSessionStartHour))
                    .collect(Collectors.toList());

            listSessionList.add(sessionList);

            for (Long studentId : studentsId) {
                Student student = studentService.getStudent(studentId);
                StudentDTO.clearAttendanceWithState st = modelMapper.map(student, StudentDTO.clearAttendanceWithState.class);

                st.setCcpAffairs(student.getDepartment() != null ? student.getDepartment().getOmorTitle() : "");
                st.setJobTitle(student.getPost() != null ? (student.getPost().getJob() != null ? student.getPost().getJob().getTitleFa() : "") : "");

                st.setFullName(st.getFirstName() + " " + st.getLastName());

                String dayDate = sessionList.get(0).getSessionDate() != null ? sessionList.get(0).getSessionDate() : "";

                int z = 0;
                int ztemp = 0;
                Map<Integer, String> statePerStudent = new HashMap<>();

                for (int i = 0; i < sessionList.size(); i++) {
                    ClassSession classSession = sessionList.get(i);

                    if (classSession != null) {
                        if (!sessionList.get(i).getSessionDate().equals(dayDate)) {
                            dayDate = sessionList.get(i).getSessionDate();
                            ztemp += 5;
                            z = ztemp;
                        }

                        Optional<Attendance> attendance = attendanceDOA.findBySessionIdAndStudentId(classSession.getId(), studentId);

                        if (attendance.isPresent()) {
                            AttendanceDTO attendanceDTO = new AttendanceDTO();
                            attendanceDTO.setDescription(attendance.get().getDescription());
                            attendanceDTO.setState(attendance.get().getState());


                            if (dataStatus.equals("true"))
                                statePerStudent.put(z, attendanceDTO.statusName(Integer.parseInt(attendanceDTO.getState())));
                            else
                                statePerStudent.put(z, "");

                        }

                    }//end if
                    z++;
                }//end inner for

                st.setStates(statePerStudent);

                studentArrayList.add(st);
            }//end outer for

            listStudentArray.add(studentArrayList.stream().sorted((o2, o1) -> {
                if (o1.getCcpAffairs() == null) return -1;
                if (o2.getCcpAffairs() == null) return 1;
                return o1.getCcpAffairs().compareTo(o2.getCcpAffairs());
            }).collect(Collectors.toList()));

            final Map<String, String> params = new HashMap<>();
            params.put("days", sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet()).toString());
            params.put("titleClass", tclassDTO.getTitleClass());
            params.put("code", tclassDTO.getCode());
            params.put("startDate", tclassDTO.getStartDate());
            params.put("endDate", tclassDTO.getEndDate());
            params.put("teacher", tclassDTO.getTeacher());
            params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + "ساعت" : "");

            listMaps.add(params);
        }

        try {
            controlReportService.exportToExcelAttendance(response, listMaps, listSessionList, listStudentArray);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/exportExcelScore"})
    public void exportExcelScore(final HttpServletResponse response,
                                 @RequestParam(value = "classId") String classId,
                                 @RequestParam(value = "dataStatus") String dataStatus
    ) throws IOException {
        Long[] idClasses = Arrays.stream(classId.split(",")).map(x -> Long.valueOf(x)).toArray(Long[]::new);
        List<List<StudentDTO.scoreAttendance>> listStudentArray = new ArrayList<>();
        List<List<ClassSession>> listSessionList = new ArrayList<>();
        List<Map<String, String>> listMaps = new ArrayList<>();

        for (int m = 0; m < idClasses.length; m++) {
            Tclass tClass = tclassService.getTClass(idClasses[m]);
            TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
            Set<ClassStudent> students = tClass.getClassStudents();

            List<ClassStudent> listClassStudents = new ArrayList<ClassStudent>();
            listClassStudents.addAll(students);

            List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
            List<StudentDTO.scoreAttendance> studentArrayList = new ArrayList<>();

            int i = 0;


            for (Long studentId : studentsId) {
                Student student = studentService.getStudent(studentId);
                StudentDTO.scoreAttendance st = modelMapper.map(student, StudentDTO.scoreAttendance.class);
                st.setFullName(st.getFirstName() + " " + st.getLastName());
                st.setScoreA(listClassStudents.get(i).getScore() != null && dataStatus.equals("true") ? listClassStudents.get(i).getScore().toString() : "");

                if (tclassDTO.getScoringMethod() != null && tclassDTO.getScoringMethod().equals("3"))
                    st.setScoreB(st.calScoreB(st.getScoreA()));

                studentArrayList.add(st);
                i++;
            }//end outer for

            listStudentArray.add(studentArrayList);

            Set<ClassSession> sessions = tClass.getClassSessions();
            List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                    .thenComparing(ClassSession::getSessionStartHour))
                    .collect(Collectors.toList());

            Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

            final Map<String, String> params = new HashMap<>();
            params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
            params.put("days", sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet()).toString());
            params.put("titleClass", tclassDTO.getTitleClass());
            params.put("code", tclassDTO.getCode());
            params.put("startDate", tclassDTO.getStartDate());
            params.put("endDate", tclassDTO.getEndDate());
            params.put("teacher", tclassDTO.getTeacher());
            params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + "ساعت" : "");

            listMaps.add(params);
        }

        try {
            controlReportService.exportToExcelScore(response, listMaps, listStudentArray);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/exportExcelControl"})
    public void exportExcelControl(final HttpServletResponse response,
                                   @RequestParam(value = "classId") String classId,
                                   @RequestParam(value = "dataStatus") String dataStatus
    ) throws IOException {
        Long[] idClasses = Arrays.stream(classId.split(",")).map(x -> Long.valueOf(x)).toArray(Long[]::new);
        List<List<StudentDTO.controlAttendance>> listStudentArray = new ArrayList<>();
        List<List<ClassSession>> listSessionList = new ArrayList<>();
        List<Map<String, String>> listMaps = new ArrayList<>();

        for (int m = 0; m < idClasses.length; m++) {
            Tclass tClass = tclassService.getTClass(idClasses[m]);
            TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
            Set<ClassStudent> students = tClass.getClassStudents();

            List<ClassStudent> listClassStudents = new ArrayList<ClassStudent>();
            listClassStudents.addAll(students);

            List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
            List<StudentDTO.controlAttendance> studentArrayList = new ArrayList<>();

            int i = 0;


            for (Long studentId : studentsId) {
                Student student = studentService.getStudent(studentId);
                StudentDTO.controlAttendance st = modelMapper.map(student, StudentDTO.controlAttendance.class);
                st.setFullName(st.getFirstName() + " " + st.getLastName());

                st.setCcpAffairs(student.getDepartment() != null ? student.getDepartment().getOmorTitle() : "");

                studentArrayList.add(st);
                i++;
            }//end outer for

            listStudentArray.add(studentArrayList.stream().sorted((o2, o1) -> {
                if (o1.getCcpAffairs() == null) return -1;
                if (o2.getCcpAffairs() == null) return 1;
                return o1.getCcpAffairs().compareTo(o2.getCcpAffairs());
            }).collect(Collectors.toList()));

            Set<ClassSession> sessions = tClass.getClassSessions();
            List<ClassSession> sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                    .thenComparing(ClassSession::getSessionStartHour))
                    .collect(Collectors.toList());

            Set<String> daysOnClass = sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet());

            final Map<String, String> params = new HashMap<>();
            params.put("days", "روزهای تشکیل کلاس: " + daysOnClass.toString());
            params.put("days", sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet()).toString());
            params.put("titleClass", tclassDTO.getTitleClass());
            params.put("code", tclassDTO.getCode());
            params.put("startDate", tclassDTO.getStartDate());
            params.put("endDate", tclassDTO.getEndDate());
            params.put("teacher", tclassDTO.getTeacher());
            params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + "ساعت" : "");

            listMaps.add(params);
        }

        try {
            controlReportService.exportToExcelControl(response, listMaps, listStudentArray);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }

    @Transactional(readOnly = true)
    @PostMapping(value = {"/exportExcelAll"})
    public void exportExcelAll(final HttpServletResponse response,
                               @RequestParam(value = "classId") String classId,
                               @RequestParam(value = "dataStatus") String dataStatus
    ) throws IOException {
        Long[] idClasses = Arrays.stream(classId.split(",")).map(x -> Long.valueOf(x)).toArray(Long[]::new);
        List<Map<String, String>> listMaps = new ArrayList<>();
        List<List<StudentDTO.fullAttendance>> listStudentArray = new ArrayList<>();
        List<List<ClassSession>> listSessionList = new ArrayList<>();

        for (int m = 0; m < idClasses.length; m++) {
            Tclass tClass = tclassService.getTClass(idClasses[m]);
            TclassDTO.Info tclassDTO = modelMapper.map(tClass, TclassDTO.Info.class);
            Set<ClassStudent> students = tClass.getClassStudents();
            List<ClassStudent> listClassStudents = new ArrayList<ClassStudent>();
            listClassStudents.addAll(students);

            List<Long> studentsId = students.stream().map(s -> s.getStudent().getId()).collect(Collectors.toList());
            List<StudentDTO.fullAttendance> studentArrayList = new ArrayList<>();

            Set<ClassSession> sessions = tClass.getClassSessions();
            boolean flag = true;
            List<ClassSession> sessionList = new ArrayList<>();

            if (sessions == null || sessions.size() == 0)
                flag = false;

            if (flag) {
                sessionList = sessions.stream().sorted(Comparator.comparing(ClassSession::getSessionDate)
                        .thenComparing(ClassSession::getSessionStartHour))
                        .collect(Collectors.toList());
            }

            listSessionList.add(sessionList);

            int cnt = 0;

            for (Long studentId : studentsId) {
                Student student = studentService.getStudent(studentId);
                StudentDTO.fullAttendance st = modelMapper.map(student, StudentDTO.fullAttendance.class);
                st.setFullName(st.getFirstName() + " " + st.getLastName());

                st.setCcpAffairs(student.getDepartment() != null ? student.getDepartment().getOmorTitle() : "");
                st.setJobTitle(student.getPost() != null ? (student.getPost().getJob() != null ? student.getPost().getJob().getTitleFa() : "") : "");

                st.setScoreA(listClassStudents.get(cnt).getScore() != null && dataStatus.equals("true") ? listClassStudents.get(cnt).getScore().toString() : "");

                if (tclassDTO.getScoringMethod() != null && tclassDTO.getScoringMethod().equals("3"))
                    st.setScoreB(st.calScoreB(st.getScoreA()));

                String dayDate = "";

                if (flag) {
                    dayDate = sessionList.get(0).getSessionDate() != null ? sessionList.get(0).getSessionDate() : "";

                    int z = 0;
                    int ztemp = 0;
                    Map<Integer, String> statePerStudent = new HashMap<>();

                    for (int i = 0; i < sessionList.size(); i++) {
                        ClassSession classSession = sessionList.get(i);

                        if (classSession != null) {
                            if (!sessionList.get(i).getSessionDate().equals(dayDate)) {
                                dayDate = sessionList.get(i).getSessionDate();
                                ztemp += 5;
                                z = ztemp;
                            }

                            Optional<Attendance> attendance = attendanceDOA.findBySessionIdAndStudentId(classSession.getId(), studentId);

                            if (attendance.isPresent()) {
                                AttendanceDTO attendanceDTO = new AttendanceDTO();
                                attendanceDTO.setDescription(attendance.get().getDescription());
                                attendanceDTO.setState(attendance.get().getState());
                                if (dataStatus.equals("true"))
                                    statePerStudent.put(z, attendanceDTO.statusName(Integer.parseInt(attendanceDTO.getState())));
                                else
                                    statePerStudent.put(z, "");

                            }

                        }//end if
                        z++;
                    }//end inner for

                    st.setStates(statePerStudent);
                }

                studentArrayList.add(st);
                cnt++;
            }//end outer for

            listStudentArray.add(studentArrayList);

            final Map<String, String> params = new HashMap<>();
            params.put("days", sessionList.stream().map(ClassSession::getDayName).collect(Collectors.toSet()).toString());
            params.put("titleClass", tclassDTO.getTitleClass());
            params.put("code", tclassDTO.getCode());
            params.put("startDate", tclassDTO.getStartDate());
            params.put("endDate", tclassDTO.getEndDate());
            params.put("teacher", tclassDTO.getTeacher());
            params.put("hduration", tclassDTO.getHDuration() != null ? tclassDTO.getHDuration().toString() + "ساعت" : "");
            listMaps.add(params);
        }

        try {
            controlReportService.exportToExcelFull(response, listMaps, listSessionList, listStudentArray);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }
}
