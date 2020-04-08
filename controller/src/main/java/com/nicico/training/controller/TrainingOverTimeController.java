package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Student;
import com.nicico.training.service.AttendanceService;
import com.nicico.training.service.ClassSessionService;
import com.nicico.training.service.StudentService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/trainingOverTime")
public class TrainingOverTimeController {

    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final AttendanceService attendanceService;
    private final ClassSessionService classSessionService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
//	@PreAuthorize("hasAuthority('r_syllabus')")
    public ResponseEntity<List> list(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {
        List<ClassSession> sessions = classSessionService.findBySessionDateBetween(startDate, endDate);
        List<Attendance> attendances = attendanceService.findBySessionInAndState(sessions, "2");
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        List<Map<String, String>> list = new ArrayList<>();
        Map<String,Map<String, String>> mapMap = new HashMap<>();
        for (Attendance a : attendances) {
//            ClassSessionDTO.Info session = classSessionService.get(a.getSessionId());
//            Student student = studentService.getStudent(a.getStudentId());
//            TclassDTO.Info tclassDTO = tclassService.get(session.getClassId());
            String key = a.getStudent().getNationalCode() + a.getSession().getSessionDate();
            if(mapMap.containsKey(key)){
                try {
                    Float time = (float)(sdf.parse(a.getSession().getSessionEndHour()).getTime() - sdf.parse(a.getSession().getSessionStartHour()).getTime())/3600000;
                    Float totalTime = Float.parseFloat(mapMap.get(key).get("time")) + time;
                    mapMap.get(key).put("time",String.format("%.2f",totalTime));
                }catch (ParseException e) {
                    e.printStackTrace();
                }
            }else{
                HashMap<String, String> map = new HashMap<>();
                map.put("personalNum", a.getStudent().getPersonnelNo());
                map.put("personalNum2", a.getStudent().getPersonnelNo2());
                map.put("nationalCode", a.getStudent().getNationalCode());
                map.put("name", a.getStudent().getFirstName() + " " + a.getStudent().getLastName());
                map.put("ccpArea", a.getStudent().getCcpArea());
                map.put("classCode", a.getSession().getTclass().getCode());
                map.put("className", a.getSession().getTclass().getTitleClass());
                map.put("date", a.getSession().getSessionDate());
                try {
                    Float time = (float)(sdf.parse(a.getSession().getSessionEndHour()).getTime() - sdf.parse(a.getSession().getSessionStartHour()).getTime())/3600000;//60000
                    map.put("time", time.toString());
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                mapMap.put(key,map);
            }
        }
        Iterator it = mapMap.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            list.add((Map<String, String>) pair.getValue());
            it.remove(); // avoids a ConcurrentModificationException
        }
        return new ResponseEntity<>(list, HttpStatus.OK);
    }


    // -----------------

//    @Loggable
//    @GetMapping(value = {"/print/{type}"})
//    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
//        Map<String, Object> params = new HashMap<>();
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/Syllabus.jasper", params, response);
//    }
//    //------------------
//
//    @Loggable
//    @GetMapping(value = {"/print-one-course/{courseId}/{type}"})
//    public void printOneCourse(HttpServletResponse response, @PathVariable Long courseId, @PathVariable String type) throws Exception {
//        List<SyllabusDTO.Info> getSyllabus = syllabusService.getSyllabusCourse(courseId);
//        CourseDTO.Info info = courseService.get(courseId);
//        String s = "دوره " + info.getTitleFa();
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//        params.put("courseName", s);
//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(getSyllabus) + "}";
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/SyllabusOneCourse.jasper", params, jsonDataSource, response);
//    }//------------------
//
//    @Loggable
//    @GetMapping(value = {"/print-one-goal/{goalId}/{type}"})
//    public void printOneGoal(HttpServletResponse response, @PathVariable Long goalId, @PathVariable String type) throws Exception {
//        List<SyllabusDTO.Info> getSyllabus = goalService.getSyllabusSet(goalId);
//        GoalDTO.Info info = goalService.get(goalId);
//        String s = "هدف " + info.getTitleFa();
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//        params.put("courseName", s);
//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(getSyllabus) + "}";
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/SyllabusOneGoal.jasper", params, jsonDataSource, response);
//    }
}
