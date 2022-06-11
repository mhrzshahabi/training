package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.jpa.resource.SearchableResource;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.iservice.ICourseAuditService;
import com.nicico.training.mapper.course.CourseBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETheoType;
import dto.SkillDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import request.course.CourseUpdateRequest;
import response.BaseResponse;
import response.course.CourseDeleteResponse;
import response.course.CourseListResponse;
import response.course.CourseUpdateResponse;
import response.course.dto.CourseDto;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/course")
public class CourseRestController extends SearchableResource<Course, CourseListResponse.Response>{
    //------------------------------------------
    private final ReportUtil reportUtil;
    private final ICourseService iCourseService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final IWorkGroupService workGroupService;
    private final CourseBeanMapper beanMapper;
    private final ISkillService skillService;
    private final ICourseAuditService iCourseAuditService;
    private final CourseBeanMapper courseBeanMapper;
    private final CriteriaUtil criteriaUtil;

    // ---------------------------------
    @Loggable
    @GetMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(iCourseService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<List<CourseDTO.Info>> list() {
        return new ResponseEntity<>(iCourseService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/preCourse/{courseId}")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<List<CourseDTO.Info>> preCourseList(@PathVariable Long courseId) {
        List<CourseDTO.Info> list = iCourseService.preCourseList(courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/equalCourse/{courseId}")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<List<EqualCourseDTO.Info>> equalCourseList(@PathVariable Long courseId) {
        return new ResponseEntity<>(iCourseService.equalCourseList(courseId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/equalCourseIds/{courseId}")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<List<Long>> equalCourseIdsList(@PathVariable Long courseId) {
        return new ResponseEntity<>(iCourseService.equalCourseIdsList(courseId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/checkDependence/{courseId}")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseDependence> checkDependence(@PathVariable Long courseId) {
        return new ResponseEntity<>(iCourseService.checkDependence(courseId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    //@PreAuthorize("hasAuthority('Course_C')")
    public ResponseEntity<CourseDto> create(@RequestBody CourseDTO.Create  req, HttpServletResponse response) {
        CourseDto courseInfo = iCourseService.create(req, response);
        if (courseInfo != null)
            return new ResponseEntity<>(courseInfo, HttpStatus.CREATED);
        else
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    @Loggable
    @PutMapping(value = "setPreCourse/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity setPreCourse(@PathVariable Long id,
                                       @RequestBody List<Long> req,
                                       @RequestParam(required = false) String type) {
        final CourseDTO.AddOrRemovePreCourse preCourse = new CourseDTO.AddOrRemovePreCourse();
        preCourse.setCourseId(id);
        preCourse.setPreCoursesId(req);
        if(type.equals("create")) {
            iCourseService.addPreCourse(preCourse);
        }
        else if(type.equals("remove")){
            iCourseService.removePreCourse(preCourse);
        }
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "setEqualCourse/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity setEqualCourse(@PathVariable Long id, @RequestBody List<String> req) {
        iCourseService.setEqualCourse(id, req);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CourseUpdateResponse> update(@PathVariable Long id, @RequestBody CourseUpdateRequest request) {
        if(request.getMainSkills().stream().anyMatch(skill->skill.getSubCategoryId() != request.getSubCategory().getId())){
            CourseUpdateResponse response = new CourseUpdateResponse();
            response.setMessage("خطا: زیرگروه اهداف اصلی با زیرگروه دوره همخوانی ندارد!");
            response.setStatus(409);
            return new ResponseEntity<>(response, HttpStatus.OK);
        }
        return new ResponseEntity<>(iCourseService.update(beanMapper.updateCourse(request,
                iCourseService.getCourse(id)), request.getMainSkills().stream().map(SkillDto::getId)
                .collect(Collectors.toList())), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "deleteCourse/{id}")
    //@PreAuthorize("hasAuthority('Course_D')")
    public ResponseEntity<CourseDeleteResponse> delete(@PathVariable Long id) {
        boolean check = iCourseService.checkForDelete(id);
        CourseDeleteResponse response = new CourseDeleteResponse();
        if (check) {
            try {
                iCourseService.delete(id);
                response.setMessage("عمليات حذف با موفقيت انجام شد");
                response.setStatus(200);
            }
            catch (Exception e){
                if(e.toString().split(";")[2].contains("FKILBXORAQADWTOK81KWPDGBSSB")){
                    response.setMessage("دوره قابل حذف نميباشد. بدليل اينکه معادل دوره ديگري است.");
                }else if(e.toString().split(";")[2].contains("FKFO4NAM3WFRJ5URT3GD0KEVSLR")){
                    response.setMessage("دوره قابل حذف نميباشد. بدليل اينکه پيشنياز دوره ديگري است.");
                }else{
                    response.setMessage("دوره قابل حذف نميباشد. بديل اينکه از آن در قسمتي از برنامه استفاده شده است.");
                }
                response.setStatus(409);
            }
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    //@PreAuthorize("hasAuthority('Course_D')")
    public ResponseEntity<Void> delete(@Validated @RequestBody CourseDTO.Delete request) {
        iCourseService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) Long id,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        if(sortBy != null) {
            switch (sortBy) {
                case "duration":
                    sortBy = "theoryDuration";
                    break;
                case "-duration":
                    sortBy = "-theoryDuration";
                    break;
            }
        }


        SearchDTO.CriteriaRq criteriaRq = null;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);


            if (request.getCriteria() != null && request.getCriteria().getCriteria() != null)
            {
                for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                    if(criterion.getFieldName()!=null) {
                        if (criterion.getFieldName().equals("duration")) {
                            criterion.setFieldName("theoryDuration");
                        }
                    }
                }
            }
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

        request.setCriteria(workGroupService.addPermissionToCriteria("categoryId", request.getCriteria()));

        SearchDTO.SearchRs<CourseDTO.Info> response = iCourseService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

  /*  @Loggable
    @PostMapping(value = "/search")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<SearchDTO.SearchRs<CourseDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(iCourseService.search(request), HttpStatus.OK);
    }*/

    @Loggable
    @GetMapping(value = "/{courseId}/goal")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<GoalDTO.GoalSpecRs> getGoal(@PathVariable Long courseId) {

        List<GoalDTO.Info> goal = iCourseService.getGoal(courseId);

        final GoalDTO.SpecRs specResponse = new GoalDTO.SpecRs();
        specResponse.setData(goal)
                .setStartRow(0)
                .setEndRow(goal.size())
                .setTotalRows(goal.size());
        final GoalDTO.GoalSpecRs specRs = new GoalDTO.GoalSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/skill/{courseId}")
    //@PreAuthorize("hasAuthority('Course_Skill')")
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkill(@PathVariable Long courseId) {
        List<SkillDTO.Info> skill = iCourseService.getSkill(courseId);
        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        specResponse.setData(skill)
                .setStartRow(0)
                .setEndRow(skill.size())
                .setTotalRows(skill.size());
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/goal-mainObjective/{courseId}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<List<Map<String, String>>> getGoalsAndMainObjectives(@PathVariable Long courseId) {
        List<GoalDTO.Info> goals = iCourseService.getGoal(courseId);
        List<SkillDTO.Info> mainObjectives = iCourseService.getMainObjective(courseId);
        List<Map<String, String>> list = new ArrayList<>();
        for (GoalDTO.Info goal : goals) {
            Map<String, String> map = new HashMap<>();
            map.put("id", goal.getId().toString());
            map.put("type", "goal");
            map.put("title", goal.getTitleFa());
            list.add(map);
        }
        for (SkillDTO.Info mainObjective : mainObjectives) {
            Map<String, String> map = new HashMap<>();
            map.put("id", mainObjective.getId().toString());
            map.put("type", "skill");
            map.put("title", mainObjective.getTitleFa());
            list.add(map);
        }
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/job/{courseId}")
    //@PreAuthorize("hasAuthority('Course_Job')")
    public ResponseEntity<ISC> getJob(@PathVariable Long courseId) {
        List<JobDTO.Info> job = iCourseService.getJob(courseId);
        ISC.Response response = new ISC.Response();
        response.setData(job)
                .setStartRow(0)
                .setEndRow(job.size())
                .setTotalRows(job.size());
        ISC<Object> isc = new ISC<>(response);
        return new ResponseEntity<>(isc, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/post/{courseId}")
    //@PreAuthorize("hasAuthority('Course_Post')")
    public ResponseEntity<ISC> getPost(@PathVariable Long courseId) {
        List<PostDTO.Info> post = iCourseService.getPost(courseId);
        ISC.Response response = new ISC.Response();
        response.setData(post)
                .setStartRow(0)
                .setEndRow(post.size())
                .setTotalRows(post.size());
        ISC<Object> isc = new ISC<>(response);
        return new ResponseEntity<>(isc, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{courseId}/{goalIdList}")
    // @PreAuthorize("hasAuthority('d_course')")
    //TODO:Unknown
    public ResponseEntity<Void> getCourseIdvGoalsId(@PathVariable Long courseId, @PathVariable List<Long> goalIdList) {
        iCourseService.getCourseIdvGoalsId(courseId, goalIdList);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/remove/{courseId}/{goalIdList}")
    //@PreAuthorize("hasAuthority('d_course')")
    //TODO:Unknown
    public ResponseEntity<Void> removeCourseSGoal(@PathVariable Long courseId, @PathVariable List<Long> goalIdList) {
        iCourseService.removeCourseSGoal(courseId, goalIdList);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/goal/{courseId}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<GoalDTO.GoalSpecRs> getGoalWithOut(@PathVariable Long courseId) {
        List<GoalDTO.Info> goal = iCourseService.getGoalWithOut(courseId);
        final GoalDTO.SpecRs specResponse = new GoalDTO.SpecRs();
        specResponse.setData(goal)
                .setStartRow(0)
                .setEndRow(goal.size())
                .setTotalRows(goal.size());
        final GoalDTO.GoalSpecRs specRs = new GoalDTO.GoalSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

//-------------------------------------------------------------------------------------

    @Loggable
    @GetMapping(value = "/getmaxcourse/{str}")
    //@PreAuthorize("hasAuthority('Course_C')")
    public ResponseEntity<String> getMaxCourseCode(@PathVariable String str) {
        return new ResponseEntity<>(iCourseService.getMaxCourseCode(str), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    //@PreAuthorize("hasAuthority('Course_P')")
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Course.jasper", params, response);
    }

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    //@PreAuthorize("hasAuthority('Course_P')")
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<CourseDTO.InfoPrint> searchRs = iCourseService.searchGeneric(searchRq, CourseDTO.InfoPrint.class);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/CourseByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @PostMapping(value = {"/GoalsAndSyllabus/{type}"})
    //@PreAuthorize("hasAuthority('Course_P')")
    public void printGoalsAndSyllabus(HttpServletResponse response,
                                      @PathVariable String type,
                                      @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
        final SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        final SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> searchRs = iCourseService.searchDetails(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/test.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = {"/printTest/{courseId}"})
    //@PreAuthorize("hasAuthority('Course_P')")
    public void printGoalsAndSyllabus(HttpServletResponse response, @PathVariable Long courseId) throws Exception {
        if(!workGroupService.isAllowUseId("Course",courseId)){
            return;
        }
        final Map<String, Object> params = new HashMap<>();
        String domain = iCourseService.getDomain(courseId);
        List<CourseDTO.Info> preCourseList = iCourseService.preCourseList(courseId);
        StringBuilder preCourse = new StringBuilder();
        StringBuilder equalCourse = new StringBuilder();
        for (CourseDTO.Info courseDTO : preCourseList) {
            preCourse.append(" - ").append(courseDTO.getTitleFa());
        }

        preCourse = new StringBuilder(!preCourse.toString().equals("") ? preCourse.substring(2) : "");
        List<EqualCourseDTO.Info> equalCourseList = iCourseService.equalCourseList(courseId);
        for (EqualCourseDTO.Info map : equalCourseList) {
            equalCourse.append("   یا   ").append(map.getNameEC());
        }
        equalCourse = new StringBuilder(!equalCourse.toString().equals("") ? equalCourse.substring(6) : "");
        CourseDTO.Info info = iCourseService.get(courseId);
        ERunType eRun = new ModelMapper().map(info.getERunType(), ERunType.class);
        ETheoType eTheo = new ModelMapper().map(info.getETheoType(), ETheoType.class);
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        params.put("courseId", courseId);
        params.put("domain", domain);
        params.put("preCourse", preCourse.toString());
        params.put("equalCourse", equalCourse.toString());
        params.put("eRun", eRun.getTitleFa());
        params.put("theo", eTheo.getTitleFa());
        reportUtil.export("/reports/test1.jasper", params, response);
    }

    @Loggable
    @GetMapping(value = "/get_teachers/{courseId}/{teacherId}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> getTeachers(@PathVariable Long courseId, @PathVariable Long teacherId) {
        List<TeacherDTO.TeacherFullNameTupleWithFinalGrade> infoList = new ArrayList<>();
        if (courseId != 0) {
            infoList = iCourseService.getTeachers(courseId, teacherId);
        }
        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specResponse.setData(infoList)
                .setStartRow(0)
                .setEndRow(infoList.size())
                .setTotalRows(infoList.size());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //---------------------heydari---------------------------
    @Loggable
    @PutMapping(value = "evaluation/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<CourseDTO.Info> updateEvaluation(@PathVariable Long id, @RequestBody Object request) {
        CourseDTO.Update update = modelMapper.map(request, CourseDTO.Update.class);
        return new ResponseEntity<>(iCourseService.updateEvaluation(id, update), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "courseWithOutClass")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<CourseDTO.WithOutClassSpecRs> getCourseWithOutClass(
                                                                                @RequestParam(value = "criteria", required = false) String criteria,
                                                                                @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        criteria = "[" + criteria + "]";
        criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.valueOf("and"))
                .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                }));
        request.setCriteria(criteriaRq);
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        final SearchDTO.SearchRs<CourseDTO.courseWithOutTeacher> response = iCourseService.courseWithOutTeacher(request);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        final CourseDTO.WithOutClassSpecRs specRs = new CourseDTO.WithOutClassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "getEvaluation/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    //TODO:Unknown
    public ResponseEntity<CourseDTO.SpecRs> getEvaluation(@PathVariable Long id) {
        List<CourseDTO.Info> list = iCourseService.getEvaluation(id);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getCourseMainObjective/{courseId}")
    //@PreAuthorize("hasAuthority('Course_WF')")
    public String getCourseMainObjective(@PathVariable Long courseId, HttpServletResponse response) throws IOException {

        if(!workGroupService.isAllowUseId("Course",courseId)) {

            return "";
        }
        StringBuilder mainObjective = new StringBuilder();
        List<Skill> skillList = skillService.skillList(courseId);

        for (Skill skill : skillList) {

            if (mainObjective.length() > 0)
                mainObjective.append("_");

            mainObjective.append(skill.getTitleFa());
        }

        return mainObjective.toString();
    }

    @Loggable
    @GetMapping(value = "/spec-safe-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseSpecRs> safelist(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                           @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
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
        SearchDTO.SearchRs<CourseDTO.TupleInfo> response = iCourseService.safeSearch(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/info-tuple-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseInfoTupleSpecRs> infoTupleList(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
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
        SearchDTO.SearchRs<CourseDTO.InfoTuple> response = iCourseService.searchInfoTuple(request);
        final CourseDTO.InfoTupleSpecRs specResponse = new CourseDTO.InfoTupleSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseInfoTupleSpecRs specRs = new CourseDTO.CourseInfoTupleSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @GetMapping(value = "/iscTupleList")
    public ResponseEntity<ISC<CourseDTO.CourseInfoTupleLite>> list(HttpServletRequest iscRq, @RequestParam(required = false) Long id) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (id != null) {
            searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, null));
        }
        SearchDTO.SearchRs<CourseDTO.CourseInfoTupleLite> searchRs = iCourseService.search(searchRq, i -> modelMapper.map(i, CourseDTO.CourseInfoTupleLite.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Override
    public CourseListResponse.Response targetMapping(Page<Course> searchResult, int startRow, int endRow) {
        CourseListResponse response = new CourseListResponse();
        response.setData(beanMapper.toCourseDtoList(searchResult.getContent()));
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Successful");
        response.setTotalRows(searchResult.getTotalElements());
        response.setStartRow(startRow);
        response.setEndRow(endRow);
        CourseListResponse.Response finalResponse = new CourseListResponse.Response();
        finalResponse.setResponse(response);
        return finalResponse;
    }

    @Override
    public SearchDTO.CriteriaRq getPermission(SearchDTO.SearchRq request) {
        return workGroupService.addPermissionToCriteria("categoryId", request.getCriteria());
    }

    @Override
    public SearchDTO.SearchRq mappedValues(SearchDTO.SearchRq request) {
        request.getCriteria().getCriteria().forEach(criteriaRq -> criteriaRq.getCriteria().forEach(cr-> {
                    if ("duration".equals(cr.getFieldName())) {
                        cr.setFieldName("theoryDuration");
                    }
                }
            ));
        if(request.getSortBy()!=null) {
            request.getSortBy().forEach(c -> {
                if ("duration".equals(c.getFieldName())) {
                    if (c.getDescendingSafe())
                        request.setSortBy("-theoryDuration");
                    else
                        request.setSortBy("theoryDuration");
                }
            });
        }
        return request;
    }

    @GetMapping(value = "/update-duration/{code}/{theoryDuration}")
    public BaseResponse updateDurationByCourseCode(@PathVariable String code, @PathVariable Float theoryDuration) {
        BaseResponse response = new BaseResponse();
        iCourseService.updateDurationByCourseCode(code, theoryDuration);
        response.setStatus(200);
        return response;
    }

    /**
     * returns audit infos for a course by course ID
     * @param courseId
     * @return
     */
    @Loggable
    @GetMapping(value = "/audit/{courseId}")
    public ResponseEntity<ISC<CourseDTO.InfoForAudit>> getCourseAuditData(@PathVariable Long courseId) {
        try {
            List<CourseAudit> courseAudits = iCourseAuditService.changeList(courseId);
            List<CourseDTO.InfoForAudit> dtos = courseBeanMapper.toAuditDtoList(courseAudits);

            SearchDTO.SearchRs<CourseDTO.InfoForAudit> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(dtos);
            searchRs.setTotalCount((long) courseAudits.size());

            ISC<CourseDTO.InfoForAudit> auditISC = ISC.convertToIscRs(searchRs, 0);
            return new ResponseEntity<>(auditISC, HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        }
    }

    @Loggable
    @GetMapping(value = "/add-permission/spec-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseSpecRs> listWithPermission(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) Long id,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        if (sortBy != null) {
            switch (sortBy) {
                case "duration" -> sortBy = "theoryDuration";
                case "-duration" -> sortBy = "-theoryDuration";
            }
        }

        SearchDTO.CriteriaRq criteriaRq = null;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<>() {
                    }));
            request.setCriteria(criteriaRq);

            if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
                for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                    if (criterion.getFieldName() != null) {
                        if (criterion.getFieldName().equals("duration")) {
                            criterion.setFieldName("theoryDuration");
                        }
                    }
                }
            }
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

        SearchDTO.CriteriaRq categoryCriteriaRq = criteriaUtil.addPermissionToCriteria("Category", "categoryId");
        SearchDTO.CriteriaRq subCategoryCriteriaRq = criteriaUtil.addPermissionToCriteria("SubCategory", "subCategoryId");

        List<SearchDTO.CriteriaRq> finalCriteriaRqs = new ArrayList<>();
        finalCriteriaRqs.add(categoryCriteriaRq);
        finalCriteriaRqs.add(subCategoryCriteriaRq);

        SearchDTO.CriteriaRq criteriaRq2 = CriteriaUtil.addCriteria(finalCriteriaRqs, EOperator.or);

        List<SearchDTO.CriteriaRq> finalCriteriaRqs2 = new ArrayList<>();
        finalCriteriaRqs2.add(criteriaRq2);

        if (criteriaRq != null) {
            finalCriteriaRqs2.add(criteriaRq);
        }

        if (operator == null) {
            SearchDTO.CriteriaRq criteriaRq3 = CriteriaUtil.addCriteria(finalCriteriaRqs2, EOperator.or);
            request.setCriteria(criteriaRq3);
        } else {
            SearchDTO.CriteriaRq criteria3 = CriteriaUtil.addCriteria(finalCriteriaRqs2, EOperator.valueOf(operator));
            request.setCriteria(criteria3);
        }

        SearchDTO.SearchRs<CourseDTO.Info> response = iCourseService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
