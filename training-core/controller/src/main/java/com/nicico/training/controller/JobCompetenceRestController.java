package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 10:57 AM
*/

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.service.JobCompetenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/job-competence")
public class JobCompetenceRestController {

    private final JobCompetenceService jobCompetenceService;

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<JobCompetenceDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(jobCompetenceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
//    @PreAuthorize("hasAuthority('r_job')")
    public ResponseEntity<List<JobCompetenceDTO.Info>> list() {
        return new ResponseEntity<>(jobCompetenceService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping("/job")
    public ResponseEntity<Void> createFroJob(@RequestBody Object req) {
        JobCompetenceDTO.CreateForJob create = (new ModelMapper()).map(req, JobCompetenceDTO.CreateForJob.class);
        jobCompetenceService.createForJob(create);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @Loggable
    @PostMapping("/competence")
    public ResponseEntity<Void> createForCompetence(@RequestBody Object req) {
        JobCompetenceDTO.CreateForCompetence create = (new ModelMapper()).map(req, JobCompetenceDTO.CreateForCompetence.class);
        jobCompetenceService.createForCompetence(create);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping
    public ResponseEntity<Void> update(@RequestBody Object req) {
        JobCompetenceDTO.Update update = (new ModelMapper()).map(req, JobCompetenceDTO.Update.class);
        jobCompetenceService.update(update);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{jobId}/{competenceId}")
    public ResponseEntity<Void> delete(@PathVariable Long jobId, @PathVariable Long competenceId) {
        jobCompetenceService.delete(jobId, competenceId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody JobCompetenceDTO.Delete req) {
        jobCompetenceService.delete(req);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    @PreAuthorize("hasAuthority('r_job')")
    public ResponseEntity<JobCompetenceDTO.iscRes> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<JobCompetenceDTO.Info> response = jobCompetenceService.search(request);

        final JobCompetenceDTO.SpecRs specResponse = new JobCompetenceDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final JobCompetenceDTO.iscRes specRs = new JobCompetenceDTO.iscRes();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping("/search")
    public ResponseEntity<SearchDTO.SearchRs<JobCompetenceDTO.Info>> search(@RequestBody SearchDTO.SearchRq req) {
        return new ResponseEntity<>(jobCompetenceService.search(req), HttpStatus.OK);
    }

}

