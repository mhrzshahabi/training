package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/9/2019
@Time :10:41 AM
    */

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.EOperator;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ISkillService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//import com.nicico.copper.core.util.report.ReportUtil;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/skill")
public class SkillRestController {

    private final ReportUtil reportUtil;
    private final ISkillService skillService;
    private final ObjectMapper objectMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SkillDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(skillService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<List<SkillDTO.Info>> list() {
        return new ResponseEntity<>(skillService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    @PreAuthorize("hasAuthority('c_skill')")
    public ResponseEntity<SkillDTO.Info> create(@RequestBody Object request) {
        String maxSkillCode = "";
        String newSkillCode = "";
        Integer maxId;
        SkillDTO.Create create = (new ModelMapper()).map(request, SkillDTO.Create.class);
        try {
            maxSkillCode = skillService.getMaxSkillCode(create.getCode());
            if (maxSkillCode == null || (maxSkillCode.length() != 8 && !maxSkillCode.equals("0")))
                   throw new Exception("Skill with this Code wrong");
            maxId =maxSkillCode.equals("0")?0:Integer.parseInt(maxSkillCode.substring(4));
            maxId++;
            newSkillCode = create.getCode() + String.format("%04d", maxId);
            create.setCode(newSkillCode);
            return new ResponseEntity<>(skillService.create(create), HttpStatus.CREATED);

        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);

        }

    }

    @Loggable
    @PutMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('u_skill')")
    public ResponseEntity<SkillDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
//		SkillDTO.Update u=new SkillDTO.Update();
//        ModelMapper m=new ModelMapper();
//	    SkillDTO.Update update = m.map(request, SkillDTO.Update.class);
        return new ResponseEntity<>(skillService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('d_skill')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {

        boolean flag=false;
        HttpStatus httpStatus=HttpStatus.OK;

        try {
        flag=skillService.isSkillDeletable(id);
        if(flag)
            skillService.delete(id);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    @PreAuthorize("hasAuthority('d_skill')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody SkillDTO.Delete request) {
        boolean flag=false;
        HttpStatus httpStatus=HttpStatus.OK;

        try {
            flag=true;
            for (Long id : request.getIds() ) {
                if(!skillService.isSkillDeletable(id)){
                    flag=false;
                    break;
                }
            }
//            flag=skillService.isSkillDeletable(id);
            if(flag)
                skillService.delete(request);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SkillDTO.SkillSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

            if (StringUtils.isNotEmpty(sortBy)) {
                request.set_sortBy(sortBy);
            }

            request.setCriteria(criteriaRq);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<SkillDTO.Info> response = skillService.search(request);

        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SearchDTO.SearchRs<SkillDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(skillService.search(request), HttpStatus.OK);
    }

    // ------------------------------


    // skill group methods ------------------------------------------------------------------------------------------------


    @Loggable
    @GetMapping(value = "{skillId}/skill-groups")
    @PreAuthorize("hasAnyAuthority('r_skill_group')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getSkillGroups(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SkillGroupDTO.Info> skillGroups = skillService.getSkillGroups(skillId);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(skillGroups)
                .setStartRow(0)
                .setEndRow(skillGroups.size())
                .setTotalRows(skillGroups.size());

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{skillId}/unattached-skill-groups")
    @PreAuthorize("hasAnyAuthority('r_skill_group')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getUnAttachedSkillGroups(@RequestParam("_startRow") Integer startRow,
                                                                                   @RequestParam("_endRow") Integer endRow,
                                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy,@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);

        List<SkillGroupDTO.Info> skillGroups = skillService.getUnAttachedSkillGroups(skillId,pageable);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(skillGroups)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedSkillGroupsCount(skillId));

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/skill-groups")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getAttachedSkillGroups(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<SkillGroupDTO.Info> skillGroupList = skillService.getSkillGroups(skillId);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(skillGroupList)
                .setStartRow(0)
                .setEndRow(skillGroupList.size())
                .setTotalRows(skillGroupList.size());

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/unattached-skill-groups")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getOtherSkillGroups(@RequestParam("_startRow") Integer startRow,
                                                                              @RequestParam("_endRow") Integer endRow,
                                                                              @RequestParam(value = "_constructor", required = false) String constructor,
                                                                              @RequestParam(value = "operator", required = false) String operator,
                                                                              @RequestParam(value = "criteria", required = false) String criteria,
                                                                              @RequestParam(value = "_sortBy", required = false) String sortBy
                                                                              ,@RequestParam("skillId") String skillID) {



        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);
        Long skillId = Long.parseLong(skillID);

        List<SkillGroupDTO.Info> skillGroups = skillService.getUnAttachedSkillGroups(skillId,pageable);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(skillGroups)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedSkillGroupsCount(skillId));

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-skill-group/{skillGroupId}/{skillId}")
    public ResponseEntity<Void> removeSkillGroup(@PathVariable Long skillGroupId, @PathVariable Long skillId) {
        skillService.removeSkillGroup(skillGroupId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-skill-group-list/{skillGroupIds}/{skillId}")
    public ResponseEntity<Void> removeSkillGroups(@PathVariable List<Long> skillGroupIds, @PathVariable Long skillId) {
        skillService.removeSkillGroups(skillGroupIds, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-skill-group/{skillGroupId}/{skillId}")
    public ResponseEntity<Void> addSkillGroup(@PathVariable Long skillGroupId, @PathVariable Long skillId) {
        skillService.addSkillGroup(skillGroupId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-skill-group-list/{skillId}")
    public ResponseEntity<Void> addSkillGroups(@Validated @RequestBody SkillGroupDTO.SkillGroupIdList request, @PathVariable Long skillId) {
        skillService.addSkillGroups(request.getIds(), skillId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/skill-group-dummy")
    @PreAuthorize("hasAuthority('r_skill_group')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> skillGroupDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<SkillGroupDTO.SkillGroupSpecRs>(new SkillGroupDTO.SkillGroupSpecRs(), HttpStatus.OK);
    }

    // Competence methods ------------------------------------------------------------------------------------------------

    @Loggable
    @GetMapping(value = "{skillId}/competences")
//    @PreAuthorize("hasAnyAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getCompetences(@PathVariable Long skillId) {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CompetenceDTO.Info> competences = skillService.getCompetences(skillId);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(competences)
                .setStartRow(0)
                .setEndRow(competences.size())
                .setTotalRows(competences.size());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }





    @Loggable
    @GetMapping(value = "{skillId}/unattached-competences")
//    @PreAuthorize("hasAnyAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getUnAttachedCompetences(@RequestParam("_startRow") Integer startRow,
                                                                                   @RequestParam("_endRow") Integer endRow,
                                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                                   @PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();


        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);




        List<CompetenceDTO.Info> competences = skillService.getUnAttachedCompetences(skillId,pageable);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(competences)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedCompetencesCount(skillId));

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/competences")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getAttachedCompetences(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<CompetenceDTO.Info> competences = skillService.getCompetences(skillId);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(competences)
                .setStartRow(0)
                .setEndRow(competences.size())
                .setTotalRows(competences.size());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/unattached-competences")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getOtherCompetences(@RequestParam("_startRow") Integer startRow,
                                                                              @RequestParam("_endRow") Integer endRow,
                                                                              @RequestParam(value = "_constructor", required = false) String constructor,
                                                                              @RequestParam(value = "operator", required = false) String operator,
                                                                              @RequestParam(value = "criteria", required = false) String criteria,
                                                                              @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                              @RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);

        List<CompetenceDTO.Info> competences = skillService.getUnAttachedCompetences(skillId,pageable);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(competences)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedCompetencesCount(skillId));

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-competence/{competenceId}/{skillId}")
    public ResponseEntity<Void> removeCompetence(@PathVariable Long competenceId, @PathVariable Long skillId) {
        skillService.removeCompetence(competenceId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-competence-list/{competenceIds}/{skillId}")
    public ResponseEntity<Void> removeCompetences(@PathVariable List<Long> competenceIds, @PathVariable Long skillId) {
        skillService.removeCompetences(competenceIds, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-competence/{competenceId}/{skillId}")
    public ResponseEntity<Void> addCompetence(@PathVariable Long competenceId, @PathVariable Long skillId) {
        skillService.addCompetence(competenceId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-competence-list/{skillId}")
    public ResponseEntity<Void> addCompetences(@Validated @RequestBody CompetenceDTO.CompetenceIdList request, @PathVariable Long skillId) {
        skillService.addCompetences(request.getIds(), skillId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/competence-dummy")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> competenceDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<CompetenceDTO.CompetenceSpecRs>(new CompetenceDTO.CompetenceSpecRs(), HttpStatus.OK);
    }


    // Course methods ------------------------------------------------------------------------------------------------

    @Loggable
    @GetMapping(value = "{skillId}/courses")
//    @PreAuthorize("hasAnyAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getCourses(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CourseDTO.Info> courses = skillService.getCourses(skillId);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(0)
                .setEndRow(courses.size())
                .setTotalRows(courses.size());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{skillId}/unattached-courses")
//    @PreAuthorize("hasAnyAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getUnAttachedCourses(@RequestParam("_startRow") Integer startRow,
                                                                       @RequestParam("_endRow") Integer endRow,
                                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                                       @RequestParam(value = "operator", required = false) String operator,
                                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                                       @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                       @PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();


        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);

        List<CourseDTO.Info> courses = skillService.getUnAttachedCourses(skillId,pageable);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedCoursesCount(skillId));

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/courses")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getAttachedCourses(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<CourseDTO.Info> courses = skillService.getCourses(skillId);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(0)
                .setEndRow(courses.size())
                .setTotalRows(courses.size());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/unattached-courses")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getOtherCourses(@RequestParam("_startRow") Integer startRow,
                                                                  @RequestParam("_endRow") Integer endRow,
                                                                  @RequestParam(value = "_constructor", required = false) String constructor,
                                                                  @RequestParam(value = "operator", required = false) String operator,
                                                                  @RequestParam(value = "criteria", required = false) String criteria,
                                                                  @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                  @RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        Integer pageSize=endRow-startRow;
        Integer pageNumber=(endRow-1)/pageSize;
        Pageable pageable= PageRequest.of(pageNumber,pageSize);


        List<CourseDTO.Info> courses = skillService.getUnAttachedCourses(skillId,pageable);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(skillService.getUnAttachedCoursesCount(skillId));

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-course/{courseId}/{skillId}")
    public ResponseEntity<Void> removeCourse(@PathVariable Long courseId, @PathVariable Long skillId) {
        skillService.removeCourse(courseId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-course-list/{courseIds}/{skillId}")
    public ResponseEntity<Void> removeCourses(@PathVariable List<Long> courseIds, @PathVariable Long skillId) {
        skillService.removeCourses(courseIds, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-course/{courseId}/{skillId}")
    public ResponseEntity<Void> addCourse(@PathVariable Long courseId, @PathVariable Long skillId) {
        skillService.addCourse(courseId, skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-course-list/{skillId}")
    public ResponseEntity<Void> addCourses(@Validated @RequestBody CourseDTO.CourseIdList request, @PathVariable Long skillId) {
        skillService.addCourses(request.getIds(), skillId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/course-dummy")
//    @PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> courseDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<CourseDTO.CourseSpecRs>(new CourseDTO.CourseSpecRs(), HttpStatus.OK);
    }

    // Job methods ------------------------------------------------------------------------------------------------

    @Loggable
    @GetMapping(value = "{skillId}/jobs")
//    @PreAuthorize("hasAnyAuthority('r_competence')")
    public ResponseEntity<JobDTO.iscRes> getJobs(@PathVariable Long skillId) {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<JobDTO.Info> competences = skillService.getJobs(skillId);

        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(competences)
                .setStartRow(0)
                .setEndRow(competences.size())
                .setTotalRows(competences.size());

        final JobDTO.iscRes specRs = new JobDTO.iscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/job-dummy")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<JobDTO.iscRes> jobDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<JobDTO.iscRes>(new JobDTO.iscRes(), HttpStatus.OK);
    }

    // ------------------------------------------------------------------------------------------------


    @Loggable
    @GetMapping(value = {"/print-all/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Print_All_Skill.jasper", params, response);
    }


}
