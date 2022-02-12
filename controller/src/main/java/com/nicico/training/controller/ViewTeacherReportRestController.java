package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTeacherReportDTO;
import com.nicico.training.iservice.IViewTeacherReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-teacher-report")
public class ViewTeacherReportRestController {

    private final IViewTeacherReportService viewTeacherReportService;
    @Autowired
    protected EntityManager entityManager;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewTeacherReportDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if(searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null){
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                if(criterion.getValue() != null && criterion.getValue().size() != 0){
                    if(criterion.getValue().get(0) != null && criterion.getValue().get(0).equals("false"))
                        criterion.setValue(false);
                    if(criterion.getValue().get(0) != null && criterion.getValue().get(0).equals("true"))
                        criterion.setValue(true);
                }
            }
        }
        SearchDTO.SearchRs<ViewTeacherReportDTO.Info> searchRs = viewTeacherReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
