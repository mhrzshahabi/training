package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ProvinceDTO;
import com.nicico.training.iservice.IProvinceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import com.nicico.copper.common.util.date.DateUtil;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
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
@RequestMapping(value = "/api/province")
public class ProvinceRestController {
    private final IProvinceService provinceService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<ProvinceDTO.Info> get(@PathVariable("id") Long id) {
        return new ResponseEntity<ProvinceDTO.Info>(provinceService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<ProvinceDTO.Info>> list() {
        return new ResponseEntity<List<ProvinceDTO.Info>>(provinceService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/isclist")
    public ResponseEntity<ISC<ProvinceDTO.Info>> list(HttpServletRequest iscRequest) throws IOException {
        int startRow = 0;
        if (iscRequest.getParameter("_startRow") != null)
            startRow = Integer.parseInt((iscRequest.getParameter("_startRow")));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRequest);
        SearchDTO.SearchRs<ProvinceDTO.Info> searchRs = provinceService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@Validated @RequestBody ProvinceDTO.Create request,HttpServletResponse response) {
        try {
            return new ResponseEntity<>(provinceService.create(request,response), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable("id") Long id, @Validated @RequestBody ProvinceDTO.Update request, HttpServletResponse response) {
        try {
            return new ResponseEntity<>(provinceService.update(id, request,response), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
    public ResponseEntity delete(@PathVariable("id") Long id) {
        try {
            provinceService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody ProvinceDTO.Delete request) {
        provinceService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<ProvinceDTO.ProvinceSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<ProvinceDTO.Info> response = provinceService.search(request);

        final ProvinceDTO.SpecRs specResponse = new ProvinceDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final ProvinceDTO.ProvinceSpecRs specRs = new ProvinceDTO.ProvinceSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs,HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<ProvinceDTO.Info>>search(@RequestBody SearchDTO.SearchRq request){
        return new ResponseEntity<>(provinceService.search(request),HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,@PathVariable("type") String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception{
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if(criteriaStr.equalsIgnoreCase("{}")){
            searchRq = new SearchDTO.SearchRq();
        }else {
            criteriaRq = objectMapper.readValue(criteriaStr,SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<ProvinceDTO.Info> searchRs = provinceService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/ProvinceList.jasper", params, jsonDataSource, response);
    }
}
