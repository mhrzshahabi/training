package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassDetailDTO;
import com.nicico.training.iservice.IViewClassDetailService;
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
@RequestMapping(value = "/api/view-class-detail")
public class ViewClassDetailRestController {

    private final IViewClassDetailService viewClassDetailService;
    @Autowired
    protected EntityManager entityManager;


    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewClassDetailDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
       if (searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null){
           for (SearchDTO.CriteriaRq criteriaRq: searchRq.getCriteria().getCriteria()){
               if (criteriaRq.getFieldName().equals("tclassCode"))
                   criteriaRq.setValue(criteriaRq.getValue().toString().replace("]","").replace("[","").trim());
           }
       }
        SearchDTO.SearchRs<ViewClassDetailDTO.Info> searchRs = viewClassDetailService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
