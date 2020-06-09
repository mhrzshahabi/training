package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TrainingOverTimeDTO;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Student;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.websocket.Session;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/trainingOverTime")
public class TrainingOverTimeController {

    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final AttendanceService attendanceService;
    private final ClassSessionService classSessionService;
    private final TrainingOverTimeService trainingOverTimeService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
//	@PreAuthorize("hasAuthority('r_syllabus')")
    public ResponseEntity<TrainingOverTimeDTO.TrainingOverTimeSpecRs> list(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {

        List<TrainingOverTimeDTO.Info> response = trainingOverTimeService.getTrainingOverTimeReportList(startDate, endDate);

        final TrainingOverTimeDTO.SpecRs specResponse = new TrainingOverTimeDTO.SpecRs();
        final TrainingOverTimeDTO.TrainingOverTimeSpecRs specRs = new TrainingOverTimeDTO.TrainingOverTimeSpecRs();
        specResponse.setData(response)
                .setStartRow(0)
                .setEndRow(response.size())
                .setTotalRows(response.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
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
