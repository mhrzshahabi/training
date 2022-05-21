package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.ViewUnjustifiedAbsenceReportDTO;
import com.nicico.training.iservice.IViewUnjustifiedAbsenceReportService;
import com.nicico.training.service.BaseService;
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

        listOfCriteria.add(
                CriteriaUtil.createCriteria(EOperator.greaterOrEqual, "startDate", startDate)
        );

        listOfCriteria.add(
                CriteriaUtil.createCriteria(EOperator.lessOrEqual, "endDate", endDate)
        );

        request.setCriteria(
                CriteriaUtil.addCriteria(listOfCriteria, EOperator.and)
        );

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
