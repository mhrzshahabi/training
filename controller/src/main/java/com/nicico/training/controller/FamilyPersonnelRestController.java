package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.FamilyPersonnelDTO;
import com.nicico.training.iservice.IFamilyPersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/family")
public class FamilyPersonnelRestController {

    private final IFamilyPersonnelService iFamilyPersonnelService;
    private final ModelMapper modelMapper;


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<FamilyPersonnelDTO.Info>> list(HttpServletRequest iscRq,
                                                      @RequestParam(value = "_startRow", required = false) Integer startRow,
                                                      @RequestParam(value = "_endRow", required = false) Integer endRow) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);
        SearchDTO.SearchRs<FamilyPersonnelDTO.Info> result = iFamilyPersonnelService.search(searchRq,o -> modelMapper.map(o, FamilyPersonnelDTO.Info.class));

        ISC.Response<FamilyPersonnelDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + result.getList().size());
        response.setTotalRows(result.getTotalCount().intValue());
        response.setData(result.getList());
        ISC<FamilyPersonnelDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }



}
