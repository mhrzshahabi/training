package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.IViewPostService;
import com.nicico.training.service.BaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-post")
public class ViewPostRestController {

    private final ObjectMapper objectMapper;
    private final IViewPostService viewPostService;
    private final IOperationalRoleService iOperationalRoleService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewPostDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<ViewPostDTO.Info> searchRs = viewPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/roleIndPostIscList")
    public ResponseEntity<ISC<ViewPostDTO.Info>> roleIndPostIscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = ((CustomUserDetails) principal).getUserId();
        List<Long> userAccessPostIds = iOperationalRoleService.getUserAccessPostsInRole(userId);

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
            SearchDTO.SearchRs<ViewPostDTO.Info> searchRs = viewPostService.search(searchRq);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
        }else {
            return new ResponseEntity<>(null, HttpStatus.NO_CONTENT);
        }
    }

    @GetMapping(value = "/rolePostList/{roleId}")
    public ResponseEntity<ISC<ViewPostDTO.Info>> rolePostList(HttpServletRequest iscRq, @PathVariable Long roleId) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        List<Long> usedPostIds = iOperationalRoleService.getUsedPostIdsInRoles(roleId);
        if (usedPostIds != null && usedPostIds.size() > 0) {
            List<SearchDTO.CriteriaRq> criteriaList = new ArrayList<>();
            criteriaList.add(makeNewCriteria("id", usedPostIds, EOperator.notInSet, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, criteriaList);
            if (searchRq.getCriteria() != null) {
                if (searchRq.getCriteria().getCriteria() != null)
                    searchRq.getCriteria().getCriteria().add(criteriaRq);
                else
                    searchRq.getCriteria().setCriteria(criteriaList);
            } else {
                searchRq.setCriteria(criteriaRq);
            }
        }
        SearchDTO.SearchRs<ViewPostDTO.Info> searchRs = viewPostService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
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
        SearchDTO.SearchRs<ViewPostDTO.Info> response = viewPostService.search(request);
        final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());

        final CourseDTO.CourseSpecRs specRs = new CourseDTO.CourseSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    public static SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(operator);
//        criteriaRq.setFieldName(fieldName);
//        criteriaRq.setValue(value);
//        criteriaRq.setCriteria(criteriaRqList);
//        return criteriaRq;
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }
}
