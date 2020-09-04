package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.iservice.ITermService;
import com.nicico.training.repository.TermDAO;
import com.nicico.training.service.TermService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
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
@RequestMapping("/api/term")
public class TermRestController {
    private final ITermService termService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<TermDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(termService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<TermDTO.Info>> list() {
        return new ResponseEntity<>(termService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<TermDTO.Info> create(@RequestBody Object req) {
        TermDTO.Create create = modelMapper.map(req, TermDTO.Create.class);
        return new ResponseEntity<>(termService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<TermDTO.Info> update(@PathVariable Long id, @RequestBody Object request,HttpServletResponse response) {
        TermDTO.Update update = modelMapper.map(request, TermDTO.Update.class);
        return new ResponseEntity<>(termService.update(id, update,response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id,HttpServletResponse response) {
        try {
            termService.delete(id,response);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }

    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody TermDTO.Delete request) {
        termService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @GetMapping(value = "/spec-list")
    public ResponseEntity<TotalResponse<TermDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(termService.search(nicicoCriteria), HttpStatus.OK);
    }

    //
//    @Loggable
//    @GetMapping(value = "/spec-list")
    public ResponseEntity<TermDTO.TermSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<TermDTO.Info> response = termService.search(request);

        final TermDTO.SpecRs specResponse = new TermDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final TermDTO.TermSpecRs specRs = new TermDTO.TermSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<TermDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(termService.search(request), HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "_sortBy") String sortBy,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        JSONObject jsonObject = new JSONObject(sortBy);
        String field = jsonObject.getString("property");
        String direction = jsonObject.getString("direction");
        if(direction.equals("descending")){
            field = "-" + field;
        }
        searchRq.setSortBy(field);
        final SearchDTO.SearchRs<TermDTO.Info> searchRs = termService.search(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/TermByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = {"/checkForConflict/{sData}/{eData}"})
    public ResponseEntity<String> checkForConflict(@PathVariable String sData, @PathVariable String eData) {
        sData = sData.substring(0, 4) + "/" + sData.substring(4, 6) + "/" + sData.substring(6, 8);
        eData = eData.substring(0, 4) + "/" + eData.substring(4, 6) + "/" + eData.substring(6, 8);
        return new ResponseEntity<>(termService.checkForConflict(sData, eData), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/checkForConflict/{sData}/{eData}/{id}"})
    public ResponseEntity<String> checkConflictWithoutThisTerm(@PathVariable String sData, @PathVariable String eData, @PathVariable Long id) {
        sData = sData.substring(0, 4) + "/" + sData.substring(4, 6) + "/" + sData.substring(6, 8);
        eData = eData.substring(0, 4) + "/" + eData.substring(4, 6) + "/" + eData.substring(6, 8);
        return new ResponseEntity<>(termService.checkConflictWithoutThisTerm(sData, eData, id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/getCode/{code}"})
    public ResponseEntity<String> getCode(@PathVariable String code) {
        return new ResponseEntity<>(termService.LastCreatedCode(code), HttpStatus.OK);
    }

    @GetMapping(value = "/yearList")
    public ResponseEntity<TotalResponse<TermDTO.Year>> yearList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        TotalResponse<TermDTO.Year> specResponse = termService.ySearch(nicicoCriteria);
        return new ResponseEntity<>(specResponse, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/listByYear/{year}")
    public ResponseEntity<TermDTO.TermSpecRs> listByYear(@PathVariable String year) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.SearchRs<TermDTO.Info> response = termService.searchByYear(request, year);

        final TermDTO.SpecRs specResponse = new TermDTO.SpecRs();
        final TermDTO.TermSpecRs specRs = new TermDTO.TermSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(0 + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/years")
    public ResponseEntity<TermDTO.YearsSpecRs> years() {

        List<TermDTO.Years> list = termService.years();

        final TermDTO.YsSpecRs specResponse = new TermDTO.YsSpecRs();
        final TermDTO.YearsSpecRs specRs = new TermDTO.YearsSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getCurrentTerm/{year}")
    public ResponseEntity<Long> getCurrentTerm(@PathVariable String year) {
        Long result = null;
        SearchDTO.SearchRs<TermDTO.Info> termsResult =  termService.searchYearCurrentTerm(year);
        if(termsResult.getList() != null && termsResult.getList().size()!=0)
            result = termsResult.getList().get(0).getId();
        return new ResponseEntity<>(result,HttpStatus.OK);
    }

}
