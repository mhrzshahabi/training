package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.service.ClassStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/classStudent")
public class ClassStudentRestController {
   private final ClassStudentService classStudentService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

     @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<ClassStudentDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(classStudentService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<ClassStudentDTO.Info>> list() {
        return new ResponseEntity<>(classStudentService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<ClassStudentDTO.Info> create(@RequestBody Object req) {
        ClassStudentDTO.Create create = modelMapper.map(req, ClassStudentDTO.Create.class);
        return new ResponseEntity<>(classStudentService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<ClassStudentDTO.Info> update(@PathVariable Long id, @RequestBody ClassStudentDTO.Update request) {
        //ClassStudentDTO.Update update = modelMapper.map(request, ClassStudentDTO.Update.class);
       return new ResponseEntity<>(classStudentService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody ClassStudentDTO.Delete request) {
        classStudentService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ClassStudentDTO.ClassStudentSpecRs> list(@RequestParam("_startRow") Integer startRow,
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

        SearchDTO.SearchRs<ClassStudentDTO.Info> response = classStudentService.search(request);

        final ClassStudentDTO.SpecRs specResponse = new ClassStudentDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final ClassStudentDTO.ClassStudentSpecRs specRs = new ClassStudentDTO.ClassStudentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<ClassStudentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(classStudentService.search(request), HttpStatus.OK);
    }


     @Loggable
    @GetMapping(value = "/{getStudent}/{id}")
    public ResponseEntity<ClassStudentDTO.ClassStudentSpecRs> getStudent(@PathVariable Long id) {

        List<ClassStudentDTO.Info> list = classStudentService.getStudent(id);
        final ClassStudentDTO.SpecRs specResponse = new ClassStudentDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final ClassStudentDTO.ClassStudentSpecRs specRs = new ClassStudentDTO.ClassStudentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

           @GetMapping(value = "/iscList/{classId}")
       public ResponseEntity<ISC<ClassStudentDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
        startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassStudentDTO.Info> searchRs =classStudentService.search1(searchRq, classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

     @Loggable
    @PostMapping(value = "/edit")
    public ResponseEntity<ClassStudentDTO.Info> updateDescription(@RequestParam MultiValueMap<String, String> body) throws IOException {
        return new ResponseEntity(classStudentService.updateDescriptionCheck(body), HttpStatus.OK);
    }



    }
