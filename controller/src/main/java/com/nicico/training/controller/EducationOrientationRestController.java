package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationOrientationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
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
@RequestMapping(value = "/api/educationOrientation")
public class EducationOrientationRestController {
    private final IEducationOrientationService educationOrientationService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(educationOrientationService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<List<EducationOrientationDTO.Info>> list() {
        return new ResponseEntity<>(educationOrientationService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<EducationOrientationDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<EducationOrientationDTO.Info> searchRs = educationOrientationService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_educationOrientation')")
    public ResponseEntity create(@Validated @RequestBody EducationOrientationDTO.Create request) {
        try {
            return new ResponseEntity<>(educationOrientationService.create(request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationOrientation')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody EducationOrientationDTO.Update request) {
        try {
            return new ResponseEntity<>(educationOrientationService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationOrientation')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            educationOrientationService.delete(id);
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
//    @PreAuthorize("hasAuthority('d_educationOrientation')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EducationOrientationDTO.Delete request) {
        educationOrientationService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.EducationOrientationSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<EducationOrientationDTO.Info> response = educationOrientationService.search(request);

        final EducationOrientationDTO.SpecRs specResponse = new EducationOrientationDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EducationOrientationDTO.EducationOrientationSpecRs specRs = new EducationOrientationDTO.EducationOrientationSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<SearchDTO.SearchRs<EducationOrientationDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(educationOrientationService.search(request), HttpStatus.OK);
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

        final SearchDTO.SearchRs<EducationOrientationDTO.Info> searchRs = educationOrientationService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EducationOrientationByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/spec-list-by-levelId-and-majorId/{levelId}:{majorId}")
//    @PreAuthorize("hasAuthority('r_educationOrientation')")
    public ResponseEntity<EducationOrientationDTO.EducationOrientationSpecRs> listByLevelIdAndMajorId(
            @PathVariable Long levelId, @PathVariable Long majorId) {
        List<EducationOrientationDTO.Info> eduOrientation = educationOrientationService.listByLevelIdAndMajorId(levelId, majorId);
        final EducationOrientationDTO.SpecRs specResponse = new EducationOrientationDTO.SpecRs();
        specResponse.setData(eduOrientation)
                .setStartRow(0)
                .setEndRow(eduOrientation.size())
                .setTotalRows(eduOrientation.size());
        final EducationOrientationDTO.EducationOrientationSpecRs specRs = new EducationOrientationDTO.EducationOrientationSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
