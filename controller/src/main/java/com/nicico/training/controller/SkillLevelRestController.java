package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillLevelDTO;
import com.nicico.training.iservice.ISkillLevelService;
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
@RequestMapping(value = "/api/skill-level")
public class SkillLevelRestController {

	private final ISkillLevelService skillLevelService;

	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_skillLevel')")
	public ResponseEntity<SkillLevelDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(skillLevelService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_skillLevel')")
	public ResponseEntity<List<SkillLevelDTO.Info>> list() {
		return new ResponseEntity<>(skillLevelService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_skillLevel')")
	public ResponseEntity<SkillLevelDTO.Info> create(@Validated @RequestBody SkillLevelDTO.Create request) {
		return new ResponseEntity<>(skillLevelService.create(request), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_skillLevel')")
	public ResponseEntity<SkillLevelDTO.Info> update(@PathVariable Long id, @Validated @RequestBody SkillLevelDTO.Update request) {
		return new ResponseEntity<>(skillLevelService.update(id, request), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_skillLevel')")
	public ResponseEntity<Boolean> delete(@PathVariable Long id) {
		boolean flag=true;
		HttpStatus httpStatus=HttpStatus.OK;
		try {
			skillLevelService.delete(id);
		} catch (Exception e) {
			httpStatus=HttpStatus.NO_CONTENT;
			flag=false;
		}
		return new ResponseEntity<>(flag,httpStatus);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_skillLevel')")
	public ResponseEntity<Boolean> delete(@Validated @RequestBody SkillLevelDTO.Delete request) {
		boolean flag=true;
		HttpStatus httpStatus=HttpStatus.OK;
		try {
			skillLevelService.delete(request);
		} catch (Exception e) {
			httpStatus=HttpStatus.NO_CONTENT;
			flag=false;
		}
		return new ResponseEntity<>(flag,httpStatus);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_skillLevel')")
	public ResponseEntity<SkillLevelDTO.SkillLevelSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<SkillLevelDTO.Info> response = skillLevelService.search(request);

		final SkillLevelDTO.SpecRs specResponse = new SkillLevelDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final SkillLevelDTO.SkillLevelSpecRs specRs = new SkillLevelDTO.SkillLevelSpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_skillLevel')")
	public ResponseEntity<SearchDTO.SearchRs<SkillLevelDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(skillLevelService.search(request), HttpStatus.OK);
	}
}
