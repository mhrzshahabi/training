package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.ViewActivePersonnelInRegisteringDTO;
import com.nicico.training.iservice.IViewActivePersonnelInRegisteringService;
import com.nicico.training.service.ViewActivePersonnelInRegisteringService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("api/view-active-personnel-in-registering")
public class ViewActivePersonnelInRegisteringController {
    private final IViewActivePersonnelInRegisteringService viewActivePersonnelInRegisteringService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewActivePersonnelInRegisteringDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();

        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setFieldName("nationalCode");
        criteriaRq.setValue(modelMapper.map(SecurityContextHolder.getContext().getAuthentication().getPrincipal(), CustomUserDetails.class).getNationalCode());
        searchRq.setCriteria(criteriaRq);
        searchRq.setSortBy("classId");

        SearchDTO.SearchRs<ViewActivePersonnelInRegisteringDTO.Info> searchRs = viewActivePersonnelInRegisteringService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) Long id,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<ViewActivePersonnelInRegisteringDTO.Info> response = viewActivePersonnelInRegisteringService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}