package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/needAssessmentInRange")
public class ViewNeedAssessmentInRangeController {

    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        Long endDateValue = (Long) searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).getValue().get(0);
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(endDateValue);
        calendar.set(Calendar.HOUR, 11);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 59);
        calendar.set(Calendar.AM_PM, Calendar.PM);
        searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).setValue(calendar.getTimeInMillis());

        SearchDTO.SearchRs result = iViewNeedAssessmentInRangeTimeService.search(searchRq, o -> modelMapper.map(o, ViewNeedAssessmentInRangeDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list/{startDate}/{endDate}")
    public ResponseEntity<ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs> list(HttpServletRequest iscRq, @PathVariable String startDate,@PathVariable String endDate) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

        SearchDTO.CriteriaRq criteriaRq=null;

        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date parsedDate = dateFormat.parse(String.format("%s 00:00:00", startDate));
            Date parsedDate2 = dateFormat.parse(String.format("%s 23:59:59", endDate));
            Timestamp firstTime = new Timestamp(parsedDate.getTime());
            Timestamp secondDate = new Timestamp(parsedDate2.getTime());

            criteriaRq=new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.greaterOrEqual);
            criteriaRq.setFieldName("updateAt");
            criteriaRq.setValue(new Date(firstTime.getTime()));

            listOfCriteria.add(criteriaRq);

            criteriaRq=new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.lessOrEqual);
            criteriaRq.setFieldName("updateAt");
            criteriaRq.setValue(new Date(secondDate.getTime()));
        } catch(Exception e) { //this generic but you can control another types of exception
            // look the origin of excption
        }




        listOfCriteria.add(criteriaRq);
        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setCriteria(listOfCriteria);
        criteriaRq.setOperator(EOperator.and);

        searchRq.setCriteria(criteriaRq);

        SearchDTO.SearchRs result = iViewNeedAssessmentInRangeTimeService.search(searchRq, o -> modelMapper.map(o, ViewNeedAssessmentInRangeDTO.Info.class));
        final ViewNeedAssessmentInRangeDTO.SpecRs specResponse = new ViewNeedAssessmentInRangeDTO.SpecRs();
        final ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs specRs = new ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs();
        specResponse.setData(result.getList()).setStartRow(searchRq.getStartIndex()).setEndRow(searchRq.getStartIndex() + result.getList().size()).setTotalRows(result.getTotalCount().intValue());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
