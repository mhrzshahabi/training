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
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;
import com.nicico.training.iservice.ISkillService;
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
		SkillDTO.Create create = (new ModelMapper()).map(request, SkillDTO.Create.class);

		return new ResponseEntity<>(skillService.create(create), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('u_skill')")
	public ResponseEntity<SkillDTO.Info> update(@PathVariable Long id,@RequestBody Object request) {
//		SkillDTO.Update u=new SkillDTO.Update();
//        ModelMapper m=new ModelMapper();
//	    SkillDTO.Update update = m.map(request, SkillDTO.Update.class);
		return new ResponseEntity<>(skillService.update(id, request), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('d_skill')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
        try {
            skillService.delete(id);
        } catch (Exception e) {
            return new ResponseEntity(HttpStatus.NO_CONTENT);
        }
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
	@PreAuthorize("hasAuthority('d_skill')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SkillDTO.Delete request) {
        try {
            skillService.delete(request);
        } catch (Exception e) {
            return new ResponseEntity(HttpStatus.NO_CONTENT);
        }
		return new ResponseEntity(HttpStatus.OK);
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

		SearchDTO.SearchRs<SkillDTO.Info> response = skillService.search(request);

		final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
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
    public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getUnAttachedSkillGroups(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SkillGroupDTO.Info> skillGroups = skillService.getUnAttachedSkillGroups(skillId);

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
	public ResponseEntity<SkillGroupDTO.SkillGroupSpecRs> getOtherSkillGroups(@RequestParam("skillId") String skillID) {
		Long skillId = Long.parseLong(skillID);

		List<SkillGroupDTO.Info> skillGroupList = skillService.getUnAttachedSkillGroups(skillId);

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
	@DeleteMapping(value = "/remove-skill-group/{skillGroupId}/{skillId}")
	public ResponseEntity<Void> removeSkillGroup(@PathVariable Long skillGroupId,@PathVariable Long skillId) {
		skillService.removeSkillGroup(skillGroupId,skillId);
		return new ResponseEntity(HttpStatus.OK);
	}

    @Loggable
    @DeleteMapping(value = "/remove-skill-group-list/{skillGroupIds}/{skillId}")
    public ResponseEntity<Void> removeSkillGroups( @PathVariable List<Long> skillGroupIds,@PathVariable Long skillId) {
        skillService.removeSkillGroups(skillGroupIds,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

	@Loggable
	@PostMapping(value = "/add-skill-group/{skillGroupId}/{skillId}")
	public ResponseEntity<Void>  addSkillGroup(@PathVariable Long skillGroupId,@PathVariable Long skillId) {
		skillService.addSkillGroup(skillGroupId,skillId);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@PostMapping(value = "/add-skill-group-list/{skillId}")
	public ResponseEntity<Void> addSkillGroups(@Validated @RequestBody SkillGroupDTO.SkillGroupIdList request,@PathVariable Long skillId) {
		skillService.addSkillGroups(request.getIds(),skillId);
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
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getUnAttachedCompetences(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CompetenceDTO.Info> competences = skillService.getUnAttachedCompetences(skillId);

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
    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getOtherCompetences(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<CompetenceDTO.Info> competences = skillService.getUnAttachedCompetences(skillId);

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
    @DeleteMapping(value = "/remove-competence/{competenceId}/{skillId}")
    public ResponseEntity<Void> removeCompetence(@PathVariable Long competenceId,@PathVariable Long skillId) {
        skillService.removeCompetence(competenceId,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-competence-list/{competenceIds}/{skillId}")
    public ResponseEntity<Void> removeCompetences( @PathVariable List<Long> competenceIds,@PathVariable Long skillId) {
        skillService.removeCompetences(competenceIds,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-competence/{competenceId}/{skillId}")
    public ResponseEntity<Void>  addCompetence(@PathVariable Long competenceId,@PathVariable Long skillId) {
        skillService.addCompetence(competenceId,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-competence-list/{skillId}")
    public ResponseEntity<Void> addCompetences(@Validated @RequestBody CompetenceDTO.CompetenceIdList request,@PathVariable Long skillId) {
        skillService.addCompetences(request.getIds(),skillId);
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
    public ResponseEntity<CourseDTO.CourseSpecRs> getUnAttachedCourses(@PathVariable Long skillId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CourseDTO.Info> courses = skillService.getUnAttachedCourses(skillId);

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
    public ResponseEntity<CourseDTO.CourseSpecRs> getOtherCourses(@RequestParam("skillId") String skillID) {
        Long skillId = Long.parseLong(skillID);

        List<CourseDTO.Info> courses = skillService.getUnAttachedCourses(skillId);

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
    @DeleteMapping(value = "/remove-course/{courseId}/{skillId}")
    public ResponseEntity<Void> removeCourse(@PathVariable Long courseId,@PathVariable Long skillId) {
        skillService.removeCourse(courseId,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-course-list/{courseIds}/{skillId}")
    public ResponseEntity<Void> removeCourses( @PathVariable List<Long> courseIds,@PathVariable Long skillId) {
        skillService.removeCourses(courseIds,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-course/{courseId}/{skillId}")
    public ResponseEntity<Void>  addCourse(@PathVariable Long courseId,@PathVariable Long skillId) {
        skillService.addCourse(courseId,skillId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-course-list/{skillId}")
    public ResponseEntity<Void> addCourses(@Validated @RequestBody CourseDTO.CourseIdList request,@PathVariable Long skillId) {
        skillService.addCourses(request.getIds(),skillId);
        return new ResponseEntity(HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/course-dummy")
//    @PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<CourseDTO.CourseSpecRs> courseDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<CourseDTO.CourseSpecRs>(new CourseDTO.CourseSpecRs(), HttpStatus.OK);
    }


    // ------------------------------------------------------------------------------------------------


    @Loggable
	@GetMapping(value = {"/print/{type}"})
	public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
		Map<String, Object> params = new HashMap<>();
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/Skill.jasper", params, response);
	}


}
