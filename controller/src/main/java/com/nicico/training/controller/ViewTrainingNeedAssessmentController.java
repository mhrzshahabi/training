package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;
import com.nicico.training.iservice.IViewTrainingNeedAssessmentService;
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
        SearchDTO.SearchRs result = iViewTrainingNeedAssessmentService.search(searchRq, o -> modelMapper.map(o, ViewTrainingNeedAssessmentDTO.Info.class));
        final ViewTrainingNeedAssessmentDTO.SpecRs specResponse = new ViewTrainingNeedAssessmentDTO.SpecRs();
        final ViewTrainingNeedAssessmentDTO.TrainingNeedAssessmentDTOSpecRs specRs = new ViewTrainingNeedAssessmentDTO.TrainingNeedAssessmentDTOSpecRs();
        specResponse.setData(result.getList()).setStartRow(searchRq.getStartIndex()).setEndRow(searchRq.getStartIndex() + result.getList().size()).setTotalRows(result.getTotalCount().intValue());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
