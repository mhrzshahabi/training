package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewjobDTO;
import com.nicico.training.iservice.IViewJobService;
import com.nicico.training.service.BaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@RequestMapping(value = "/api/view-job")
public class ViewJobRestController {

    private final IViewJobService viewJobService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewjobDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewjobDTO.Info> searchRs = viewJobService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
