package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.service.ViewTrainingPostService;
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
@RequestMapping(value = "/api/view-training-post")
public class ViewTrainingPostRestController {

    private final ViewTrainingPostService viewTrainingPostService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> searchRs = viewTrainingPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
