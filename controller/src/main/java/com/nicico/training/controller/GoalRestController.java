package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IGoalService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/goal")
public class GoalRestController {

    private final IGoalService goalService;
    private final ICourseService courseService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final ModelMapper modelMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<GoalDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(goalService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<List<GoalDTO.Info>> list() {
        return new ResponseEntity<>(goalService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "create/list/{courseId}")
//    @PreAuthorize("hasAuthority('c_goal')")
    public ResponseEntity create(@Validated @RequestBody List<GoalDTO.Create> requests, @PathVariable Long courseId) {
       for (GoalDTO.Create item:requests)
       {
           goalService.create(item, courseId);
       }
        return new ResponseEntity<>(HttpStatus.CREATED);

    }

    @Loggable
    @PostMapping(value = "create/{courseId}")
//    @PreAuthorize("hasAuthority('c_goal')")
    public ResponseEntity<GoalDTO.Info> createList(@Validated @RequestBody GoalDTO.Create request, @PathVariable Long courseId) {
        return new ResponseEntity<>(goalService.create(request, courseId), HttpStatus.CREATED);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<GoalDTO.Info> createWithoutCourse(@RequestBody Object request) {
        GoalDTO.Create create = modelMapper.map(request, GoalDTO.Create.class);
        return new ResponseEntity<>(goalService.createWithoutCourse(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_goal')")
    public ResponseEntity<GoalDTO.Info> update(@PathVariable Long id, @Validated @RequestBody GoalDTO.Update request) {
        return new ResponseEntity<>(goalService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_goal')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        goalService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_goal')")
    public ResponseEntity<Void> delete(@Validated @RequestBody GoalDTO.Delete request) {
        goalService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{categoryId}/goal-list")
    public ResponseEntity<ISC<GoalDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long categoryId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<GoalDTO.Info> searchRs = goalService.getGoalsByCategory(searchRq, categoryId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<GoalDTO.GoalSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                   @RequestParam(value = "_endRow", required = false) Integer endRow,
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

        SearchDTO.SearchRs<GoalDTO.Info> response = goalService.search(request);

        final GoalDTO.SpecRs specResponse = new GoalDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final GoalDTO.GoalSpecRs specRs = new GoalDTO.GoalSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<SearchDTO.SearchRs<GoalDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(goalService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "/syllabus/{goalId}")
//    @PreAuthorize("hasAnyAuthority('r_goal')")
    public ResponseEntity<List<SyllabusDTO.Info>> getSyllabusSet(@PathVariable Long goalId) {
        return new ResponseEntity<>(goalService.getSyllabusSet(goalId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/course/{goalId}")
//    @PreAuthorize("hasAnyAuthority('r_goal')")
    public ResponseEntity<List<CourseDTO.Info>> getCourses(@PathVariable Long goalId) {
        return new ResponseEntity<>(goalService.getCourses(goalId), HttpStatus.OK);
    }

    //  -------------------------------


    @Loggable
    @GetMapping(value = "{goalId}/syllabus")
//    @PreAuthorize("hasAnyAuthority('r_sub_Category')")
    public ResponseEntity<SyllabusDTO.SyllabusSpecRs> getSyllabus(@PathVariable Long goalId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SyllabusDTO.Info> syllabusList = goalService.getSyllabusSet(goalId);
        final SyllabusDTO.SpecRs specResponse = new SyllabusDTO.SpecRs();
        specResponse.setData(syllabusList)
                .setStartRow(0)
                .setEndRow(syllabusList.size())
                .setTotalRows(syllabusList.size());

        final SyllabusDTO.SyllabusSpecRs specRs = new SyllabusDTO.SyllabusSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
    // -----------------

    @Loggable
    @PostMapping(value = {"/print-all/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Goal.jasper", params, response);
    }
    //------------------

    @Loggable
    @GetMapping(value = {"/print-one-course/{courseId}/{type}"})
    public void printOneCourse(HttpServletResponse response,
                               @PathVariable Long courseId,
                               @PathVariable String type) throws Exception {
        List<GoalDTO.Info> getGoal = courseService.getGoal(courseId);
        CourseDTO.Info info = courseService.get(courseId);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("courseName", info.getTitleFa());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(getGoal) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/GoalsOneCourse.jasper", params, jsonDataSource, response);
    }
}
