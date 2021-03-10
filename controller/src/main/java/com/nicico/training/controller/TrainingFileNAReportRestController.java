package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TrainingFileNAReportDTO;
import com.nicico.training.iservice.ITrainingFileNAReportService;
import com.nicico.training.model.TrainingFileNAReport;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/training-file-na-report")
public class TrainingFileNAReportRestController {

    private final ITrainingFileNAReportService trainingFileNAReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<TrainingFileNAReportDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(null);
        return new ResponseEntity<>(ISC.convertToIscRs(trainingFileNAReportService.search(searchRq, e -> modelMapper.map(e, TrainingFileNAReportDTO.Info.class)), 0), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{personnelId}")
    public ResponseEntity<TrainingFileNAReportDTO.TrainingFileNAReportSpecRs> reportList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                 @PathVariable Long personnelId) {

        List<TrainingFileNAReport> trainingFileNAReports = trainingFileNAReportService.reportDetail(personnelId);
        List<TrainingFileNAReportDTO.Info> data = modelMapper.map(trainingFileNAReports, new TypeToken<List<TrainingFileNAReportDTO.Info>>() {
        }.getType());

        List<TrainingFileNAReportDTO.Info> passedCourseList = data.stream().filter(item -> item.getReferenceCourse() == 0).collect(Collectors.toList());
        List<TrainingFileNAReportDTO.Info> equalCourseList = data.stream().filter(item -> item.getReferenceCourse() != 0).collect(Collectors.toList());

        equalCourseList.forEach(eq -> {
            if (!passedCourseList.stream().map(TrainingFileNAReportDTO.Info::getCourseId).collect(Collectors.toList()).contains(eq.getCourseId()))
                passedCourseList.add(eq);
        });

        final TrainingFileNAReportDTO.SpecRs specResponse = new TrainingFileNAReportDTO.SpecRs();
        specResponse.setData(passedCourseList)
                .setStartRow(startRow)
                .setEndRow(startRow + passedCourseList.size())
                .setTotalRows(passedCourseList.size());

        final TrainingFileNAReportDTO.TrainingFileNAReportSpecRs specRs = new TrainingFileNAReportDTO.TrainingFileNAReportSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}