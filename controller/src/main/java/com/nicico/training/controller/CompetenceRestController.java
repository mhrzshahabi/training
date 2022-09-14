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
import com.nicico.training.iservice.ICompetenceService;
import com.nicico.training.iservice.IParameterValueService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.Competence;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final ICompetenceService competenceService;
    private final IParameterValueService parameterValueService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final MessageSource messageSource;
    private final IWorkGroupService workGroupService;

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

        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion.getCriteria()!=null)
                for (SearchDTO.CriteriaRq c : criterion.getCriteria()) {
                    if (c.getFieldName().equals("competenceLevelId") ) {
                        c.setValue(Long.valueOf(String.valueOf(c.getValue().get(0))));
                    }
                    if (c.getFieldName().equals("competencePriorityId") ) {
                        c.setValue(Long.valueOf(String.valueOf(c.getValue().get(0))));
                    }
                }

             }
        }


        SearchDTO.SearchRs<CompetenceDTO.Info> response = competenceService.search(request);
        for (CompetenceDTO.Info  row:response.getList()){
            Boolean used=competenceService.checkUsed(row.getId());
            row.setIsUsed(used);
        }
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
    @GetMapping(value = "/show-posts/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Object> showNeedsAssessmentPosts(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<CompetenceDTO.Posts> response = competenceService.searchPosts(id,startRow,endRow);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs<>();
        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(Math.toIntExact(response.getTotalCount()));
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/show-posts-temp/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Object> showTempPosts(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                           @RequestParam(value = "_endRow", defaultValue = "75") Integer endRow,
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

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<CompetenceDTO.Posts> response = competenceService.searchTempPosts(id,startRow,endRow);

        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs<>();
        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(Math.toIntExact(response.getTotalCount()));
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
        final List<NeedsAssessmentDTO.Info> list = competenceService.getUsedList(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        CompetenceDTO.Update update = modelMapper.map(rq, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.checkAndUpdate(id, update, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
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
        Competence competence=competenceService.getCompetence(id);
        if (competence.getWorkFlowStatusCode().equals(0L) || competence.getWorkFlowStatusCode().equals(4L) ){
            return new ResponseEntity<>(null, HttpStatus.NOT_ACCEPTABLE);
        }else {
            final List<NeedsAssessmentDTO.Info> list = competenceService.getUsedList(id);
            if(!list.isEmpty()){
                return new ResponseEntity<>(list, HttpStatus.IM_USED);
            }
            return new ResponseEntity<>(HttpStatus.OK);
        }

    }
}
