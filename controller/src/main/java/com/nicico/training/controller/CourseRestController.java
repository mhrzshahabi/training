package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ERunTypeDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETheoType;
import com.nicico.training.service.CourseService;
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
@RequestMapping(value = "/api/course")
public class CourseRestController {
    //------------------------------------------
    private final ReportUtil reportUtil;
    private final CourseService courseService;
    private final ICourseService iCourseService;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;

    // ---------------------------------
    @Loggable
    @GetMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<CourseDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(courseService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<List<CourseDTO.Info>> list() {
        return new ResponseEntity<>(courseService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/preCourse/{courseId}")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<List<CourseDTO.Info>> preCourseList(@PathVariable Long courseId) {
        List<CourseDTO.Info> list = courseService.preCourseList(courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/equalCourse/{courseId}")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<List<Map>> equalCourseList(@PathVariable Long courseId) {
        List<Map> list = courseService.equalCourseList(courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CourseDTO.Info> create(@RequestBody Object req) {
        CourseDTO.Create create = (new ModelMapper()).map(req, CourseDTO.Create.class);
        return new ResponseEntity<>(courseService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('u_course')")
//	public ResponseEntity<CourseDTO.Info> update(@PathVariable Long id,@Validated @RequestBody CourseDTO.Update request) {
//		return new ResponseEntity<>(courseService.update(id, request), HttpStatus.OK);
    public ResponseEntity<CourseDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        CourseDTO.Update update = (new ModelMapper()).map(request, CourseDTO.Update.class);
        return new ResponseEntity<>(courseService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "deleteCourse/{id}")
    //@PreAuthorize("hasAuthority('d_course')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean check = courseService.checkForDelete(id);
        if (check) {
            courseService.deletGoal(id);
            courseService.delete(id);

        }

        // courseService.delete(id);
        return new ResponseEntity<>(check, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_course')")
    public ResponseEntity<Void> delete(@Validated @RequestBody CourseDTO.Delete request) {
        courseService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                       @RequestParam("_endRow") Integer endRow,
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

        SearchDTO.SearchRs<CourseDTO.Info> response = courseService.search(request);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<SearchDTO.SearchRs<CourseDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(courseService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{courseId}/goal")
    public ResponseEntity<GoalDTO.GoalSpecRs> getGoal(@PathVariable Long courseId) {

//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<GoalDTO.Info> goal = courseService.getgoal(courseId);

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
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkill(@PathVariable Long courseId) {
        List<SkillDTO.Info> skill = courseService.getSkill(courseId);
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
    @GetMapping(value = "/skill-group/{courseId}")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getSkillGroup(@PathVariable Long courseId) {
        List<SkillGroupDTO.Info> skillGroup = courseService.getSkillGroup(courseId);
        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(skillGroup)
                .setStartRow(0)
                .setEndRow(skillGroup.size())
                .setTotalRows(skillGroup.size());
        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/job/{courseId}")
    public ResponseEntity<ISC.Response> getJob(@PathVariable Long courseId){
        List<JobDTO.Info> job = courseService.getJob(courseId);
        ISC.Response response = new ISC.Response();
        response.setData(job)
                .setStartRow(0)
                .setEndRow(job.size())
                .setTotalRows(job.size());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/post/{courseId}")
    public ResponseEntity<ISC.Response> getPost(@PathVariable Long courseId){
        List<PostDTO.Info> post = courseService.getPost(courseId);
        ISC.Response response = new ISC.Response();
        response.setData(post)
                .setStartRow(0)
                .setEndRow(post.size())
                .setTotalRows(post.size());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{courseId}/{goalIdList}")
//	@PreAuthorize("hasAuthority('d_course')")
    public ResponseEntity<Void> getCourseIdvGoalsId(@PathVariable Long courseId, @PathVariable List<Long> goalIdList) {
        courseService.getCourseIdvGoalsId(courseId, goalIdList);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/remove/{courseId}/{goalIdList}")
//	@PreAuthorize("hasAuthority('d_course')")
    public ResponseEntity<Void> removeCourseSGoal(@PathVariable Long courseId, @PathVariable List<Long> goalIdList) {
        courseService.removeCourseSGoal(courseId, goalIdList);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/goal/{courseId}")
    public ResponseEntity<GoalDTO.GoalSpecRs> getGoalWithOut(@PathVariable Long courseId) {
        List<GoalDTO.Info> goal = courseService.getGoalWithOut(courseId);
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
    public ResponseEntity<String> getMaxCourseCode(@PathVariable String str) {
        return new ResponseEntity<>(courseService.getMaxCourseCode(str), HttpStatus.OK);
    }

//    @Loggable
//    @GetMapping(value = "/getcompetence/{courseId}")
//    public ResponseEntity<CompetenceDTO.SpecRs> getCompetence(@PathVariable Long courseId) {
//        List<CompetenceDTO.Info> comList = courseService.getCompetence(courseId);
//        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
//        specResponse.setData(comList)
//                .setStartRow(0)
//                .setEndRow(comList.size())
//                .setTotalRows(comList.size());
//        final CompetenceDTO.CompetenceSpecRs competenceSpecRs = new CompetenceDTO.CompetenceSpecRs();
//        competenceSpecRs.setResponse(specResponse);
//        return new ResponseEntity(competenceSpecRs, HttpStatus.OK);
//    }

//    @Loggable
//    @GetMapping(value = "/getcompetencequery/{courseId}")
//    public ResponseEntity<CompetenceDTO.SpecRs> getCompetencequery(@PathVariable Long courseId) {
//        List<CompetenceDTO.Info> comList = courseService.getCompetenceQuery(courseId);
//        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
//        specResponse.setData(comList)
//                .setStartRow(0)
//                .setEndRow(comList.size())
//                .setTotalRows(comList.size());
//        final CompetenceDTO.CompetenceSpecRs competenceSpecRs = new CompetenceDTO.CompetenceSpecRs();
//        competenceSpecRs.setResponse(specResponse);
//        return new ResponseEntity(comList, HttpStatus.OK);
//    }


//    @Loggable
//    @GetMapping(value ="/getlistEducationLicense" )
//    public ResponseEntity<EducationLicenseDTO.SpecRs> getlistEducation()
//    {
//        List<EducationLicenseDTO.Info> educationInfo=educationLicenseService.list();
//        final EducationLicenseDTO.SpecRs specResponse = new EducationLicenseDTO.SpecRs();
//        specResponse.setData(educationInfo).setStartRow(0).setEndRow(educationInfo.size()).setTotalRows(educationInfo.size());
//        final EducationLicenseDTO.EducationLicenseSpecRs educationLicenseSpecRs=new EducationLicenseDTO.EducationLicenseSpecRs();
//        educationLicenseSpecRs.setResponse(specResponse);
//        return new ResponseEntity(educationLicenseSpecRs,HttpStatus.OK);
//    }

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Course.jasper", params, response);
    }


    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
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

        final SearchDTO.SearchRs<CourseDTO.Info> searchRs = courseService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/CourseByCriteria.jasper", params, jsonDataSource, response);
    }


    @Loggable
    @PostMapping(value = {"/GoalsAndSyllabus/{type}"})
    public void printGoalsAndSyllabus(HttpServletResponse response,
                                      @PathVariable String type,
                                      @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
        final SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        final SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> searchRs = iCourseService.searchDetails(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/test.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = {"/printTest/{courseId}"})
    public void printGoalsAndSyllabus(HttpServletResponse response,@PathVariable Long courseId) throws Exception {
        final Map<String, Object> params = new HashMap<>();
        CourseDTO.Info info = courseService.get(courseId);
        String domain = "دانشی: " + info.getKnowledge() + "%     " + "نگرشی: " + info.getAttitude() + "%    " + "مهارتی: " + info.getSkill() + "%";
        List<CourseDTO.Info> preCourseList = courseService.preCourseList(courseId);
        String preCourse = "";
        String equalCourse = "";
        for (CourseDTO.Info courseDTO : preCourseList) {
            preCourse = preCourse + " - " + courseDTO.getTitleFa();
        }
        preCourse = preCourse != "" ? preCourse.substring(2) : "";
        List<Map> equalCourseList = courseService.equalCourseList(courseId);
        for (Map map : equalCourseList) {
            equalCourse = equalCourse + "   یا   " + map.get("nameEC");
        }
        equalCourse = equalCourse != "" ? equalCourse.substring(6) : "";
        ERunType eRun = new ModelMapper().map(info.getERunType(), ERunType.class);
        ETheoType eTheo = new ModelMapper().map(info.getETheoType(), ETheoType.class);
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        params.put("courseId", courseId);
        params.put("domain", domain);
        params.put("preCourse",preCourse);
        params.put("equalCourse", equalCourse);
        params.put("eRun", eRun.getTitleFa());
        params.put("theo",eTheo.getTitleFa());
        reportUtil.export("/reports/test1.jasper", params, response);
    }
}
