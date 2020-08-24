package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewUnjustifiedAbsenceReportDTO;
import com.nicico.training.iservice.IViewUnjustifiedAbsenceReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/unjustifiedAbsenceReport")
public class ViewUnjustifiedAbsenceReportController {
    private final IViewUnjustifiedAbsenceReportService iViewUnjustifiedAbsenceReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<ViewUnjustifiedAbsenceReportDTO.ViewUnjustifiedAbsenceReportDTOSpecRs> list(@RequestParam(value = "startDate", required = false) String startDate,
                                                                                                @RequestParam(value = "endDate", required = false) String endDate) throws IOException {

        SearchDTO.SearchRq request=new SearchDTO.SearchRq();
        request.setStartIndex(null);
        request.setSortBy("studentId");


        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

        SearchDTO.CriteriaRq criteriaRq=null;

        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.greaterOrEqual);
        criteriaRq.setFieldName("startDate");
        criteriaRq.setValue(startDate);

        listOfCriteria.add(criteriaRq);

        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.lessOrEqual);
        criteriaRq.setFieldName("endDate");
        criteriaRq.setValue(endDate);

        listOfCriteria.add(criteriaRq);


        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setCriteria(listOfCriteria);
        criteriaRq.setOperator(EOperator.and);

        request.setCriteria(criteriaRq);

        SearchDTO.SearchRs result=iViewUnjustifiedAbsenceReportService.search(request, o -> modelMapper.map(o, ViewUnjustifiedAbsenceReportDTO.Info.class));

        final ViewUnjustifiedAbsenceReportDTO.SpecRs specResponse = new ViewUnjustifiedAbsenceReportDTO.SpecRs();
        final ViewUnjustifiedAbsenceReportDTO.ViewUnjustifiedAbsenceReportDTOSpecRs specRs = new ViewUnjustifiedAbsenceReportDTO.ViewUnjustifiedAbsenceReportDTOSpecRs();
        specResponse.setData(result.getList())
                .setStartRow(0)
                .setEndRow(result.getList().size())
                .setTotalRows(result.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
