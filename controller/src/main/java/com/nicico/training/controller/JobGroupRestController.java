package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IPostService;
import com.nicico.training.service.BaseService;
import com.nicico.training.service.JobGroupService;
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
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/job-group")
public class JobGroupRestController {
    private final ReportUtil reportUtil;
    private final JobGroupService jobGroupService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;
    private final IPostService postService;
    private final IPersonnelService personnelService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_job_group')")
    public ResponseEntity<JobGroupDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(jobGroupService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_job_group')")
    public ResponseEntity<List<JobGroupDTO.Info>> list() {
        return new ResponseEntity<>(jobGroupService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<JobGroupDTO.Info>> list(HttpServletRequest iscRq, @RequestParam(value = "id", required = false) Long id) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, id, "id", EOperator.equals);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<JobGroupDTO.Info> searchRs = jobGroupService.searchWithoutPermission(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/postIscList/{id}")
    public ResponseEntity<ISC<PostDTO.Info>> postList(HttpServletRequest iscRq, @PathVariable(value = "id") Long id) throws IOException {
        List<JobDTO.Info> jobs = jobGroupService.getJobs(id);
        if (jobs.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, jobs.stream().filter(job -> job.getDeleted() == null).map(JobDTO.Info::getId).collect(Collectors.toList()), "job", EOperator.inSet);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/personnelIscList/{id}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> personnelList(HttpServletRequest iscRq, @PathVariable(value = "id") Long id) throws IOException {
        List<JobDTO.Info> jobs = jobGroupService.getJobs(id);
        if (jobs.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.CriteriaRq criteria=new SearchDTO.CriteriaRq();
        criteria.setOperator(EOperator.and);
        criteria.setCriteria(new ArrayList<>());

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteria);
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.job", jobs.stream().filter(job -> job.getDeleted() == null).map(JobDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.deleted", null, EOperator.isNull, null));
        SearchDTO.SearchRs<PostDTO.TupleInfo> postList = postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.TupleInfo.class));
        if (postList.getList() == null || postList.getList().isEmpty())
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        searchRq = ISC.convertToSearchRq(iscRq, postList.getList().stream().map(PostDTO.TupleInfo::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
        SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = personnelService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_job_group')")
    public ResponseEntity<JobGroupDTO.Info> create(@Validated @RequestBody JobGroupDTO.Create request) {
        return new ResponseEntity<>(jobGroupService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_job_group')")
    public ResponseEntity<JobGroupDTO.Info> update(@PathVariable Long id, @Validated @RequestBody JobGroupDTO.Update request) {
        return new ResponseEntity<>(jobGroupService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_job_group')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        jobGroupService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_job_group')")
    public ResponseEntity<Void> delete(@Validated @RequestBody JobGroupDTO.Delete request) {
        jobGroupService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_job_group')")
    public ResponseEntity<JobGroupDTO.JobGroupSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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


        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        BaseService.setCriteriaToNotSearchDeleted(request);
        SearchDTO.SearchRs<JobGroupDTO.Info> response = jobGroupService.searchWithoutPermission(request);

        final JobGroupDTO.SpecRs specResponse = new JobGroupDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final JobGroupDTO.JobGroupSpecRs specRs = new JobGroupDTO.JobGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_job_group')")
    public ResponseEntity<SearchDTO.SearchRs<JobGroupDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        BaseService.setCriteriaToNotSearchDeleted(request);
        return new ResponseEntity<>(jobGroupService.searchWithoutPermission(request), HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/addJob/{jobId}/{jobGroupId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> addJob(@PathVariable Long jobId, @PathVariable Long jobGroupId) {
        jobGroupService.addJob(jobId, jobGroupId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/addJobs/{jobGroupId}/{jobIds}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> addJobs(@PathVariable Long jobGroupId, @PathVariable Set<Long> jobIds) {
        jobGroupService.addJobs(jobGroupId, jobIds);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @DeleteMapping(value = "/removeJob/{jobGroupId}/{jobId}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removeJob(@PathVariable Long jobGroupId, @PathVariable Long jobId) {
        jobGroupService.removeJob(jobGroupId, jobId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/{jobGroupId}/unAttachJobs")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<ISC.Response<JobDTO.Info>> unAttachJobs(@PathVariable Long jobGroupId) {

        Set<JobDTO.Info> jobs;
        jobs = jobGroupService.unAttachJobs(jobGroupId);
        List<JobDTO.Info> jobList = new ArrayList<>();
        for (JobDTO.Info jobDTOInfo : jobs) {
            jobList.add(jobDTOInfo);
        }
        ISC.Response<JobDTO.Info> response = new ISC.Response<>();
        response.setData(jobList)
                .setStartRow(0)
                .setEndRow(jobList.size())
                .setTotalRows(jobList.size());

        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @Loggable
    @DeleteMapping(value = "/removeJobs/{jobGroupId}/{jobIds}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removeJobs(@PathVariable Long jobGroupId, @PathVariable Set<Long> jobIds) {
        jobGroupService.removeJobs(jobGroupId, jobIds);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/{jobGroupId}/getJobs")
//    @PreAuthorize("hasAnyAuthority('r_job_group')")
    public ResponseEntity<ISC> getJobs(@PathVariable Long jobGroupId) {
        List<JobDTO.Info> list = jobGroupService.getJobs(jobGroupId);
        ISC.Response<JobDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/printDetail/{type}/{id}"})
    public void printDetail(HttpServletResponse response, @PathVariable String type, @PathVariable Long id) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        params.put("todayDate", DateUtil.todayDate());
        JobGroupDTO.Info jobGroup = jobGroupService.get(id);
        params.put("titleFa", jobGroup.getTitleFa());
        params.put("description", jobGroup.getDescription());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(jobGroupService.getJobs(id)) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/jobGroupWithJobs.jasper", params, jsonDataSource, response);
    }


    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        params.put("todayDate", DateUtil.todayDate());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(jobGroupService.listTuple()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/jobGroups.jasper", params, jsonDataSource, response);
    }


    @Loggable
    @GetMapping(value = {"/printAll/{type}"})
    public void printAll(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/jobgroupwithjobs.jasper", params, response);
    }

    @Loggable
    @GetMapping(value = {"/printSelected/{type}/{jobGroupIds}"})
    public void printWithSelectedJobGroup(HttpServletResponse response, @PathVariable String type, @PathVariable String jobGroupIds) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        params.put("jobGroupIds", jobGroupIds);
        reportUtil.export("/reports/selectedJobGroup.jasper", params, response);
    }


//
//    @Loggable
//    @PostMapping(value = {"/printWithCriteria/{type}"})
//    public void printWithCriteria(HttpServletResponse response,
//                                  @PathVariable String type,
//                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
//
//        final SearchDTO.CriteriaRq criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
//        final SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
//
//        final SearchDTO.SearchRs<JobGroupDTO.Info> searchRs = jobGroupService.search(searchRq);
//
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//
//        final List<SearchDTO.CriteriaRq> criteriaRqList = criteriaRq.getCriteria();
//        criteriaRqList.forEach(criteriaRqFE -> {
//            switch (criteriaRqFE.getFieldName()) {
//                case "startDate":
//                    params.put("startDate", criteriaRqFE.getValue().toString());
//                    break;
//                case "endDate":
//                    params.put("endDate", criteriaRqFE.getValue().toString());
//                    break;
//                case "group":
//                    params.put("group", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//                case "course.id":
//                    params.put("course.id", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//                case "teacher.id":
//                    params.put("teacher.id", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//            }
//        });
//
//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
//    }
}
