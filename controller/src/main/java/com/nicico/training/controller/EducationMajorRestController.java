package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationMajorDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationMajorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
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
@RequestMapping(value = "/api/educationMajor")
public class EducationMajorRestController {
    private final IEducationMajorService educationMajorService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<EducationMajorDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationMajorService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<List<EducationMajorDTO.Info>> list() {
        return new ResponseEntity<>(educationMajorService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<EducationMajorDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<EducationMajorDTO.Info> searchRs = educationMajorService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_educationMajor')")
    public ResponseEntity create(@Validated @RequestBody EducationMajorDTO.Create request) {
//        EducationMajorDTO.Info educationMajorInfo = educationMajorService.create(request);
//        if (educationMajorInfo != null)
//            return new ResponseEntity<>(educationMajorInfo, HttpStatus.CREATED);
//        else
//            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        try {
            return new ResponseEntity<>(educationMajorService.create(request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationMajor')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody EducationMajorDTO.Update request) {
//        EducationMajorDTO.Info educationMajorInfo = educationMajorService.update(id, request);
//        if (educationMajorInfo != null)
//            return new ResponseEntity<>(educationMajorInfo, HttpStatus.OK);
//        else
//            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        try {
            return new ResponseEntity<>(educationMajorService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationMajor')")
    public ResponseEntity delete(@PathVariable Long id) {
//        if (educationMajorService.delete(id))
//            return new ResponseEntity<>(HttpStatus.OK);
//        else {
//            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
//        }
        try {
            educationMajorService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    null,
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationMajor')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationMajorDTO.Delete request) {
        educationMajorService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<EducationMajorDTO.EducationMajorSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                       @RequestParam(value = "_endRow", defaultValue = "75") Integer endRow) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationMajorDTO.Info> response = educationMajorService.search(request);

        final EducationMajorDTO.SpecRs specResponse = new EducationMajorDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationMajorDTO.EducationMajorSpecRs specRs = new EducationMajorDTO.EducationMajorSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list-by-id")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<EducationMajorDTO.EducationMajorSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                       @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                                       @RequestParam(value = "operator", required = false) String operator,
                                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                                       @RequestParam(value = "id", required = false) Long id,
                                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException{
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
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<EducationMajorDTO.Info> response = educationMajorService.search(request);
        final EducationMajorDTO.SpecRs specResponse = new EducationMajorDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationMajorDTO.EducationMajorSpecRs specRs = new EducationMajorDTO.EducationMajorSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationMajor')")
    public ResponseEntity<SearchDTO.SearchRs<EducationMajorDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationMajorService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "/spec-list-by-majorId/{id}")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.EducationOrientationSpecRs> listByMajorId(@PathVariable Long id) {
        List<EducationOrientationDTO.Info> eduOrientation = educationMajorService.listByMajorId(id);
        final EducationOrientationDTO.SpecRs specResponse = new EducationOrientationDTO.SpecRs();
        specResponse.setData(eduOrientation)
                .setStartRow(0)
                .setEndRow(eduOrientation.size())
                .setTotalRows(eduOrientation.size());
        final EducationOrientationDTO.EducationOrientationSpecRs specRs = new EducationOrientationDTO.EducationOrientationSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
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

        final SearchDTO.SearchRs<EducationMajorDTO.Info> searchRs = educationMajorService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EducationMajorByCriteria.jasper", params, jsonDataSource, response);
    }

}
