package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.iservice.ISyllabusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/syllabus")
public class SyllabusRestController {

	private final ISyllabusService syllabusService;
	private final ICourseService courseService;
	private final IGoalService goalService;
	private final ReportUtil reportUtil;
	private final ObjectMapper objectMapper;
	private final DateUtil dateUtil;


	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(syllabusService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<List<SyllabusDTO.Info>> list() {
		return new ResponseEntity<>(syllabusService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> create(@RequestBody Object req) {
		SyllabusDTO.Create create = (new ModelMapper()).map(req, SyllabusDTO.Create.class);
		return new ResponseEntity<>(syllabusService.create(create), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
		SyllabusDTO.Update update = (new ModelMapper()).map(request, SyllabusDTO.Update.class);
		return new ResponseEntity<>(syllabusService.update(id, update), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_syllabus')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		syllabusService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_syllabus')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SyllabusDTO.Delete request) {
		syllabusService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<SyllabusDTO.SyllabusSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<SyllabusDTO.Info> response = syllabusService.search(request);

		final SyllabusDTO.SpecRs specResponse = new SyllabusDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SyllabusDTO.SyllabusSpecRs specRs = new SyllabusDTO.SyllabusSpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}
	@Loggable
	@GetMapping(value = "course/{courseId}")
	public ResponseEntity<SyllabusDTO.SyllabusSpecRs> getSyllabusCourse(@PathVariable Long courseId) {
		List<SyllabusDTO.Info> syllabusCourse = syllabusService.getSyllabusCourse(courseId);
		final SyllabusDTO.SpecRs specResponse = new SyllabusDTO.SpecRs();
		specResponse.setData(syllabusCourse)
				.setStartRow(0)
				.setEndRow( syllabusCourse.size())
				.setTotalRows(syllabusCourse.size());
		final SyllabusDTO.SyllabusSpecRs specRs = new SyllabusDTO.SyllabusSpecRs();
		specRs.setResponse(specResponse);
		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<SearchDTO.SearchRs<SyllabusDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(syllabusService.search(request), HttpStatus.OK);
	}

	// -----------------

	@Loggable
	@GetMapping(value = {"/print/{type}"})
	public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
		Map<String, Object> params = new HashMap<>();
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/Syllabus.jasper", params, response);
	}
	//------------------

	@Loggable
	@GetMapping(value = {"/print-one-course/{courseId}/{type}"})
	public void printOneCourse(HttpServletResponse response, @PathVariable Long courseId, @PathVariable String type) throws Exception {
		List<SyllabusDTO.Info> getSyllabus = syllabusService.getSyllabusCourse(courseId);
		CourseDTO.Info info = courseService.get(courseId);
		String s = "دوره " + info.getTitleFa();
		final Map<String, Object> params = new HashMap<>();
		params.put("todayDate", dateUtil.todayDate());
		params.put("courseName", s);
		String data = "{" + "\"content\": " + objectMapper.writeValueAsString(getSyllabus) + "}";
		JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/SyllabusOneCourse.jasper", params, jsonDataSource, response);
	}//------------------

	@Loggable
	@GetMapping(value = {"/print-one-goal/{goalId}/{type}"})
	public void printOneGoal(HttpServletResponse response, @PathVariable Long goalId, @PathVariable String type) throws Exception {
		List<SyllabusDTO.Info> getSyllabus = goalService.getSyllabusSet(goalId);
		GoalDTO.Info info = goalService.get(goalId);
		String s = "هدف " + info.getTitleFa();
		final Map<String, Object> params = new HashMap<>();
		params.put("todayDate", dateUtil.todayDate());
		params.put("courseName", s);
		String data = "{" + "\"content\": " + objectMapper.writeValueAsString(getSyllabus) + "}";
		JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/SyllabusOneGoal.jasper", params, jsonDataSource, response);
	}
}
