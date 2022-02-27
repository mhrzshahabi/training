package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassCostDTO;
import com.nicico.training.dto.ViewJobGroupDTO;
import com.nicico.training.dto.ViewStudentsInCanceledClassReportDTO;
import com.nicico.training.iservice.IViewClassCostReportService;
import com.nicico.training.iservice.IViewJobGroupService;
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
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-class-cost")
public class ViewClassCostReportRestController {

    private final IViewClassCostReportService iViewClassCostReportService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ViewClassCostDTO.ViewClassCostDTOspecRs> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq request =ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewClassCostDTO.Info> response = iViewClassCostReportService.search(request, o -> modelMapper.map(o, ViewClassCostDTO.Info.class));

        final ViewClassCostDTO.SpecRs specResponse = new ViewClassCostDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(request.getStartIndex())
                .setEndRow(request.getStartIndex() + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final ViewClassCostDTO.ViewClassCostDTOspecRs specRs = new ViewClassCostDTO.ViewClassCostDTOspecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
