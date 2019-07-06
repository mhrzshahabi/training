package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:26 PM
*/

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;
import com.nicico.training.service.CompetenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final CompetenceService competenceService;

    @Loggable
    @GetMapping("/{id}")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(competenceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<List<CompetenceDTO.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_competence')")
    public ResponseEntity<CompetenceDTO.Info> create(@RequestBody Object req) {
        CompetenceDTO.Create create = (new ModelMapper()).map(req, CompetenceDTO.Create.class);
        return new ResponseEntity<>(competenceService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
//    @PreAuthorize("hasAuthority('u_competence')")
    public ResponseEntity<CompetenceDTO.Info> update(@PathVariable Long id, @RequestBody Object req) {
        CompetenceDTO.Update update = (new ModelMapper()).map(req, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
//    @PreAuthorize("hasAuthority('d_competence')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        competenceService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/list")
//    @PreAuthorize("hasAuthority('d_competence')")
    public ResponseEntity<Void> delete(@Validated @RequestBody CompetenceDTO.Delete req) {
        competenceService.delete(req);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<CompetenceDTO.Info> response = competenceService.search(request);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}/spec")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> get(@PathVariable long id, @RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<CompetenceDTO.Info> list = new ArrayList<>();
        list.add(competenceService.get(id));

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/job/not/{jobId}/spec-list")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getOtherCompetences(@PathVariable Long jobId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<CompetenceDTO.Info> list = competenceService.getOtherCompetence(jobId);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/search")
//    @PreAuthorize("hasAuthority('r_competence')")
    public ResponseEntity<SearchDTO.SearchRs<CompetenceDTO.Info>> search(@RequestBody SearchDTO.SearchRq req) {
        return new ResponseEntity<>(competenceService.search(req), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{competenceId}/job-competence/spec-list")
    public ResponseEntity<JobCompetenceDTO.iscRes> getJobCompetences(@PathVariable Long competenceId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<JobCompetenceDTO.Info> list = competenceService.getJobCompetence(competenceId);

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
    @GetMapping(value = "/{competenceId}/skills/spec-list")
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkills(@PathVariable Long competenceId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<SkillDTO.Info> list = competenceService.getSkills(competenceId);

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
    @GetMapping(value = "/{competenceId}/skillGroups/spec-list")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getSkillGroups(@PathVariable Long competenceId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        List<SkillGroupDTO.Info> list = competenceService.getSkillGroups(competenceId);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
