package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.EducationLevelDTO;
import com.nicico.training.iservice.IEducationLevelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
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
@RequestMapping(value = "/api/education/level")
public class EducationLevelRestController {
    private final IEducationLevelService educationLevelService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationLevelService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<List<EducationLevelDTO.Info>> list() {
        return new ResponseEntity<>(educationLevelService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> create(@Validated @RequestBody EducationLevelDTO.Create request) {
        return new ResponseEntity<>(educationLevelService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity<EducationLevelDTO.Info> update(@PathVariable Long id, @Validated @RequestBody EducationLevelDTO.Update request) {
        return new ResponseEntity<>(educationLevelService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        educationLevelService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationLevelDTO.Delete request) {
        educationLevelService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<EducationLevelDTO.EducationLevelSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationLevelDTO.Info> response = educationLevelService.search(request);

        final EducationLevelDTO.SpecRs specResponse = new EducationLevelDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationLevelDTO.EducationLevelSpecRs specRs = new EducationLevelDTO.EducationLevelSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<SearchDTO.SearchRs<EducationLevelDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationLevelService.search(request), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<EducationLevelDTO.Info> searchRs = educationLevelService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EducationLevelByCriteria.jasper", params, jsonDataSource, response);
    }

}
