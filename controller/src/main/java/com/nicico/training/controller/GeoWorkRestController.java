package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GeoWorkDTO;
import com.nicico.training.iservice.IGeoWorkService;
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
@RequestMapping(value = "/api/geo-work")
public class GeoWorkRestController {

    private final IGeoWorkService geoWorkService;

    @Loggable
    @GetMapping("/company-list")
    public ResponseEntity<ISC<GeoWorkDTO>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity<>(ISC.convertToIscRs(geoWorkService.getCompanyList(searchRq), searchRq.getStartIndex()), HttpStatus.OK);
    }
}