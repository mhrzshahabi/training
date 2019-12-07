package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.iservice.IAttendanceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
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
@RequestMapping(value = "/api/attendance")
public class AttendanceRestController {

	private final IAttendanceService attendanceService;
	private final ReportUtil reportUtil;
	private final ObjectMapper objectMapper;
	private final DateUtil dateUtil;


	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('r_attendance')")
	public ResponseEntity<AttendanceDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(attendanceService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_attendance')")
	public ResponseEntity<List<AttendanceDTO.Info>> list() {
		return new ResponseEntity<>(attendanceService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
//	@PreAuthorize("hasAuthority('c_attendance')")
	public ResponseEntity<AttendanceDTO.Info> create(@RequestBody Object req) {
		AttendanceDTO.Create create = (new ModelMapper()).map(req, AttendanceDTO.Create.class);
		return new ResponseEntity<>(attendanceService.create(create), HttpStatus.CREATED);
	}

//	@Loggable
//	@PostMapping
////	@PreAuthorize("hasAuthority('c_attendance')")
//	public ResponseEntity<AttendanceDTO.Info> autoCreate(@RequestParam("classId") Long classId,@RequestParam("date") String date) {
//		return new ResponseEntity<>(attendanceService.autoCreate(classId, date), HttpStatus.CREATED);
//	}

	@Loggable
	@PutMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('u_attendance')")
	public ResponseEntity<AttendanceDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
		AttendanceDTO.Update update = (new ModelMapper()).map(request, AttendanceDTO.Update.class);
		return new ResponseEntity<>(attendanceService.update(id, update), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
//	@PreAuthorize("hasAuthority('d_attendance')")
	public ResponseEntity delete(@PathVariable Long id) {
		attendanceService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/list")
//	@PreAuthorize("hasAuthority('d_attendance')")
	public ResponseEntity delete(@Validated @RequestBody AttendanceDTO.Delete request) {
		attendanceService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
//	@PreAuthorize("hasAuthority('r_attendance')")
	public ResponseEntity<AttendanceDTO.AttendanceSpecRs> list(@RequestParam("_startRow") Integer startRow,
															   @RequestParam("_endRow") Integer endRow,
															   @RequestParam(value = "_constructor", required = false) String constructor,
															   @RequestParam(value = "operator", required = false) String operator,
															   @RequestParam(value = "criteria", required = false) String criteria,
															   @RequestParam(value = "id", required = false) Long id,
															   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException
	{
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		SearchDTO.CriteriaRq criteriaRq;
		if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
			criteria = "[" + criteria + "]";
			criteriaRq = new SearchDTO.CriteriaRq();
			criteriaRq.setOperator(EOperator.valueOf(operator))
					.setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
					}));
			request.setCriteria(criteriaRq);
		}
		if (StringUtils.isNotEmpty(sortBy)) {
			request.setSortBy(sortBy);
		}
		if(id != null){
			criteriaRq = new SearchDTO.CriteriaRq();
			criteriaRq.setOperator(EOperator.equals)
					.setFieldName("id")
					.setValue(id);
			request.setCriteria(criteriaRq);
			startRow=0;
			endRow=1;
		}
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);
		SearchDTO.SearchRs<AttendanceDTO.Info> response = attendanceService.search(request);
		final AttendanceDTO.SpecRs specResponse = new AttendanceDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final AttendanceDTO.AttendanceSpecRs specRs = new AttendanceDTO.AttendanceSpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}
	// ---------------

	@Loggable
	@PostMapping(value = "/search")
//	@PreAuthorize("hasAuthority('r_attendance')")
	public ResponseEntity<SearchDTO.SearchRs<AttendanceDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(attendanceService.search(request), HttpStatus.OK);
	}

	// -----------------

	@Loggable
	@GetMapping(value = {"/print/{type}"})
	public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
		Map<String, Object> params = new HashMap<>();
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/Attendance.jasper", params, response);
	}
}
