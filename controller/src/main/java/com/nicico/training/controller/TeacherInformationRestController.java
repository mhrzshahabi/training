package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.ClassStudentService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/teacherInformation")
public class TeacherInformationRestController {
    private final TclassService tclassService;
    private final ModelMapper modelMapper;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = (SearchDTO.SearchRs<T>) tclassService.search(searchRq);

        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/teacher-information-iscList/{courseCode}")
    public ResponseEntity<ISC<TeacherDTO.TeacherFullNameTuple>> scoresList(HttpServletRequest iscRq, @PathVariable String courseCode) throws IOException {
        return search(iscRq, makeNewCriteria("course.code", courseCode, EOperator.equals, null), c -> modelMapper.map(c,TeacherDTO.TeacherFullNameTuple.class));
    }

}
