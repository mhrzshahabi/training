package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 10:57 AM
*/

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IJobServiceOld;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/jobOld")
public class JobRestControllerOld {

    private final IJobServiceOld jobService;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;


    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<JobDTOOld.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(jobService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<JobDTOOld.Info>> list() {
        return new ResponseEntity<>(jobService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<JobDTOOld.Info> create(@Validated @RequestBody JobDTOOld.Create req) {
        try {
            jobService.create(req);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (Exception ex) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<JobDTOOld.Info> update(@PathVariable Long id, @RequestBody JobDTOOld.Update req) {
        return new ResponseEntity<>(jobService.update(id, req), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        jobService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody JobDTOOld.Delete req) {
        jobService.delete(req);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<JobDTOOld.IscRes> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<JobDTOOld.Info> response = jobService.search(request);

        final JobDTOOld.SpecRs specResponse = new JobDTOOld.SpecRs();
        final JobDTOOld.IscRes specRs = new JobDTOOld.IscRes();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

  /*  @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('job_r')")
    public ResponseEntity<JobDTO.IscRes> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<JobDTO.Info> response = jobService.search(request);

        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final JobDTO.IscRes specRs = new JobDTO.IscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }*/

    @Loggable
    @GetMapping(value = "/competence/{competenceId}/spec-list")
    public ResponseEntity<JobDTOOld.IscRes> list1(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<JobDTOOld.Info> response = jobService.search(request);

        final JobDTOOld.SpecRs specResponse = new JobDTOOld.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final JobDTOOld.IscRes specRs = new JobDTOOld.IscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{jobId}/job-competence/spec-list")
    public ResponseEntity<JobCompetenceDTO.IscRes> getJobCompetences(@PathVariable Long jobId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<JobCompetenceDTO.Info> list = jobService.getJobCompetence(jobId);

        final JobCompetenceDTO.SpecRs specResponse = new JobCompetenceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final JobCompetenceDTO.IscRes specRs = new JobCompetenceDTO.IscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/search")
//    @PreAuthorize("hasAuthority('job_r')")
    public ResponseEntity<SearchDTO.SearchRs<JobDTOOld.Info>> search(@RequestBody SearchDTO.SearchRq req) {
        return new ResponseEntity<>(jobService.search(req), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/competence/not/{competenceId}/spec-list")
    public ResponseEntity<JobDTOOld.IscRes> getOtherJobs(@PathVariable Long competenceId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<JobDTOOld.Info> list = jobService.getOtherJobs(competenceId);

        final JobDTOOld.SpecRs specResponse = new JobDTOOld.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final JobDTOOld.IscRes specRs = new JobDTOOld.IscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //---------------{hamed jafari}-----------

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

        final SearchDTO.SearchRs<JobDTOOld.Info> searchRs = jobService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/JobByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/{jobId}/skills/spec-list")
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkills(@PathVariable Long jobId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<SkillDTO.Info> list = jobService.getSkills(jobId);

        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{jobId}/skillGroups/spec-list")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getSkillGroups(@PathVariable Long jobId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<SkillGroupDTO.Info> list = jobService.getSkillGroups(jobId);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{jobId}/courses/spec-list")
    public ResponseEntity<CourseDTO.CourseSpecRs> getCourses(@PathVariable Long jobId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<CourseDTO.Info> list = jobService.getCourses(jobId);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}

