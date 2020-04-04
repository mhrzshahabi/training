package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.PolisDTO;
import com.nicico.training.dto.ProvinceDTO;
import com.nicico.training.model.Polis;
import com.nicico.training.service.PolisService;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/polis")
public class PolisRestController {

    private final PolisService PolisService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<PolisDTO.Info> get(@PathVariable("id") Long id) {
        return new ResponseEntity<PolisDTO.Info>(PolisService.getInfo(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<PolisDTO.Info>> list() {
        return new ResponseEntity<>(PolisService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<PolisDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(PolisService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{provinceId}")
    public ResponseEntity<TotalResponse<PolisDTO.Info>> getParametersValueListById(@RequestParam MultiValueMap<String, String> criteria, @PathVariable Long provinceId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "provinceId", "equals", provinceId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@Validated @RequestBody Object request, HttpServletResponse response) {
        try {
            PolisDTO.Create create = modelMapper.map(request,PolisDTO.Create.class);
            return new ResponseEntity<>(PolisService.safeCreate(create, response), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable("id") Long id, @Validated @RequestBody Object request, HttpServletResponse response) {
        try {
            PolisDTO.Update update = modelMapper.map(request,PolisDTO.Update.class);
            return new ResponseEntity<>(PolisService.safeUpdate(id, update, response), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
    public ResponseEntity delete(@PathVariable("id") Long id) {
        try {
            return new ResponseEntity<>(PolisService.delete(id),null,HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody PolisDTO.Delete request) {
        PolisService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
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

        final SearchDTO.SearchRs<PolisDTO.Info> searchRs = PolisService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/PolisList.jasper", params, jsonDataSource, response);
    }
}
