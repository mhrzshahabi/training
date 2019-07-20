package com.nicico.training.controller;

import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.model.Competence;
import com.nicico.training.model.EducationLicense;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.EducationLicenseService;
import com.sun.xml.internal.bind.v2.model.core.Ref;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/course")
public class CourseRestController {

    private final HttpServletRequest request;
    private  final HttpServletResponse response;
    //------------------------------------------
    private final ReportUtil reportUtil;

    private final CourseService courseService;
    private final EducationLicenseService educationLicenseService;
    // ---------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_course')")
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
    @PostMapping
    public ResponseEntity<CourseDTO.Info> create(@RequestBody Object req) {
        CourseDTO.Create create = (new ModelMapper()).map(req, CourseDTO.Create.class);
        return new ResponseEntity<>(courseService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_course')")
//	public ResponseEntity<CourseDTO.Info> update(@PathVariable Long id,@Validated @RequestBody CourseDTO.Update request) {
//		return new ResponseEntity<>(courseService.update(id, request), HttpStatus.OK);
    public ResponseEntity<CourseDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        CourseDTO.Update update = (new ModelMapper()).map(request, CourseDTO.Update.class);
        return new ResponseEntity<>(courseService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_course')")
    public ResponseEntity<Void> delete(@PathVariable Long id){
    courseService.delete(id);
    return new ResponseEntity<>(HttpStatus.OK);
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
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
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
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkill(@PathVariable Long courseId)
    {
        List<SkillDTO.Info> skill = courseService.getSkill(courseId);
        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        specResponse.setData(skill)
                .setStartRow(0)
                .setEndRow(skill.size())
                .setTotalRows(skill.size());
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs,HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/job/{courseId}")
    public ResponseEntity<JobDTO.iscRes> getJob(@PathVariable Long courseId)
    {
        List<JobDTO.Info> job = courseService.getJob(courseId);
        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(job)
                .setStartRow(0)
                .setEndRow(job.size())
                .setTotalRows(job.size());
        final JobDTO.iscRes specRs = new JobDTO.iscRes();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs,HttpStatus.OK);
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
    public ResponseEntity<String> getMaxCourseCode(@PathVariable String str)
    {
       return new ResponseEntity<>(courseService.getMaxCourseCode(str),HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getcompetence/{courseId}")
    public  ResponseEntity<CompetenceDTO.SpecRs> getCompetence(@PathVariable Long courseId)
    {
        List <CompetenceDTO.Info> comList=courseService.getCompetence(courseId);
        final  CompetenceDTO.SpecRs specResponse=new CompetenceDTO.SpecRs();
        specResponse.setData(comList)
                .setStartRow(0)
                .setEndRow(comList.size())
                .setTotalRows(comList.size());
        final CompetenceDTO.CompetenceSpecRs competenceSpecRs=new CompetenceDTO.CompetenceSpecRs();
        competenceSpecRs.setResponse(specResponse);
        return  new ResponseEntity(competenceSpecRs,HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value ="/getcompetencequery/{courseId}")
    public  ResponseEntity<CompetenceDTO.SpecRs> getCompetencequery(@PathVariable Long courseId)
    {
        List <CompetenceDTO.Info> comList=courseService.getCompetenceQuery(courseId);
        final  CompetenceDTO.SpecRs specResponse=new CompetenceDTO.SpecRs();
        specResponse.setData(comList)
                .setStartRow(0)
                .setEndRow(comList.size())
                .setTotalRows(comList.size());
        final CompetenceDTO.CompetenceSpecRs competenceSpecRs=new CompetenceDTO.CompetenceSpecRs();
        competenceSpecRs.setResponse(specResponse);
        return  new ResponseEntity(comList,HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value ="/getlistEducationLicense" )
    public ResponseEntity<EducationLicenseDTO.SpecRs> getlistEducation()
    {
        List<EducationLicenseDTO.Info> educationInfo=educationLicenseService.list();
        final EducationLicenseDTO.SpecRs specResponse = new EducationLicenseDTO.SpecRs();
        specResponse.setData(educationInfo).setStartRow(0).setEndRow(educationInfo.size()).setTotalRows(educationInfo.size());
        final EducationLicenseDTO.EducationLicenseSpecRs educationLicenseSpecRs=new EducationLicenseDTO.EducationLicenseSpecRs();
        educationLicenseSpecRs.setResponse(specResponse);
        return new ResponseEntity(educationLicenseSpecRs,HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Course.jasper", params, response);
    }
}
