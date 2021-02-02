package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PresenceReportViewDTO;
import com.nicico.training.dto.ViewClassDetailDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;
import com.nicico.training.dto.ViewTrainingOverTimeReportDTO;
import com.nicico.training.iservice.IViewTrainingNeedAssessmentService;
import com.nicico.training.iservice.IViewTrainingOverTimeReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/trainingNeedAssessment")
public class ViewTrainingNeedAssessmentController {

    private final IViewTrainingNeedAssessmentService iViewTrainingNeedAssessmentService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ViewTrainingNeedAssessmentDTO.TrainingNeedAssessmentDTOSpecRs> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result=iViewTrainingNeedAssessmentService.search(searchRq, o -> modelMapper.map(o, ViewTrainingNeedAssessmentDTO.Info.class));
        final ViewTrainingNeedAssessmentDTO.SpecRs specResponse = new ViewTrainingNeedAssessmentDTO.SpecRs();
        final ViewTrainingNeedAssessmentDTO.TrainingNeedAssessmentDTOSpecRs specRs = new ViewTrainingNeedAssessmentDTO.TrainingNeedAssessmentDTOSpecRs();
        specResponse.setData(result.getList())
         .setStartRow(searchRq.getStartIndex())
                .setEndRow(searchRq.getStartIndex() + result.getList().size())
                .setTotalRows(result.getTotalCount().intValue());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
