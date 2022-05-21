package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IViewTrainingOverTimeReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

import static com.nicico.training.controller.util.CriteriaUtil.*;
import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/trainingOverTime")
public class ViewTrainingOverTimeController {

    private final IViewTrainingOverTimeReportService iTrainingOverTimeReportService;
    private final ModelMapper modelMapper;


    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = iTrainingOverTimeReportService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/minList")
    @Transactional(readOnly = true)
    public ResponseEntity<ISC<ViewTrainingOverTimeReportDTO.TrainingOverTimeReportDTOSpecRs>> minlist(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, r -> modelMapper.map(r, ViewTrainingOverTimeReportDTO.TrainingOverTimeReportDTOSpecRs.class));
    }

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<ViewTrainingOverTimeReportDTO.TrainingOverTimeReportDTOSpecRs> list( @RequestParam(value = "startDate", required = false) String startDate,
                                                                             @RequestParam(value = "endDate", required = false) String endDate) throws IOException {

        SearchDTO.SearchRq request=new SearchDTO.SearchRq();
        request.setStartIndex(null);
        request.setSortBy("personalNum2");


        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

//        SearchDTO.CriteriaRq criteriaRq=null;
//
//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.greaterOrEqual);
//        criteriaRq.setFieldName("date");
//        criteriaRq.setValue(startDate);
//
//        listOfCriteria.add(criteriaRq);
        listOfCriteria.add(
                createCriteria(EOperator.greaterOrEqual, "date", startDate)
        );
//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.lessOrEqual);
//        criteriaRq.setFieldName("date");
//        criteriaRq.setValue(endDate);


        listOfCriteria.add(
                createCriteria(EOperator.lessOrEqual, "date", endDate)
        );



//        criteriaRq=new SearchDTO.CriteriaRq();
//        criteriaRq.setCriteria(listOfCriteria);
//        criteriaRq.setOperator(EOperator.and);
//
//        request.setCriteria(criteriaRq);
        request.setCriteria(
                addCriteria(listOfCriteria, EOperator.and)
        );
        SearchDTO.SearchRs result=iTrainingOverTimeReportService.search(request, o -> modelMapper.map(o, ViewTrainingOverTimeReportDTO.Info.class));

        final ViewTrainingOverTimeReportDTO.SpecRs specResponse = new ViewTrainingOverTimeReportDTO.SpecRs();
        final ViewTrainingOverTimeReportDTO.TrainingOverTimeReportDTOSpecRs specRs = new ViewTrainingOverTimeReportDTO.TrainingOverTimeReportDTOSpecRs();
        specResponse.setData(result.getList())
                .setStartRow(0)
                .setEndRow(result.getList().size())
                .setTotalRows(result.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
