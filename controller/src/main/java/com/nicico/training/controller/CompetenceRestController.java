/*
ghazanfari_f,
1/14/2020,
2:46 PM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.service.CompetenceService;
import com.nicico.training.service.WorkGroupService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final CompetenceService competenceService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final MessageSource messageSource;
    private final WorkGroupService workGroupService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<CompetenceDTO.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(competenceService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Object> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) Long id,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

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
        else{
            request.setCriteria(workGroupService.addPermissionToCriteria("categoryId", request.getCriteria()));
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<CompetenceDTO.Info> response = competenceService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs<>();
        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceDTO.Info> create(@RequestBody Object rq, HttpServletResponse response) {
        CompetenceDTO.Create create = modelMapper.map(rq, CompetenceDTO.Create.class);
        return new ResponseEntity<>(competenceService.checkAndCreate(create, response), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object rq, HttpServletResponse response) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        CompetenceDTO.Update update = modelMapper.map(rq, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.checkAndUpdate(id, update, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        try {
            return new ResponseEntity<>(competenceService.delete(id), HttpStatus.OK);
        } catch (TrainingException ex) {
            Locale locale = LocaleContextHolder.getLocale();
            return new ResponseEntity<>(messageSource.getMessage("exception.unauthorized", null, locale), HttpStatus.UNAUTHORIZED);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity checkUsed(@PathVariable Long id) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
