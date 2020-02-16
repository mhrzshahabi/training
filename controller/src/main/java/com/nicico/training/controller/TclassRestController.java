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
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.ClassAlarmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
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
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/tclass")
public class TclassRestController {

    private final ITclassService tclassService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ClassAlarmService classAlarmService;
    private final StudentDAO studentDAO;


//    @Loggable
//    @GetMapping(value = "/student/{classId}")
////    @PreAuthorize("hasAuthority('r_tclass')")
//    public ResponseEntity<StudentDTO.StudentSpecRs> getStudentsByClassID(@PathVariable String classID) {
//        Long classId = Long.parseLong(classID);
//
//        List<StudentDTO.Info> studentList = tclassService.getStudents(classId);
//
//        final StudentDTO.SpecRs specResponse = new StudentDTO.SpecRs();
//        specResponse.setData(studentList)
//                .setStartRow(0)
//                .setEndRow(studentList.size())
//                .setTotalRows(studentList.size());
//
//        final StudentDTO.StudentSpecRs specRs = new StudentDTO.StudentSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }


    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(tclassService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<List<TclassDTO.Info>> list() {
        return new ResponseEntity<>(tclassService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<TclassDTO.Info> create(@Validated @RequestBody TclassDTO.Create request) {
        return new ResponseEntity<>(tclassService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<TclassDTO.Info> update(@PathVariable Long id, @RequestBody TclassDTO.Update request) {
        return new ResponseEntity<>(tclassService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            tclassService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@Validated @RequestBody TclassDTO.Delete request) {
        tclassService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);

        for (TclassDTO.Info tclassDTO : response.getList()) {
            if (classAlarmService.hasAlarm(tclassDTO.getId(), httpResponse).size() > 0)
                tclassDTO.setHasWarning("alarm");
            else
                tclassDTO.setHasWarning("");
        }

        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/tuple-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> tupleList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                            @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                            @RequestParam(value = "_constructor", required = false) String constructor,
                                                            @RequestParam(value = "operator", required = false) String operator,
                                                            @RequestParam(value = "criteria", required = false) String criteria,
                                                            @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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
        request.setStartIndex(startRow).setCount(endRow - startRow);
        request.setDistinct(true);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);
        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list-evaluated")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassEvaluatedSpecRs> evaluatedList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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

        SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> response = tclassService.evaluatedSearch(request);

        final TclassDTO.EvaluatedSpecRs specResponse = new TclassDTO.EvaluatedSpecRs();
        final TclassDTO.TclassEvaluatedSpecRs specRs = new TclassDTO.TclassEvaluatedSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SearchDTO.SearchRs<TclassDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(tclassService.search(request), HttpStatus.OK);
    }


//    @Loggable
//    @GetMapping(value = "/otherStudent")
////    @PreAuthorize("hasAuthority('r_tclass')")
//    public ResponseEntity<StudentDTO.StudentSpecRs> getOtherStudents(@RequestParam("classID") String classID) {
//        Long classId = Long.parseLong(classID);
//
//        List<StudentDTO.Info> studentList = tclassService.getOtherStudents(classId);
//
//        final StudentDTO.SpecRs specResponse = new StudentDTO.SpecRs();
//        specResponse.setData(studentList)
//                .setStartRow(0)
//                .setEndRow(studentList.size())
//                .setTotalRows(studentList.size());
//
//        final StudentDTO.StudentSpecRs specRs = new StudentDTO.StudentSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }

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

        final SearchDTO.SearchRs<TclassDTO.Info> searchRs = tclassService.search(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
    }
    //----------------------------------------------------

    @Loggable
    @GetMapping(value = "/end_group/{courseId}/{termId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Long> getEndGroup(@PathVariable Long courseId, @PathVariable Long termId) {
        return new ResponseEntity<>(tclassService.getEndGroup(courseId, termId), HttpStatus.OK);
    }

/////////////////////
    //////////////////////////
    ////////////////////////////

    @Loggable
    @PostMapping(value = "/checkStudentInClass/{nationalCode}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Long> checkStudentInClass(@PathVariable String nationalCode, @PathVariable Long classId) {

        if (((studentDAO.findOneByNationalCodeInClass(nationalCode, classId)) != null)) {
            return null;
        }
        List<Long> classList = (studentDAO.findOneByNationalCodeInClass(nationalCode, classId));
        return new ResponseEntity<Long>((MultiValueMap<String, String>) classList, HttpStatus.OK);

    }


    @Loggable
    @GetMapping(value = "/checkEndingClass/{classId}")
    public String checkEndingClass(@PathVariable Long classId, HttpServletResponse response) throws IOException {

        return classAlarmService.checkAlarmsForEndingClass(classId, response);

    }

    @Loggable
    @GetMapping(value = "/getWorkflowEndingStatusCode/{classId}")
    public Integer getWorkflowEndingStatusCode(@PathVariable Long classId) {
        return tclassService.getWorkflowEndingStatusCode(classId);
    }

    @Loggable
    @GetMapping(value = "/evaluationResult/{classId}")
    public ResponseEntity<TclassDTO.ReactionEvaluationResult> getEvaluationResult(@PathVariable Long classId) {
        return new ResponseEntity<TclassDTO.ReactionEvaluationResult>(tclassService.getReactionEvaluationResult(classId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity<List<String>> getPreCourseTestQuestions(@PathVariable Long classId) {
        return new ResponseEntity<>(tclassService.getPreCourseTestQuestions(classId), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity updatePreCourseTestQuestions(@PathVariable Long classId, @RequestBody List<String> request) {
        try {
            tclassService.updatePreCourseTestQuestions(classId, request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

}
