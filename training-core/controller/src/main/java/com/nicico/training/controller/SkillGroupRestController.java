package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.EOperator;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;
import com.nicico.training.service.SkillGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/skill-group")
public class SkillGroupRestController {
    private final ReportUtil reportUtil;
    private final SkillGroupService skillGroupService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('r_skill_group')")
    public ResponseEntity<SkillGroupDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(skillGroupService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    @PreAuthorize("hasAuthority('r_skill_group')")
    public ResponseEntity<List<SkillGroupDTO.Info>> list() {
        return new ResponseEntity<>(skillGroupService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    @PreAuthorize("hasAuthority('c_skill_group')")
    public ResponseEntity<SkillGroupDTO.Info> create(@Validated @RequestBody SkillGroupDTO.Create request) {
        return new ResponseEntity<>(skillGroupService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('u_skill_group')")
    public ResponseEntity<SkillGroupDTO.Info> update(@PathVariable Long id, @Validated @RequestBody SkillGroupDTO.Update request) {
        return new ResponseEntity<>(skillGroupService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('d_skill_group')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        skillGroupService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    @PreAuthorize("hasAuthority('d_skill_group')")
    public ResponseEntity<Void> delete(@Validated @RequestBody SkillGroupDTO.Delete request) {
        skillGroupService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{skillGroupId}/canDelete")
//    @PreAuthorize("hasAuthority('d_skill_group')")
    public ResponseEntity<Boolean> canDelete(@PathVariable Long skillGroupId) {
        return new ResponseEntity<>(skillGroupService.canDelete(skillGroupId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    @PreAuthorize("hasAuthority('r_skill_group')")
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> list(@RequestParam("_startRow") Integer startRow,
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
                criteriaRq.set_sortBy(sortBy);
            }

            request.setCriteria(criteriaRq);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);



        //SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<SkillGroupDTO.Info> response = skillGroupService.search(request);

        final SkillGroupDTO.SpecRs specResponse = new SkillGroupDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final SkillGroupDTO.SkillGroupSpecRs specRs = new SkillGroupDTO.SkillGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    @PreAuthorize("hasAuthority('r_skill_group')")
    public ResponseEntity<SearchDTO.SearchRs<SkillGroupDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(skillGroupService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{skillGroupId}/getCompetences")
    @PreAuthorize("hasAnyAuthority('r_skill_group')")
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getCompetences(@PathVariable Long skillGroupId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CompetenceDTO.Info> list = skillGroupService.getCompetence(skillGroupId);

        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow( list.size())
                .setTotalRows(list.size());

        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs,HttpStatus.OK);


    }






    @Loggable
    @PostMapping(value = "/addSkill/{skillId}/{skillGroupId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void>  addSkill(@PathVariable Long skillId,@PathVariable Long skillGroupId) {
        skillGroupService.addSkill(skillId,skillGroupId);
        return new ResponseEntity(HttpStatus.OK);
    }




    @Loggable
    @PostMapping(value = "/addSkills/{skillGroupId}/{skillIds}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void>  addSkills(@PathVariable Long skillGroupId,@PathVariable Set<Long> skillIds) {
        skillGroupService.addSkills(skillGroupId, skillIds);
        return new ResponseEntity(HttpStatus.OK);
    }



    @Loggable
    @DeleteMapping(value = "/removeSkill/{skillGroupId}/{skillId}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removeSkill(@PathVariable Long skillGroupId,@PathVariable Long skillId) {
        skillGroupService.removeSkill(skillGroupId,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removeCompetence/{skillGroupId}/{competenceId}")
    public ResponseEntity<Void> removeFromCompetence(@PathVariable Long skillGroupId,@PathVariable Long competenceId){
        skillGroupService.removeFromCompetency(skillGroupId,competenceId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removeAllCompetence/{skillGroupId}/")
    public ResponseEntity<Void> removeFromAllCompetences(@PathVariable Long skillGroupId){
        skillGroupService.removeFromAllCompetences(skillGroupId);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/{skillGroupId}/unAttachSkills")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SkillDTO.SkillSpecRs> unAttachSkills(@PathVariable Long skillGroupId) {

        Set<SkillDTO.Info> skills;
        skills=skillGroupService.unAttachSkills(skillGroupId);
        List<SkillDTO.Info> skillList=new ArrayList<>();
        for (SkillDTO.Info skillDTOInfo:skills)
        {
            skillList.add(skillDTOInfo);

        }
        final  SkillDTO.SpecRs specRs=new SkillDTO.SpecRs();
        specRs.setData(skillList)
                .setStartRow(0)
                .setEndRow(skills.size())
                .setTotalRows(skills.size());

        final SkillDTO.SkillSpecRs skillSpecRs=new SkillDTO.SkillSpecRs();
        skillSpecRs.setResponse(specRs);
        return new ResponseEntity<>(skillSpecRs,HttpStatus.OK);

            }



    @Loggable
    @DeleteMapping(value = "/removeSkills/{skillGroupId}/{skillIds}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removeSkills(@PathVariable Long skillGroupId,@PathVariable Set<Long> skillIds) {
        skillGroupService.removeSkills(skillGroupId,skillIds);
        return new ResponseEntity(HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/{skillGroupId}/getSkills")
    @PreAuthorize("hasAnyAuthority('r_skill_group')")
    public ResponseEntity<SkillDTO.SkillSpecRs> getSkills(@PathVariable Long skillGroupId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SkillDTO.Info> list = skillGroupService.getSkills(skillGroupId);

        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow( list.size())
                .setTotalRows(list.size());

        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs,HttpStatus.OK);


    }




    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/skill_group.jasper", params, response);
    }
}
