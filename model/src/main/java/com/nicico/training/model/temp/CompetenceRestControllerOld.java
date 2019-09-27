package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:26 PM
*/

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.service.CompetenceServiceOld;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence1")
public class CompetenceRestControllerOld {

//    private final CompetenceServiceOld competenceService;
//    private final ObjectMapper objectMapper;
//
//    @Loggable
//    @GetMapping("/{id}")
////    @PreAuthorize("hasAuthority('r_competence')")
//    public ResponseEntity<CompetenceDTOOld.Info> get(@PathVariable long id) {
//        return new ResponseEntity<>(competenceService.get(id), HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping("/list")
////    @PreAuthorize("hasAuthority('r_competence')")
//    public ResponseEntity<List<CompetenceDTOOld.Info>> list() {
//        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
//    }
//
//    @Loggable
//    @PostMapping
////    @PreAuthorize("hasAuthority('c_competence')")
//    public ResponseEntity<CompetenceDTOOld.Info> create(@RequestBody Object req) {
//        CompetenceDTOOld.Create create = (new ModelMapper()).map(req, CompetenceDTOOld.Create.class);
//        return new ResponseEntity<>(competenceService.create(create), HttpStatus.CREATED);
//    }
//
//    @Loggable
//    @PutMapping("/{id}")
////    @PreAuthorize("hasAuthority('u_competence')")
//    public ResponseEntity<CompetenceDTOOld.Info> update(@PathVariable Long id, @RequestBody Object req) {
//        CompetenceDTOOld.Update update = (new ModelMapper()).map(req, CompetenceDTOOld.Update.class);
//        return new ResponseEntity<>(competenceService.update(id, update), HttpStatus.OK);
//    }
//
//    @Loggable
//    @DeleteMapping("/{id}")
////    @PreAuthorize("hasAuthority('d_competence')")
//    public ResponseEntity<Void> delete(@PathVariable Long id) {
//        competenceService.delete(id);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }
//
//    @Loggable
//    @DeleteMapping("/list")
////    @PreAuthorize("hasAuthority('d_competence')")
//    public ResponseEntity<Void> delete(@Validated @RequestBody CompetenceDTOOld.Delete req) {
//        competenceService.delete(req);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/spec-list")
//    public ResponseEntity<CompetenceDTOOld.CompetenceSpecRs> list(@RequestParam("_startRow") Integer startRow,
//                                                               @RequestParam("_endRow") Integer endRow,
//                                                               @RequestParam(value = "_constructor", required = false) String constructor,
//                                                               @RequestParam(value = "operator", required = false) String operator,
//                                                               @RequestParam(value = "criteria", required = false) String criteria,
//                                                               @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//
//        SearchDTO.CriteriaRq criteriaRq;
//        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
//            criteria = "[" + criteria + "]";
//            criteriaRq = new SearchDTO.CriteriaRq();
//            criteriaRq.setOperator(EOperator.valueOf(operator))
//                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
//                    }));
//            request.setCriteria(criteriaRq);
//        }
//
//        if (StringUtils.isNotEmpty(sortBy)) {
//            request.setSortBy(sortBy);
//        }
//        request.setStartIndex(startRow)
//                .setCount(endRow - startRow);
//
//        SearchDTO.SearchRs<CompetenceDTOOld.Info> response = competenceService.search(request);
//
//        final CompetenceDTOOld.SpecRs specResponse = new CompetenceDTOOld.SpecRs();
//        final CompetenceDTOOld.CompetenceSpecRs specRs = new CompetenceDTOOld.CompetenceSpecRs();
//        specResponse.setData(response.getList())
//                .setStartRow(startRow)
//                .setEndRow(startRow + response.getTotalCount().intValue())
//                .setTotalRows(response.getTotalCount().intValue());
//
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping("/{id}/spec")
//    public ResponseEntity<CompetenceDTOOld.CompetenceSpecRs> get(@PathVariable long id, @RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<CompetenceDTOOld.Info> list = new ArrayList<>();
//        list.add(competenceService.get(id));
//
//        final CompetenceDTOOld.SpecRs specResponse = new CompetenceDTOOld.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final CompetenceDTOOld.CompetenceSpecRs specRs = new CompetenceDTOOld.CompetenceSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/job/not/{jobId}/spec-list")
//    public ResponseEntity<CompetenceDTOOld.CompetenceSpecRs> getOtherCompetences(@PathVariable Long jobId) {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<CompetenceDTOOld.Info> list = competenceService.getOtherCompetence(jobId);
//
//        final CompetenceDTOOld.SpecRs specResponse = new CompetenceDTOOld.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final CompetenceDTOOld.CompetenceSpecRs specRs = new CompetenceDTOOld.CompetenceSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping("/search")
////    @PreAuthorize("hasAuthority('r_competence')")
//    public ResponseEntity<SearchDTO.SearchRs<CompetenceDTOOld.Info>> search(@RequestBody SearchDTO.SearchRq req) {
//        return new ResponseEntity<>(competenceService.search(req), HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/{competenceId}/job-competence/spec-list")
//    public ResponseEntity<JobCompetenceDTO.IscRes> getJobCompetences(@PathVariable Long competenceId) {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<JobCompetenceDTO.Info> list = competenceService.getJobCompetence(competenceId);
//
//        final JobCompetenceDTO.SpecRs specResponse = new JobCompetenceDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final JobCompetenceDTO.IscRes specRs = new JobCompetenceDTO.IscRes();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/{competenceId}/skills/spec-list")
//    public ResponseEntity<SkillDTO.SkillSpecRs> getSkills(@PathVariable Long competenceId) {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<SkillDTO.Info> list = competenceService.getSkills(competenceId);
//
//        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/{competenceId}/skillGroups/spec-list")
//    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getSkillGroups(@PathVariable Long competenceId) {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<SkillGroupDTO.Info> list = competenceService.getSkillGroups(competenceId);
//
//        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/{competenceId}/courses/spec-list")
//    public ResponseEntity<CourseDTO.CourseSpecRs> getCourses(@PathVariable Long competenceId) {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        List<CourseDTO.Info> list = competenceService.getCourses(competenceId);
//
//        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//
//        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }

}
