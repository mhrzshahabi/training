package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/9/2019
@Time :10:41 AM
    */

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.service.SkillService;

import com.nicico.training.service.WorkGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.nicico.training.service.BaseService.makeNewCriteria;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/skill")
public class SkillRestController {

    private final ReportUtil reportUtil;
    private final ISkillService iSkillService;
    private final IWorkGroupService workGroupService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SkillDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(iSkillService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/main-objective/{mainObjectiveId}")
//    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<List<SkillDTO>> list(@PathVariable Long mainObjectiveId) {
        return new ResponseEntity<>(iSkillService.listMainObjective(mainObjectiveId), HttpStatus.OK);
    }


    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_skill')")
    public ResponseEntity<SkillDTO.Info> create(@RequestBody Object request, HttpServletResponse response) {
        SkillDTO.Create create = (new ModelMapper()).map(request, SkillDTO.Create.class);
        try {
            create.setCode(iSkillService.getMaxSkillCode(create.getCode()));
            return new ResponseEntity<>(iSkillService.create(create, response), HttpStatus.CREATED);


        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }

    }

    @Loggable
    @GetMapping(value = "/getMaxSkillCode/{code}")
    public String MaxSkillCode(@PathVariable String code) throws Exception {
        return iSkillService.getMaxSkillCode(code);
    }

    @Loggable
    @GetMapping(value = "/editSkill/{id}")
    public boolean editSkill(@PathVariable Long id) throws Exception {
        return iSkillService.editSkill(id);
    }


    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_skill')")
    public ResponseEntity<SkillDTO.Info> update(@PathVariable Long id, @RequestBody Object request,HttpServletResponse response) {
        return new ResponseEntity<>(iSkillService.update(id,request,response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_skill')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {

        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
//            flag = iSkillService.isSkillDeletable(id);
//            if (flag)

            if(workGroupService.isAllowUseId("Skill",id)){
                iSkillService.delete(id);
            }else{
                flag = false;
                httpStatus = HttpStatus.UNAUTHORIZED;
            }

        } catch (Exception e) {
            flag = false;
            httpStatus = HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }


    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_skill')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody SkillDTO.Delete request) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            flag = true;
            for (Long id : request.getIds()) {
                if (!iSkillService.isSkillDeletable(id)) {
                    flag = false;
                    break;
                }
            }
//            flag=iSkillService.isSkillDeletable(id);
            if (flag)
                iSkillService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }


    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SkillDTO.SkillSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                     @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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

        request.setCriteria(workGroupService.addPermissionToCriteria("categoryId", request.getCriteria()));

        SearchDTO.SearchRs<SkillDTO.Info> response = iSkillService.searchWithoutPermission(request);

        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "WFC/spec-list")
//    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SkillDTO.SkillSpecRs> listWithFullCourse(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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
        SearchDTO.SearchRs<SkillDTO.InfoENA> response = iSkillService.searchGeneric(request, SkillDTO.InfoENA.class);
        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_skill')")
    public ResponseEntity<SearchDTO.SearchRs<SkillDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(iSkillService.searchWithoutPermission(request), HttpStatus.OK);
    }

    // ------------------------------


    @Loggable
    @GetMapping(value = "{skillId}/courses")
//    @PreAuthorize("hasAnyAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getCourse(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CourseDTO.Info> courses = new ArrayList<>();
        courses.add(iSkillService.getCourses(skillId));

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

        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        List<CourseDTO.Info> courses = iSkillService.getUnAttachedCourses(skillId, pageable);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(iSkillService.getUnAttachedCoursesCount(skillId));

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/courses")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<CourseDTO.CourseSpecRs> getAttachedCourses(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<CourseDTO.Info> courses = new ArrayList<>();
        courses.add(iSkillService.getCourses(skillId));

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

        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);


        List<CourseDTO.Info> courses = iSkillService.getUnAttachedCourses(skillId, pageable);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(courses)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(iSkillService.getUnAttachedCoursesCount(skillId));

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-course/{courseId}/{skillId}")
    public ResponseEntity<Boolean> removeCourse(@PathVariable Long courseId, @PathVariable Long skillId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            iSkillService.removeCourse(courseId, skillId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/remove-course-list/{courseIds}/{skillId}")
    public ResponseEntity<Boolean> removeCourses(@PathVariable List<Long> courseIds, @PathVariable Long skillId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            iSkillService.removeCourses(courseIds, skillId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/add-course/{courseId}/{skillId}")
    public ResponseEntity<Boolean> addCourse(@PathVariable Long courseId, @PathVariable Long skillId, HttpServletResponse resp) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            iSkillService.addCourse(courseId, skillId, resp);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/add-course-list/{skillId}")
    public ResponseEntity<Boolean> addCourses(@Validated @RequestBody CourseDTO.CourseIdList request, @PathVariable Long skillId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            iSkillService.addCourses(request.getIds(), skillId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }


    @Loggable
    @GetMapping(value = "/course-dummy")
//    @PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> courseDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<CourseDTO.CourseSpecRs>(new CourseDTO.CourseSpecRs(), HttpStatus.OK);
    }


    @Loggable
    // @GetMapping(value = {"/print-all/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Print_All_Skill.jasper", params, response);
//        reportUtil.export("/reports/skillGroup.jasper", params, response);

    }

    @Loggable
    @PostMapping(value = {"/print-all/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "_sortBy") String sortBy,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        JSONObject jsonObject = new JSONObject(sortBy);
        String field = jsonObject.getString("property");
        String direction = jsonObject.getString("direction");
        if (direction.equals("descending")) {
            field = "-" + field;
        }
        searchRq.setSortBy(field);

        searchRq.setCriteria(workGroupService.addPermissionToCriteria("categoryId", searchRq.getCriteria()));
        SearchDTO.SearchRs<SkillDTO.Info> searchSkill = iSkillService.searchWithoutPermission(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchSkill.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Skill_Report.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/skillthisCourse")
    public ResponseEntity<ISC<SkillDTO.Info>> spectListAllClass(HttpServletRequest iscRq, @RequestParam Long categoryId) throws IOException {
        return search2(iscRq, makeNewCriteria(null, null, EOperator.or, null), SkillDTO.Info.class, categoryId);
    }

    private <T> ResponseEntity<ISC<T>> search2(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Class<T> infoType, Long categoryId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("categoryId", iscRq.getParameter("categoryId"), EOperator.equals, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        criteriaRq.getCriteria().add(criteriaRq1);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = iSkillService.search(searchRq, infoType);
        return new ResponseEntity<ISC<T>>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/postsWithSameSkill/{skillId}")
    public ResponseEntity<ViewTrainingPostDTO.PostSpecRs> getPostsContainsTheSkill(@PathVariable Long skillId) {
        SearchDTO.SearchRs<ViewTrainingPostDTO.Report> response = iSkillService.getPostsContainsTheSkill(skillId);

        final ViewTrainingPostDTO.SpecRs specResponse = new ViewTrainingPostDTO.SpecRs();
        final ViewTrainingPostDTO.PostSpecRs specRs = new ViewTrainingPostDTO.PostSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{skillId}/{mainObjectiveId}")
    public boolean updateMainObjectiveId(@PathVariable Long skillId, @PathVariable Long mainObjectiveId) {
        return iSkillService.updateMainObjectiveId(skillId, mainObjectiveId);
    }
}
