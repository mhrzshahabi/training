package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/needAssessmentInRange")
public class ViewNeedAssessmentInRangeController {

    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list/{startDate}/{endDate}")
    public ResponseEntity<ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs> list(HttpServletRequest iscRq, @PathVariable String startDate,@PathVariable String endDate) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

//        SearchDTO.CriteriaRq criteriaRq=null;
//
//        SimpleDateFormat formatter = new SimpleDateFormat("DD-MM-YYYY");



//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.greaterOrEqual);
//        criteriaRq.setFieldName("updateAt");
//        criteriaRq.setValue(formatter.format(startDate));
//
//        listOfCriteria.add(criteriaRq);
//
//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.lessOrEqual);
//        criteriaRq.setFieldName("updateAt");
//        criteriaRq.setValue(formatter.format(startDate));
//
//        listOfCriteria.add(criteriaRq);
//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setCriteria(listOfCriteria);
//        criteriaRq.setOperator(EOperator.and);
//
//        searchRq.setCriteria(criteriaRq);

        SearchDTO.SearchRs result = iViewNeedAssessmentInRangeTimeService.search(searchRq, o -> modelMapper.map(o, ViewNeedAssessmentInRangeDTO.Info.class));
        final ViewNeedAssessmentInRangeDTO.SpecRs specResponse = new ViewNeedAssessmentInRangeDTO.SpecRs();
        final ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs specRs = new ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs();
        specResponse.setData(result.getList()).setStartRow(searchRq.getStartIndex()).setEndRow(searchRq.getStartIndex() + result.getList().size()).setTotalRows(result.getTotalCount().intValue());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);




    }
}
