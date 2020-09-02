package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.service.BaseService;
import com.nicico.training.model.JobGroup;
import com.nicico.training.service.JobGroupService;
import com.nicico.training.service.PostGradeGroupService;
import com.nicico.training.service.ViewTrainingPostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.ListIterator;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-training-post")
public class ViewTrainingPostRestController {

    private final ObjectMapper objectMapper;
    private final ViewTrainingPostService viewTrainingPostService;
    private final JobGroupService jobGroupService;
    private final PostGradeGroupService postGradeGroupService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> searchRs = viewTrainingPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", required = false, defaultValue = "100") Integer endRow,
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
            if(criteriaRq.getCriteria().stream().anyMatch(a->(a.getFieldName().equals("jobGroup")))){
                List<List<Object>> lists = criteriaRq.getCriteria().stream().filter(a -> (a.getFieldName().equals("jobGroup"))).map(a -> a.getValue()).collect(Collectors.toList());
                List<JobDTO.Info> jobs = jobGroupService.getJobs(Long.parseLong(lists.get(0).get(0).toString()));
                List<Long> jobIds = jobs.stream().map(a -> a.getId()).collect(Collectors.toList());
                if(jobIds.size()==0){
                    jobIds.add(-1L);
                }
//                ArrayList<SearchDTO.CriteriaRq> listCR = new ArrayList<>();
                criteriaRq.getCriteria().add(makeNewCriteria("jobId", jobIds, EOperator.inSet, null));
//                listCR.add(criteriaRq1);
//                criteriaRq.setCriteria(listCR);
            }
            else if(criteriaRq.getCriteria().stream().anyMatch(a->(a.getFieldName().equals("postGGI")))){
                List<List<Object>> lists = criteriaRq.getCriteria().stream().filter(a -> (a.getFieldName().equals("postGGI"))).map(a -> a.getValue()).collect(Collectors.toList());
                List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(Long.parseLong(lists.get(0).get(0).toString()));
                List<Long> ids = postGrades.stream().map(a -> a.getId()).collect(Collectors.toList());

                if(ids.size()==0){
                    ids.add(-1L);
                }
//                ArrayList<SearchDTO.CriteriaRq> listCR = new ArrayList<>();
                criteriaRq.getCriteria().add(makeNewCriteria("postGradeId", ids, EOperator.inSet, null));
//                listCR.add(criteriaRq1);
//                criteriaRq.setCriteria(listCR);
//                for (int i = 0; i < criteriaRq.getCriteria().size(); i++) {
//                    if(criteriaRq.getCriteria().get(i).getFieldName().equals("jobGroup")){
//                        criteriaRq.getCriteria().get(i).
//                    }
//                }
            }
            criteriaRq.getCriteria().removeIf(a -> a.getFieldName().equals("jobGroup") || a.getFieldName().equals("postGGI"));
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
        BaseService.setCriteriaToNotSearchDeleted(request);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> response = viewTrainingPostService.search(request);
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
