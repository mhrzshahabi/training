package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.EOperator;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
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
    private final ModelMapper modelMapper;

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
    public ResponseEntity<TclassDTO.Info> update(@PathVariable Long id, @Validated @RequestBody TclassDTO.Update request) {
        return new ResponseEntity<>(tclassService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tclassService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity<Void> delete(@Validated @RequestBody TclassDTO.Delete request) {
        tclassService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

            if (StringUtils.isNotEmpty(sortBy)) {
                criteriaRq.set_sortBy(sortBy);
            }

            request.setCriteria(criteriaRq);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);
        TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
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

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Tclass.jasper", params, response);
    }

    @Loggable
    @GetMapping(value = "/student")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<StudentDTO.StudentSpecRs> getStudents(@RequestParam("classID") String classID) {
        Long classId = Long.parseLong(classID);

        List<StudentDTO.Info> studentList = tclassService.getStudents(classId);

        final StudentDTO.SpecRs specResponse = new StudentDTO.SpecRs();
        specResponse.setData(studentList)
                .setStartRow(0)
                .setEndRow(studentList.size())
                .setTotalRows(studentList.size());

        final StudentDTO.StudentSpecRs specRs = new StudentDTO.StudentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/otherStudent")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<StudentDTO.StudentSpecRs> getOtherStudents(@RequestParam("classID") String classID) {
        Long classId = Long.parseLong(classID);

        List<StudentDTO.Info> studentList = tclassService.getOtherStudents(classId);

        final StudentDTO.SpecRs specResponse = new StudentDTO.SpecRs();
        specResponse.setData(studentList)
                .setStartRow(0)
                .setEndRow(studentList.size())
                .setTotalRows(studentList.size());

        final StudentDTO.StudentSpecRs specRs = new StudentDTO.StudentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removeStudent/{studentId}/{classId}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removeStudent(@PathVariable Long studentId,@PathVariable Long classId) {
        tclassService.removeStudent(studentId,classId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addStudent/{studentId}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void>  addStudent(@PathVariable Long studentId,@PathVariable Long classId) {
        tclassService.addStudent(studentId,classId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addStudents/{classId}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity<Void> addStudents(@Validated @RequestBody StudentDTO.Delete request,@PathVariable Long classId) {
        tclassService.addStudents(request,classId);
        return new ResponseEntity(HttpStatus.OK);
    }

}
