package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacher")
public class TeacherRestController {

    private final ITeacherService teacherService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(teacherService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<List<TeacherDTO.Info>> list() {
        return new ResponseEntity<>(teacherService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_teacher')")
    public ResponseEntity<TeacherDTO.Info> create(@RequestBody Object request) {
        TeacherDTO.Create create = modelMapper.map(request, TeacherDTO.Create.class);
        return new ResponseEntity<>(teacherService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_teacher')")
    public ResponseEntity<TeacherDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        ((LinkedHashMap) request).remove("attachPic");
        ((LinkedHashMap) request).remove("categoryList");
        ((LinkedHashMap) request).remove("categories");
        TeacherDTO.Update update = modelMapper.map(request, TeacherDTO.Update.class);
        return new ResponseEntity<>(teacherService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        try {
            teacherService.delete(id);
            return new ResponseEntity(true, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(false, HttpStatus.NO_CONTENT);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity delete(@Validated @RequestBody TeacherDTO.Delete request) {
        teacherService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                         @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                         @RequestParam(value = "id", required = false) Long id,
                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

        SearchDTO.SearchRs<TeacherDTO.Info> response = teacherService.search(request);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/fullName-list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameList(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", required = false, defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "id", required = false) Long id,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

        SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> response = teacherService.fullNameSearch(request);

        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/fullName-list/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameListFilter(@PathVariable Long id,
                                                                               @RequestParam("_startRow") Integer startRow,
                                                                               @RequestParam("_endRow") Integer endRow,
                                                                               @RequestParam(value = "_constructor", required = false) String constructor,
                                                                               @RequestParam(value = "operator", required = false) String operator,
                                                                               @RequestParam(value = "criteria", required = false) String criteria,
                                                                               @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, null, sortBy);

        SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> response = teacherService.fullNameSearch(request);

        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<SearchDTO.SearchRs<TeacherDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(teacherService.search(request), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addCategories/{teacherId}")
    @Transactional
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity addCategories(@Validated @RequestBody CategoryDTO.Delete request, @PathVariable Long teacherId) {
        teacherService.addCategories(request, teacherId);
        return new ResponseEntity(HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/getCategories/{teacherId}")
    @Transactional
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity<List<Long>> getCategories(@PathVariable Long teacherId) {
        List<Long> categorySet = teacherService.getCategories(teacherId);
        return new ResponseEntity(categorySet, HttpStatus.OK);
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

        final SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/TeacherByCriteria.jasper", params, jsonDataSource, response);
    }

    private SearchDTO.SearchRq setSearchCriteria(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                 @RequestParam(value = "operator", required = false) String operator,
                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                 @RequestParam(value = "id", required = false) Long id,
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
        if(id != null){
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow=0;
            endRow=1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        return request;
    }

}