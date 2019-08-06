package com.nicico.training.controller;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.SkillStandardSubCategoryDTO;
import com.nicico.training.iservice.ISkillStandardSubCategoryService;
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
@RequestMapping(value = "/api/skill-standard-sub-category")
public class SkillStandardSubCategoryRestController {

	private final ISkillStandardSubCategoryService skillWorkSubCategoryService;

	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_skillStandardSubCategory')")
	public ResponseEntity<SkillStandardSubCategoryDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(skillWorkSubCategoryService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_skillStandardSubCategory')")
	public ResponseEntity<List<SkillStandardSubCategoryDTO.Info>> list() {
		return new ResponseEntity<>(skillWorkSubCategoryService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_skillStandardSubCategory')")
	public ResponseEntity<SkillStandardSubCategoryDTO.Info> create(@Validated @RequestBody SkillStandardSubCategoryDTO.Create request) {
		return new ResponseEntity<>(skillWorkSubCategoryService.create(request), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_skillStandardSubCategory')")
	public ResponseEntity<SkillStandardSubCategoryDTO.Info> update(@PathVariable Long id, @Validated @RequestBody SkillStandardSubCategoryDTO.Update request) {
		return new ResponseEntity<>(skillWorkSubCategoryService.update(id, request), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_skillStandardSubCategory')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		skillWorkSubCategoryService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_skillStandardSubCategory')")
	public ResponseEntity<Void> delete(@Validated @RequestBody SkillStandardSubCategoryDTO.Delete request) {
		skillWorkSubCategoryService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_skillStandardSubCategory')")
	public ResponseEntity<SkillStandardSubCategoryDTO.SkillStandardSubCategorySpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<SkillStandardSubCategoryDTO.Info> response = skillWorkSubCategoryService.search(request);

		final SkillStandardSubCategoryDTO.SpecRs specResponse = new SkillStandardSubCategoryDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SkillStandardSubCategoryDTO.SkillStandardSubCategorySpecRs specRs = new SkillStandardSubCategoryDTO.SkillStandardSubCategorySpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_skillStandardSubCategory')")
	public ResponseEntity<SearchDTO.SearchRs<SkillStandardSubCategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(skillWorkSubCategoryService.search(request), HttpStatus.OK);
	}
}
