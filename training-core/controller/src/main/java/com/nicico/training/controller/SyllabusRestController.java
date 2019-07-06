package com.nicico.training.controller;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.iservice.ISyllabusService;
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
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/syllabus")
public class SyllabusRestController {

	private final ISyllabusService syllabusService;

	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(syllabusService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<List<SyllabusDTO.Info>> list() {
		return new ResponseEntity<>(syllabusService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
	@PreAuthorize("hasAuthority('c_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> create(@RequestBody Object req) {
		SyllabusDTO.Create create = (new ModelMapper()).map(req, SyllabusDTO.Create.class);
		return new ResponseEntity<>(syllabusService.create(create), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('u_syllabus')")
	public ResponseEntity<SyllabusDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
		SyllabusDTO.Update update = (new ModelMapper()).map(request, SyllabusDTO.Update.class);
		return new ResponseEntity<>(syllabusService.update(id, update), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('d_syllabus')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		syllabusService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
	@PreAuthorize("hasAuthority('d_syllabus')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SyllabusDTO.Delete request) {
		syllabusService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
	@PreAuthorize("hasAuthority('r_syllabus')")
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
	@PreAuthorize("hasAuthority('r_syllabus')")
	public ResponseEntity<SearchDTO.SearchRs<SyllabusDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(syllabusService.search(request), HttpStatus.OK);
	}

}
