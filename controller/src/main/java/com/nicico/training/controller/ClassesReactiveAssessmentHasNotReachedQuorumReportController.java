package com.nicico.training.controller;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassesReactiveAssessmentHasNotReachedQuorumDTO;
import com.nicico.training.iservice.IClassesReactiveAssessmentHasNotReachedQuorumService;
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
@RequestMapping(value = "/api/classesReactiveAssessment-HasNotReached-Quorum-report")
public class ClassesReactiveAssessmentHasNotReachedQuorumReportController {

    private final IClassesReactiveAssessmentHasNotReachedQuorumService notReachedQuorumService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ClassesReactiveAssessmentHasNotReachedQuorumDTO.ClassesReactiveAssessmentHasNotReachedQuorumDTOSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs result = notReachedQuorumService.search(searchRq, o -> modelMapper.map(o, ClassesReactiveAssessmentHasNotReachedQuorumDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
