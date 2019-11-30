package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.service.ClassSessionService;
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
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sessionService")
public class ClassSessionRestController {


    private final ClassSessionService classSessionService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    //*********************************

    @Loggable
    @PostMapping(value = "/generateSessions/{classId}")
    public void generateSessions(@PathVariable Long classId, @Validated @RequestBody TclassDTO.Create autoSessionsRequirement) {
        classSessionService.generateSessions(classId, autoSessionsRequirement);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<ClassSessionDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(classSessionService.get(id), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<ClassSessionDTO.Info>> list() {
        return new ResponseEntity<>(classSessionService.list(), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping
    public ResponseEntity<ClassSessionDTO.Info> create(@RequestBody ClassSessionDTO.ManualSession req) {
        ClassSessionDTO.ManualSession create = (new ModelMapper()).map(req, ClassSessionDTO.ManualSession.class);
        return new ResponseEntity<>(classSessionService.create(create), HttpStatus.CREATED);
    }

    //*********************************

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<ClassSessionDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        ClassSessionDTO.Update update = (new ModelMapper()).map(request, ClassSessionDTO.Update.class);
        return new ResponseEntity<>(classSessionService.update(id, update), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        classSessionService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody ClassSessionDTO.Delete request) {
        classSessionService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ClassSessionDTO.ClassSessionsSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<ClassSessionDTO.Info> response = classSessionService.search(request);

        final ClassSessionDTO.SpecRs specResponse = new ClassSessionDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final ClassSessionDTO.ClassSessionsSpecRs specRs = new ClassSessionDTO.ClassSessionsSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}/{classId}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr,
                                  @PathVariable String classId) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        List<ClassSessionDTO.Info> infos = classSessionService.loadSessions(Long.parseLong(classId));


//////        final SearchDTO.SearchRs<ClassSessionDTO.Info> searchRs = classSessionService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(infos) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/SessionsList.jasper", params, jsonDataSource, response);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/load-sessions/{classId}")
    public ResponseEntity<ClassSessionDTO.ClassSessionsSpecRs> getClassSessions(@PathVariable Long classId) {

        List<ClassSessionDTO.Info> list = classSessionService.loadSessions((classId));

        final ClassSessionDTO.SpecRs specResponse = new ClassSessionDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final ClassSessionDTO.ClassSessionsSpecRs specRs = new ClassSessionDTO.ClassSessionsSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************
}
