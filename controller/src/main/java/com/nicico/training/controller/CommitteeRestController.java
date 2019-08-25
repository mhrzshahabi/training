package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.model.Category;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.CommitteeDAO;
import com.nicico.training.service.CommitteeService;
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
@RequestMapping("/api/committee")
public class CommitteeRestController {
  private final CommitteeService committeeService;
   private final ObjectMapper objectMapper;
   private final DateUtil dateUtil;
   private final ReportUtil reportUtil;
   private final CategoryDAO categoryDAO;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<CommitteeDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(committeeService.get(id), HttpStatus.OK);
    }

     @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<CommitteeDTO.Info>> list() {
        return new ResponseEntity<>(committeeService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CommitteeDTO.Info> create(@RequestBody CommitteeDTO.Create req) {
        CommitteeDTO.Create create = (new ModelMapper()).map(req, CommitteeDTO.Create.class);
        return new ResponseEntity<>(committeeService.create(create), HttpStatus.CREATED);
    }

 @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CommitteeDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        CommitteeDTO.Update update = (new ModelMapper()).map(request, CommitteeDTO.Update.class);
        return new ResponseEntity<>(committeeService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        committeeService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

     @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody CommitteeDTO.Delete request) {
        committeeService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


     @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CommitteeDTO.CommitteeSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<CommitteeDTO.Info> response = committeeService.search(request);

        final CommitteeDTO.SpecRs specResponse = new CommitteeDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final CommitteeDTO.CommitteeSpecRs specRs = new CommitteeDTO.CommitteeSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


      @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<CommitteeDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(committeeService.search(request), HttpStatus.OK);
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

        final SearchDTO.SearchRs<CommitteeDTO.Info> searchRs = committeeService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/CommitteeByCriteria.jasper", params, jsonDataSource, response);
    }

//    @Loggable
//    @DeleteMapping("/get-category/{id}")
//    public ResponseEntity<Void> getCategory(@PathVariable Long id) {
//        Category category = categoryDAO.getOne(id);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }


}
