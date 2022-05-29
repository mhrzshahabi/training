package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.OperationalRole;
import com.nicico.training.service.BaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-training-post")
public class ViewTrainingPostRestController {

    private final ObjectMapper objectMapper;
    private final ITrainingPostService trainingPostService;
    private final IViewTrainingPostService viewTrainingPostService;
    private final IJobGroupService jobGroupService;
    private final IPostGradeGroupService postGradeGroupService;
    private final IViewTrainingPostReportService viewTrainingPostReportService;
    private final IOperationalRoleService iOperationalRoleService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> searchRs = viewTrainingPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/rolePostIscList")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Info>> rolePostIscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = ((CustomUserDetails) principal).getUserId();
        Set<Long> userAccessTrainingPostIds = iOperationalRoleService.getUserAccessTrainingPostsInRole(userId);
        List<Long> userAccessPostIds =  new ArrayList<Long>();
        userAccessPostIds.addAll(userAccessTrainingPostIds);
        if (userAccessPostIds != null && userAccessPostIds.size() > 0) {
            List<SearchDTO.CriteriaRq> criteriaList = new ArrayList<>();
            criteriaList.add(makeNewCriteria("id", userAccessPostIds, EOperator.inSet, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, criteriaList);
            if (searchRq.getCriteria() != null) {
                if (searchRq.getCriteria().getCriteria() != null)
                    searchRq.getCriteria().getCriteria().add(criteriaRq);
                else
                    searchRq.getCriteria().setCriteria(criteriaList);
            } else {
                searchRq.setCriteria(criteriaRq);
            }
            SearchDTO.SearchRs<ViewTrainingPostDTO.Info> searchRs = viewTrainingPostService.search(searchRq);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
        }else {
            return new ResponseEntity<>(null, HttpStatus.NO_CONTENT);
        }
    }

    @GetMapping(value = "/rolePostList/{roleId}")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Info>> rolePostList(HttpServletRequest iscRq, @PathVariable Long roleId) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
//        List<Long> usedPostIds = iOperationalRoleService.getUsedPostIdsInRoles(roleId);
//        if (usedPostIds != null && usedPostIds.size() > 0) {
//            List<SearchDTO.CriteriaRq> criteriaList = new ArrayList<>();
//            criteriaList.add(makeNewCriteria("id", usedPostIds, EOperator.notInSet, null));
//            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, criteriaList);
//            if (searchRq.getCriteria() != null) {
//                if (searchRq.getCriteria().getCriteria() != null)
//                    searchRq.getCriteria().getCriteria().add(criteriaRq);
//                else
//                    searchRq.getCriteria().setCriteria(criteriaList);
//            } else {
//                searchRq.setCriteria(criteriaRq);
//            }
//        }
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> searchRs = viewTrainingPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/roleUsedPostList/{roleId}")
    public ResponseEntity<ViewTrainingPostDTO.PostSpecRs> roleUsedPostList(HttpServletRequest iscRq, @PathVariable Long roleId) throws IOException {
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> response;
        response = iOperationalRoleService.getRoleUsedPostList(roleId);

        final ViewTrainingPostDTO.SpecRs specResponse = new ViewTrainingPostDTO.SpecRs();
        final ViewTrainingPostDTO.PostSpecRs specRs = new ViewTrainingPostDTO.PostSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/roleNonUsedPostList/{roleId}")
    public ResponseEntity<ViewTrainingPostDTO.PostSpecRs> nonRoleUsedPostList(HttpServletRequest iscRq, @PathVariable Long roleId) throws IOException {
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> response;
        response = iOperationalRoleService.getNonRoleUsedPostList(roleId);

        final ViewTrainingPostDTO.SpecRs specResponse = new ViewTrainingPostDTO.SpecRs();
        final ViewTrainingPostDTO.PostSpecRs specRs = new ViewTrainingPostDTO.PostSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/iscListReport")
    public ResponseEntity<ISC<ViewTrainingPostDTO.Report>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Report> searchRs = viewTrainingPostReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/areaList")
    public List<String> areaList(HttpServletRequest iscRq) throws IOException {

        List<String> areas = trainingPostService.getAllArea();
        return areas;
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<CourseDTO.CourseSpecRs> list(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow, @RequestParam(value = "_endRow", required = false, defaultValue = "100") Integer endRow, @RequestParam(value = "_constructor", required = false) String constructor, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria, @RequestParam(value = "id", required = false) Long id, @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator)).setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
            }));
            if (criteriaRq.getCriteria().stream().anyMatch(a -> (a.getFieldName().equals("jobGroup")))) {
                List<List<Object>> lists = criteriaRq.getCriteria().stream().filter(a -> (a.getFieldName().equals("jobGroup"))).map(a -> a.getValue()).collect(Collectors.toList());
                List<JobDTO.Info> jobs = jobGroupService.getJobs(Long.parseLong(lists.get(0).get(0).toString()));
                List<Long> jobIds = jobs.stream().map(a -> a.getId()).collect(Collectors.toList());
                if (jobIds.size() == 0) {
                    CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
                    specResponse.setData(new ArrayList()).setStartRow(0).setEndRow(0).setTotalRows(0);

                    final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
                    specRs.setResponse(specResponse);

                    return new ResponseEntity<>(specRs, HttpStatus.OK);
                }
//                ArrayList<SearchDTO.CriteriaRq> listCR = new ArrayList<>();
                criteriaRq.getCriteria().add(makeNewCriteria("jobId", jobIds, EOperator.inSet, null));
//                listCR.add(criteriaRq1);
//                criteriaRq.setCriteria(listCR);
            } else if (criteriaRq.getCriteria().stream().anyMatch(a -> (a.getFieldName().equals("postGGI")))) {
                List<List<Object>> lists = criteriaRq.getCriteria().stream().filter(a -> (a.getFieldName().equals("postGGI"))).map(a -> a.getValue()).collect(Collectors.toList());
                List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(Long.parseLong(lists.get(0).get(0).toString()));
                List<Long> ids = postGrades.stream().map(a -> a.getId()).collect(Collectors.toList());

                if (ids.size() == 0) {
                    CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
                    specResponse.setData(new ArrayList()).setStartRow(0).setEndRow(0).setTotalRows(0);

                    final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
                    specRs.setResponse(specResponse);

                    return new ResponseEntity<>(specRs, HttpStatus.OK);
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
            criteriaRq.setOperator(EOperator.equals).setFieldName("id").setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow).setCount(endRow - startRow);
        BaseService.setCriteriaToNotSearchDeleted(request);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> response = viewTrainingPostService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @PostMapping("/delete/{roleId}")
    public ResponseEntity<Void> deleteIndividualPost(@PathVariable Long roleId, @RequestBody List<Long> postIds) {
        iOperationalRoleService.deleteIndividualPost(roleId, postIds);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/add/{roleId}")
    public ResponseEntity<BaseResponse> addIndividualPost(@PathVariable Long roleId, @RequestBody List<Long> postIds) {
        BaseResponse response = new BaseResponse();
        try {
            iOperationalRoleService.addIndividualPost(roleId, postIds);
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("پست انفرادی با موفقیت اضافه شد");
        } catch (Exception e) {
            response.setStatus(HttpStatus.CONFLICT.value());
            response.setMessage("پست انفرادی تکراری می باشد");
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
