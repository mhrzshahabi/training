package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.InstituteDTO;
import com.nicico.training.iservice.IInstituteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/institute")
public class InstituteRestController {
    
    private final IInstituteService instituteService;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<InstituteDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(instituteService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<List<InstituteDTO.Info>> list() {
        return new ResponseEntity<>(instituteService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_institute')")
    public ResponseEntity<InstituteDTO.Info> create(@RequestBody Object request) {
        InstituteDTO.Create create = (new ModelMapper()).map(request, InstituteDTO.Create.class);
        return new ResponseEntity<>(instituteService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_institute')")
    public ResponseEntity<InstituteDTO.Info> update(@PathVariable Long id,@RequestBody Object request) {
        InstituteDTO.Update update = (new ModelMapper()).map(request, InstituteDTO.Update.class);
        return new ResponseEntity<>(instituteService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_institute')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        instituteService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_institute')")
    public ResponseEntity<Void> delete(@Validated @RequestBody InstituteDTO.Delete request) {
        instituteService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<InstituteDTO.InstituteSpecRs> list(@RequestParam("_startRow") Integer startRow,
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


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<InstituteDTO.Info> response = instituteService.search(request);

        final InstituteDTO.SpecRs specResponse = new InstituteDTO.SpecRs();
        final InstituteDTO.InstituteSpecRs specRs = new InstituteDTO.InstituteSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<SearchDTO.SearchRs<InstituteDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(instituteService.search(request), HttpStatus.OK);
    }

    @Loggable
	@PostMapping(value = {"/printWithCriteria/{type}"})
	public void printWithCriteria(HttpServletResponse response,
								  @PathVariable String type,
								  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if(criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        }
        else{
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

		final SearchDTO.SearchRs<InstituteDTO.Info> searchRs = instituteService.search(searchRq);

		final Map<String, Object> params = new HashMap<>();
		params.put("todayDate", dateUtil.todayDate());

		String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
		JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/InstituteByCriteria.jasper", params, jsonDataSource, response);
	}


}
