package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillLevelDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.ISkillLevelService;
import com.nicico.training.iservice.ITestQuestionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/test-question")
public class TestQuestionRestController {

    private final ITestQuestionService testQuestionService;
    private final ObjectMapper objectMapper;
    // ------------------------------

    @GetMapping(value = "/spec-list")
    public ResponseEntity<TestQuestionDTO.TestQuestionSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                           @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                           @RequestParam(value = "_constructor", required = false) String constructor,
                                                           @RequestParam(value = "operator", required = false) String operator,
                                                           @RequestParam(value = "criteria", required = false) String criteria,
                                                           @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException
    {
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

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TestQuestionDTO.Info> response = testQuestionService.search(request);

        final TestQuestionDTO.SpecRs specResponse = new TestQuestionDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final TestQuestionDTO.TestQuestionSpecRs specRs = new TestQuestionDTO.TestQuestionSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
