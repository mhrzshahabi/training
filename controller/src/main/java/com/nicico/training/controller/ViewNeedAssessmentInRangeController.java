package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
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
@RequestMapping(value = "/api/needAssessmentInRange")
public class ViewNeedAssessmentInRangeController {

    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result=iViewNeedAssessmentInRangeTimeService.search(searchRq, o -> modelMapper.map(o, ViewNeedAssessmentInRangeDTO.Info.class));
        final ViewNeedAssessmentInRangeDTO.SpecRs specResponse = new ViewNeedAssessmentInRangeDTO.SpecRs();
        final ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs specRs = new ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs();
        specResponse.setData(result.getList())
         .setStartRow(searchRq.getStartIndex())
                .setEndRow(searchRq.getStartIndex() + result.getList().size())
                .setTotalRows(result.getTotalCount().intValue());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
