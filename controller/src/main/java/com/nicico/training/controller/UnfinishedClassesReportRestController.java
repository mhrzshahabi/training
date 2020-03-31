package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.UnfinishedClassesReportDTO;
import com.nicico.training.service.UnfinishedClassesReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("api/unfinishedClasses")
public class UnfinishedClassesReportRestController {

    private final UnfinishedClassesReportService unfinishedClassesReportService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<UnfinishedClassesReportDTO.UnfinishedClassesSpecRs> list() throws IOException {

        List<UnfinishedClassesReportDTO> list = new ArrayList<>();
        list = unfinishedClassesReportService.UnfinishedClassesList();

        final UnfinishedClassesReportDTO.SpecRs specResponse = new UnfinishedClassesReportDTO.SpecRs();
        final UnfinishedClassesReportDTO.UnfinishedClassesSpecRs specRs = new UnfinishedClassesReportDTO.UnfinishedClassesSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
