package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/classReport")
public class ClassReportRestController {

	private final ReportUtil reportUtil;
	private final DateUtil dateUtil;
	private final ObjectMapper objectMapper;
	private final ITclassService tclassService;

	@Loggable
	@PostMapping(value = {"/printWithCriteria/{type}"})
	public void printWithCriteria(HttpServletResponse response,
								  @PathVariable String type,
								  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

		final SearchDTO.CriteriaRq criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
		final SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);

		final SearchDTO.SearchRs<TclassDTO.Info> searchRs = tclassService.search(searchRq);

		final Map<String, Object> params = new HashMap<>();
		params.put("todayDate", dateUtil.todayDate());

		String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
		JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
	}
}
