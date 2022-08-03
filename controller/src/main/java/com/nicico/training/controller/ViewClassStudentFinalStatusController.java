package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassCourseFinalStatusDTO;
import com.nicico.training.dto.ViewClassStudentFinalStatusDTO;
import com.nicico.training.iservice.IViewClassCourseFinalStatusService;
import com.nicico.training.iservice.IViewClassStudentFinalStatusService;
import com.nicico.training.model.ViewClassStudentFinalStatusReport;
import com.nicico.training.repository.ViewClassStudentFinalStatusDAO;
import com.nicico.training.service.ViewClassStudentFinalStatusService;
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
@RequestMapping(value = "/api/class-student-final-status-report")
public class ViewClassStudentFinalStatusController {

    private final IViewClassStudentFinalStatusService iViewClassStudentFinalStatusService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewClassStudentFinalStatusDTO.TrainingClassStudentFinalStatusDTOSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewClassStudentFinalStatusService.search(searchRq, o -> modelMapper.map(o, ViewClassStudentFinalStatusDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
