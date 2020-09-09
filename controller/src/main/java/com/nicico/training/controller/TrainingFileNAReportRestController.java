package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.TrainingFileNAReportDTO;
import com.nicico.training.iservice.ITrainingFileNAReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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


    @GetMapping(value = {"/generate-report"})
    public void generateReport(final HttpServletRequest iscRq,
                               final HttpServletResponse response) throws Exception {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(null);

        List<TrainingFileNAReportDTO.Info> list = modelMapper.map(trainingFileNAReportService.search(searchRq, e -> modelMapper.map(e, TrainingFileNAReportDTO.Info.class)).getList(), new TypeToken<List<TrainingFileNAReportDTO.Info>>() {
        }.getType());

        trainingFileNAReportService.generateReport(response, list);

    }
}