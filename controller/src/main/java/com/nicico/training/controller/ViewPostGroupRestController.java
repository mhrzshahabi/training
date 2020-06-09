package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPostGroupDTO;
import com.nicico.training.service.ViewPostGroupService;
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
@RequestMapping(value = "/api/view-post-group")
public class ViewPostGroupRestController {

    private final ViewPostGroupService viewPostGroupService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewPostGroupDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewPostGroupDTO.Info> searchRs = viewPostGroupService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
