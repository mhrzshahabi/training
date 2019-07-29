package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 10:57 AM
*/

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.iservice.IJobService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/job")
public class JobRestController {

    private final IJobService jobService;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;


    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<JobDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(jobService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<JobDTO.Info>> list() {
        return new ResponseEntity<>(jobService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<JobDTO.Info> create(@Validated @RequestBody JobDTO.Create req) {
        try {
            jobService.create(req);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (Exception ex) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<JobDTO.Info> update(@PathVariable Long id, @RequestBody JobDTO.Update req) {
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
    public ResponseEntity<Void> delete(@Validated @RequestBody JobDTO.Delete req) {
        jobService.delete(req);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('job_r')")
    public ResponseEntity<JobDTO.iscRes> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<JobDTO.Info> response = jobService.search(request);

        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final JobDTO.iscRes specRs = new JobDTO.iscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/competence/{competenceId}/spec-list")
    public ResponseEntity<JobDTO.iscRes> list1(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<JobDTO.Info> response = jobService.search(request);

        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final JobDTO.iscRes specRs = new JobDTO.iscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{jobId}/job-competence/spec-list")
    public ResponseEntity<JobCompetenceDTO.iscRes> getJobCompetences(@PathVariable Long jobId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<JobCompetenceDTO.Info> list = jobService.getJobCompetence(jobId);

        final JobCompetenceDTO.SpecRs specResponse = new JobCompetenceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final JobCompetenceDTO.iscRes specRs = new JobCompetenceDTO.iscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/search")
//    @PreAuthorize("hasAuthority('job_r')")
    public ResponseEntity<SearchDTO.SearchRs<JobDTO.Info>> search(@RequestBody SearchDTO.SearchRq req) {
        return new ResponseEntity<>(jobService.search(req), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/competence/not/{competenceId}/spec-list")
    public ResponseEntity<JobDTO.iscRes> getOtherJobs(@PathVariable Long competenceId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<JobDTO.Info> list = jobService.getOtherJobs(competenceId);

        final JobDTO.SpecRs specResponse = new JobDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final JobDTO.iscRes specRs = new JobDTO.iscRes();
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

        final SearchDTO.SearchRs<JobDTO.Info> searchRs = jobService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/JobByCriteria.jasper", params, jsonDataSource, response);
    }

}

