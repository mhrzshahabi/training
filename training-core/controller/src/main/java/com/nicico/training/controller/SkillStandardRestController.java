package com.nicico.training.controller;

import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.SkillStandardDTO;
import com.nicico.training.iservice.ISkillStandardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/skill-standard")
public class SkillStandardRestController {

	private final ReportUtil reportUtil;
	private final ISkillStandardService skillStandardService;

	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_skillStandard')")
	public ResponseEntity<SkillStandardDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(skillStandardService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_skillStandard')")
	public ResponseEntity<List<SkillStandardDTO.Info>> list() {
		return new ResponseEntity<>(skillStandardService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_skillStandard')")
	public ResponseEntity<SkillStandardDTO.Info> create(@Validated @RequestBody SkillStandardDTO.Create request) {
		return new ResponseEntity<>(skillStandardService.create(request), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_skillStandard')")
	public ResponseEntity<SkillStandardDTO.Info> update(@PathVariable Long id, @Validated @RequestBody SkillStandardDTO.Update request) {
		return new ResponseEntity<>(skillStandardService.update(id, request), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_skillStandard')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		skillStandardService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_skillStandard')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SkillStandardDTO.Delete request) {
		skillStandardService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_skillStandard')")
	public ResponseEntity<SkillStandardDTO.SkillStandardSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<SkillStandardDTO.Info> response = skillStandardService.search(request);

		final SkillStandardDTO.SpecRs specResponse = new SkillStandardDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SkillStandardDTO.SkillStandardSpecRs specRs = new SkillStandardDTO.SkillStandardSpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_skillStandard')")
	public ResponseEntity<SearchDTO.SearchRs<SkillStandardDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(skillStandardService.search(request), HttpStatus.OK);
	}

	// ------------------------------

	@Loggable
	@GetMapping(value = "/course/{skillStandardId}")
//	@PreAuthorize("hasAnyAuthority('r_skillStandard')")
	public ResponseEntity<Set<CourseDTO.Info>> getCourses(@PathVariable Long skillStandardId) {
		return new ResponseEntity<>(skillStandardService.getCourses(skillStandardId), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = {"/print/{type}"})
	public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
		Map<String, Object> params = new HashMap<>();
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/Skill.jasper", params, response);
	}
}
