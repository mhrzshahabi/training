package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewAttendanceReportDTO;
import com.nicico.training.iservice.IAttendanceReportService;
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

import java.util.ArrayList;
import java.util.List;

import static com.nicico.training.controller.util.CriteriaUtil.addCriteria;
import static com.nicico.training.controller.util.CriteriaUtil.createCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/attendanceReport")
public class AttendanceReportController {
    private final IAttendanceReportService iAttendanceReportService;

    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<ViewAttendanceReportDTO.AttendanceReportDTOSpecRs> list(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "absentType", required = false) String absecntType) {



        SearchDTO.SearchRq request=new SearchDTO.SearchRq();
        request.setStartIndex(null);

        request.setSortBy("personalNum");
        /*
        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

        SearchDTO.CriteriaRq criteriaRq=null;

        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.greaterOrEqual);
        criteriaRq.setFieldName("date");
        criteriaRq.setValue(startDate);

        listOfCriteria.add(criteriaRq);

        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.lessOrEqual);
        criteriaRq.setFieldName("date");
        criteriaRq.setValue(endDate);

        listOfCriteria.add(criteriaRq);

        switch (absecntType)
        {
            case "3": {
                SearchDTO.CriteriaRq criteriaRq2=new SearchDTO.CriteriaRq();
                criteriaRq2.setOperator(EOperator.or);
                criteriaRq2.setCriteria(new ArrayList<>());

                criteriaRq=new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.equals);
                criteriaRq.setFieldName("attendanceStatus");
                criteriaRq.setValue(3);

                criteriaRq2.getCriteria().add(criteriaRq);

                listOfCriteria.add(criteriaRq2);
                break;
            }
            case "4": {
                SearchDTO.CriteriaRq criteriaRq2=new SearchDTO.CriteriaRq();
                criteriaRq2.setOperator(EOperator.or);
                criteriaRq2.setCriteria(new ArrayList<>());

                criteriaRq=new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.equals);
                criteriaRq.setFieldName("attendanceStatus");
                criteriaRq.setValue(4);

                criteriaRq2.getCriteria().add(criteriaRq);

                listOfCriteria.add(criteriaRq2);
                break;
            }
            default: {
                SearchDTO.CriteriaRq criteriaRq2=new SearchDTO.CriteriaRq();
                criteriaRq2.setOperator(EOperator.or);
                criteriaRq2.setCriteria(new ArrayList<>());

                criteriaRq=new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.equals);
                criteriaRq.setFieldName("attendanceStatus");
                criteriaRq.setValue(4);
                criteriaRq2.getCriteria().add(criteriaRq);


                criteriaRq=new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.equals);
                criteriaRq.setFieldName("attendanceStatus");
                criteriaRq.setValue(3);
                criteriaRq2.getCriteria().add(criteriaRq);

                listOfCriteria.add(criteriaRq2);
                break;
            }
        }

        criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setCriteria(listOfCriteria);
        criteriaRq.setOperator(EOperator.and);

        request.setCriteria(criteriaRq);

         */

        List<SearchDTO.CriteriaRq> listOfCriteria=new ArrayList<>();

        listOfCriteria.add(
                createCriteria(EOperator.greaterOrEqual, "date", startDate)
        );

        listOfCriteria.add(
                createCriteria(EOperator.lessOrEqual, "date", endDate)
        );

        switch (absecntType) {
            case "3" -> {
                SearchDTO.CriteriaRq criteriaRq = addCriteria(new ArrayList<>(), EOperator.or);
                criteriaRq.getCriteria().add(createCriteria(EOperator.equals, "attendanceStatus", 3));

                listOfCriteria.add(criteriaRq);
            }
            case "4" -> {
                SearchDTO.CriteriaRq criteriaRq = addCriteria(new ArrayList<>(), EOperator.or);
                criteriaRq.getCriteria().add(createCriteria(EOperator.equals, "attendanceStatus", 4));
                listOfCriteria.add(criteriaRq);
            }
            default -> {
                SearchDTO.CriteriaRq criteriaRq = addCriteria(new ArrayList<>(), EOperator.or);
                criteriaRq.getCriteria().add(createCriteria(EOperator.equals, "attendanceStatus", 4));
                listOfCriteria.add(createCriteria(EOperator.equals, "attendanceStatus", 3));
            }
        }

        request.setCriteria(addCriteria(listOfCriteria, EOperator.and));

        SearchDTO.SearchRs result=iAttendanceReportService.search(request, o -> modelMapper.map(o,ViewAttendanceReportDTO.Info.class));

        final ViewAttendanceReportDTO.SpecRs specResponse = new ViewAttendanceReportDTO.SpecRs();
        final ViewAttendanceReportDTO.AttendanceReportDTOSpecRs specRs = new ViewAttendanceReportDTO.AttendanceReportDTOSpecRs();
        specResponse.setData(result.getList())
                .setStartRow(0)
                .setEndRow(result.getList().size())
                .setTotalRows(result.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
