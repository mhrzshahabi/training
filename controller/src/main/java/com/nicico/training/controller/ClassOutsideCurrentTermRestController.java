package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CalenderCurrentTermDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/class-outside-current-term")
public class ClassOutsideCurrentTermRestController {
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final ModelMapper modelMapper;
    private final ITclassService tclassService;
    private final TclassService tClassService;

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "startDate",required = false) String startDate,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, ParseException {
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
       // SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("createdDate", startDate, EOperator.greaterThan, null);
      //  List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
       // request.getCriteria().getCriteria().add(criteriaRq1);
       // request.setCriteria(criteriaRq1);
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);
        String str= DateUtil.convertKhToMi1(startDate.trim()).replaceAll("[\\s\\-]", "");

        List<Long> longList=response.getList().stream().filter(x->Long.valueOf(String.valueOf(x.getCreatedDate()).substring(0,10).replaceAll("[\\s\\-]", ""))>Long.valueOf(str))
                .map(x->x.getId()).collect(Collectors.toList());


        List<TclassDTO.Info>infoList= response.getList().stream().filter(x->!longList.contains(x.getId())).collect(Collectors.toList());
        response.getList().removeAll(infoList);
        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}