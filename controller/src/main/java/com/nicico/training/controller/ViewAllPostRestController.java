/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/07/26
 */

package com.nicico.training.controller;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewAllPostDTO;
import com.nicico.training.iservice.IViewAllPostService;
import com.nicico.training.service.BaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ViewAllPost")
public class ViewAllPostRestController {

    private final IViewAllPostService viewAllPostService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewAllPostDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewAllPostDTO.Info> searchRs = viewAllPostService.search(searchRq, p -> modelMapper.map(p, ViewAllPostDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

}