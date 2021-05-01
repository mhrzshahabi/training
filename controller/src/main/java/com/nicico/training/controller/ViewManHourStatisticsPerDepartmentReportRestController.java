package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewManHourStatisticsPerDepartmentReportDTO;
import com.nicico.training.iservice.IViewManHourStatisticsPerDepartmentReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ViewManHourStatisticsPerDepartmentReport")
public class ViewManHourStatisticsPerDepartmentReportRestController {

    private final IViewManHourStatisticsPerDepartmentReportService iViewManHourStatisticsPerDepartmentReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewManHourStatisticsPerDepartmentReportDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        if (searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null)
        {
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                    if (criterion.getValue().get(0).equals("true"))
                        criterion.setValue(true);

                    else if (criterion.getValue().get(0).equals("false"))
                        criterion.setValue(false);
                }
        }

        return new ResponseEntity<>(ISC.convertToIscRs(iViewManHourStatisticsPerDepartmentReportService.search(searchRq, o -> modelMapper.map(o, ViewManHourStatisticsPerDepartmentReportDTO.Grid.class)), searchRq.getStartIndex()), HttpStatus.OK);
    }

}