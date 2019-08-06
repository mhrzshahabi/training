package com.nicico.training.controller;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.SkillStandardCategoryDTO;
import com.nicico.training.iservice.ISkillStandardCategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/skill-standard-category")
public class SkillStandardCategoryRestController {

	private final ISkillStandardCategoryService skillStandardCategoryService;

	// ------------------------------s

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_skillStandardCategory')")
	public ResponseEntity<SkillStandardCategoryDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(skillStandardCategoryService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_skillStandardCategory')")
	public ResponseEntity<List<SkillStandardCategoryDTO.Info>> list() {
		return new ResponseEntity<>(skillStandardCategoryService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_skillStandardCategory')")
	public ResponseEntity<SkillStandardCategoryDTO.Info> create(@Validated @RequestBody SkillStandardCategoryDTO.Create request) {
		return new ResponseEntity<>(skillStandardCategoryService.create(request), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_skillStandardCategory')")
	public ResponseEntity<SkillStandardCategoryDTO.Info> update(@PathVariable Long id, @Validated @RequestBody SkillStandardCategoryDTO.Update request) {
		return new ResponseEntity<>(skillStandardCategoryService.update(id, request), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_skillStandardCategory')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		skillStandardCategoryService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_skillStandardCategory')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SkillStandardCategoryDTO.Delete request) {
		skillStandardCategoryService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_skillStandardCategory')")
	public ResponseEntity<SkillStandardCategoryDTO.SkillStandardCategorySpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<SkillStandardCategoryDTO.Info> response = skillStandardCategoryService.search(request);

		final SkillStandardCategoryDTO.SpecRs specResponse = new SkillStandardCategoryDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SkillStandardCategoryDTO.SkillStandardCategorySpecRs specRs = new SkillStandardCategoryDTO.SkillStandardCategorySpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_skillStandardCategory')")
	public ResponseEntity<SearchDTO.SearchRs<SkillStandardCategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(skillStandardCategoryService.search(request), HttpStatus.OK);
	}
}
