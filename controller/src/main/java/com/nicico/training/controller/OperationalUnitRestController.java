package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.iservice.IOperationalUnitService;
import com.nicico.training.service.OperationalUnitService;
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
@RequestMapping("/api/operationalUnit")
public class OperationalUnitRestController {


    private final IOperationalUnitService iOperationalUnitService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    //*********************************

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(iOperationalUnitService.get(id), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<OperationalUnitDTO.Info>> list() {
        return new ResponseEntity<>(iOperationalUnitService.list(), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping
    public ResponseEntity<OperationalUnitDTO.Info> create(@RequestBody OperationalUnitDTO.Create req, HttpServletResponse response) {
        OperationalUnitDTO.Create create = modelMapper.map(req, OperationalUnitDTO.Create.class);
        return new ResponseEntity<>(iOperationalUnitService.create(create, response), HttpStatus.CREATED);
    }

    //*********************************

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<OperationalUnitDTO.Info> update(@PathVariable Long id, @RequestBody Object request, HttpServletResponse response) {
        OperationalUnitDTO.Update update = modelMapper.map(request, OperationalUnitDTO.Update.class);
        return new ResponseEntity<>(iOperationalUnitService.update(id, update, response), HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        iOperationalUnitService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody OperationalUnitDTO.Delete request) {
        iOperationalUnitService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<OperationalUnitDTO.OperationalUnitSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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

        SearchDTO.SearchRs<OperationalUnitDTO.Info> response = iOperationalUnitService.search(request);

        final OperationalUnitDTO.SpecRs specResponse = new OperationalUnitDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final OperationalUnitDTO.OperationalUnitSpecRs specRs = new OperationalUnitDTO.OperationalUnitSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

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

        final SearchDTO.SearchRs<OperationalUnitDTO.Info> searchRs = iOperationalUnitService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/operationalUnit_Report.jasper", params, jsonDataSource, response);
    }

    //*********************************


}
