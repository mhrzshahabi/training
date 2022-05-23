package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.iservice.IStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/student")
public class StudentRestController {

    private final IStudentService studentService;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final MessageSource messageSource;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_student')")
    public ResponseEntity<StudentDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(studentService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_student')")
    public ResponseEntity<List<StudentDTO.Info>> list() {
        return new ResponseEntity<>(studentService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_student')")
    public ResponseEntity<StudentDTO.Info> create(@Validated @RequestBody StudentDTO.Create request) {
        return new ResponseEntity<>(studentService.create(request), HttpStatus.CREATED);
    }

//    @Loggable
//    @PostMapping
////    @PreAuthorize("hasAuthority('c_student')")
//    public ResponseEntity<StudentDTO.Info> create(@Validated @RequestBody StudentDTO.Create request) {
//        return new ResponseEntity<>(studentService.create(request), HttpStatus.CREATED);
//    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_student')")
    public ResponseEntity<StudentDTO.Info> update(@PathVariable Long id, @Validated @RequestBody StudentDTO.Update request) {
        return new ResponseEntity<>(studentService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_student')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        try {
            studentService.delete(id);
            return new ResponseEntity(true, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(false, HttpStatus.NO_CONTENT);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_student')")
    public ResponseEntity<Void> delete(@Validated @RequestBody StudentDTO.Delete request) {
        studentService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_student')")
    public ResponseEntity<StudentDTO.StudentSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<StudentDTO.Info> response = studentService.search(request);

        final StudentDTO.SpecRs specResponse = new StudentDTO.SpecRs();
        final StudentDTO.StudentSpecRs specRs = new StudentDTO.StudentSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_student')")
    public ResponseEntity<SearchDTO.SearchRs<StudentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(studentService.search(request), HttpStatus.OK);
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

        final SearchDTO.SearchRs<StudentDTO.Info> searchRs = studentService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/StudentByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
//    @PreAuthorize("hasAuthority('r_student')")
    public ResponseEntity getOneByNationalCode(@PathVariable String nationalCode) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
        criteria.getCriteria().add(makeNewCriteria("nationalCode", nationalCode, EOperator.equals, null));
        List<StudentDTO.Info> studentList = studentService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        if (studentList.size() > 0)
            return new ResponseEntity<>(studentList.get(0), HttpStatus.OK);
        return new ResponseEntity<>(messageSource.getMessage("student.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
    }
}
