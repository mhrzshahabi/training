package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.TClassStudentDTO;
import com.nicico.training.service.TClassStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tclass-student")
public class TClassStudentRestController {
    private final TClassStudentService tClassStudentService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/students-iscList/{classId}")
    public ResponseEntity<ISC<TClassStudentDTO.TClassStudentInfo>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TClassStudentDTO.TClassStudentInfo> searchRs = tClassStudentService.searchClassStudents(searchRq, classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/register-students/{classId}")
    public ResponseEntity registerStudents(@RequestBody List<TClassStudentDTO.Create> request, @PathVariable Long classId) {
        try {
            tClassStudentService.registerStudents(request, classId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody TClassStudentDTO.Update request) {
        try {
            return new ResponseEntity<>(tClassStudentService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity removeStudents(@RequestBody TClassStudentDTO.Delete request) {
        try {
            tClassStudentService.delete(request);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            tClassStudentService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

//    @Loggable
//    @GetMapping(value = "/{id}")
//    public ResponseEntity<TClassStudentDTO.Info> get(@PathVariable Long id) {
//        return new ResponseEntity<>(tClassStudentService.get(id), HttpStatus.OK);
//    }
//
//    @Loggable
//    @GetMapping(value = "/list")
//    public ResponseEntity<List<TClassStudentDTO.Info>> list() {
//        return new ResponseEntity<>(tClassStudentService.list(), HttpStatus.OK);
//    }
//
//    @Loggable
//    @PostMapping
//    public ResponseEntity<TClassStudentDTO.Info> create(@RequestBody Object req) {
//        TClassStudentDTO.Create create = modelMapper.map(req, TClassStudentDTO.Create.class);
//        return new ResponseEntity<>(tClassStudentService.create(create), HttpStatus.CREATED);
//    }
//
//    @Loggable
//    @PutMapping(value = "/{id}")
//    public ResponseEntity<TClassStudentDTO.Info> update(@PathVariable Long id, @RequestBody TClassStudentDTO.Update request) {
//        //TClassStudentDTO.Update update = modelMapper.map(request, TClassStudentDTO.Update.class);
//        return new ResponseEntity<>(tClassStudentService.update(id, request), HttpStatus.OK);
//    }
//
//    @Loggable
//    @DeleteMapping(value = "/list")
//    public ResponseEntity<Void> delete(@Validated @RequestBody TClassStudentDTO.Delete request) {
//        tClassStudentService.delete(request);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }
//
//
//    @Loggable
//    @GetMapping(value = "/spec-list")
//    public ResponseEntity<TClassStudentDTO.ClassStudentSpecRs> list(@RequestParam("_startRow") Integer startRow,
//                                                                    @RequestParam("_endRow") Integer endRow,
//                                                                    @RequestParam(value = "_constructor", required = false) String constructor,
//                                                                    @RequestParam(value = "operator", required = false) String operator,
//                                                                    @RequestParam(value = "criteria", required = false) String criteria,
//                                                                    @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//
//        SearchDTO.CriteriaRq criteriaRq;
//        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
//            criteria = "[" + criteria + "]";
//            criteriaRq = new SearchDTO.CriteriaRq();
//            criteriaRq.setOperator(EOperator.valueOf(operator))
//                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
//                    }));
//            request.setCriteria(criteriaRq);
//        }
//        if (StringUtils.isNotEmpty(sortBy)) {
//            request.setSortBy(sortBy);
//        }
//
//        request.setStartIndex(startRow)
//                .setCount(endRow - startRow);
//
//        SearchDTO.SearchRs<TClassStudentDTO.Info> response = tClassStudentService.search(request);
//
//        final TClassStudentDTO.SpecRs specResponse = new TClassStudentDTO.SpecRs();
//        specResponse.setData(response.getList())
//                .setStartRow(startRow)
//                .setEndRow(startRow + response.getTotalCount().intValue())
//                .setTotalRows(response.getTotalCount().intValue());
//
//        final TClassStudentDTO.ClassStudentSpecRs specRs = new TClassStudentDTO.ClassStudentSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//
//    @Loggable
//    @PostMapping(value = "/search")
//    public ResponseEntity<SearchDTO.SearchRs<TClassStudentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
//        return new ResponseEntity<>(tClassStudentService.search(request), HttpStatus.OK);
//    }
//
//
//    @Loggable
//    @GetMapping(value = "/{getStudent}/{id}")
//    public ResponseEntity<TClassStudentDTO.ClassStudentSpecRs> getStudent(@PathVariable Long id) {
//
//        List<TClassStudentDTO.Info> list = tClassStudentService.getStudent(id);
//        final TClassStudentDTO.SpecRs specResponse = new TClassStudentDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow(list.size())
//                .setTotalRows(list.size());
//        final TClassStudentDTO.ClassStudentSpecRs specRs = new TClassStudentDTO.ClassStudentSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }
//
//    @GetMapping(value = "/iscList/{classId}")
//    public ResponseEntity<ISC<TClassStudentDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
//        int startRow = 0;
//        if (iscRq.getParameter("_startRow") != null)
//            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
//        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
//        SearchDTO.SearchRs<TClassStudentDTO.Info> searchRs = tClassStudentService.search1(searchRq, classId);
//        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
//    }
//
//    @Loggable
//    @PostMapping(value = "/edit")
//    public ResponseEntity<TClassStudentDTO.Info> updateDescription(@RequestParam MultiValueMap<String, String> body) throws IOException {
//        return new ResponseEntity(tClassStudentService.updateDescriptionCheck(body), HttpStatus.OK);
//    }


}
