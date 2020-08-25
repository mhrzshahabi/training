package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.PostGradeGroupDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IPostService;
import com.nicico.training.service.BaseService;
import com.nicico.training.service.PostGradeGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/postGradeGroup")
public class PostGradeGroupRestController {

    private final PostGradeGroupService postGradeGroupService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final IPostService postService;
    private final IPersonnelService personnelService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<PostGradeGroupDTO.Info>> list() {
        return new ResponseEntity<>(postGradeGroupService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<PostGradeGroupDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<PostGradeGroupDTO.Info> searchRs = postGradeGroupService.searchWithoutPermission(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/postIscList/{id}")
    public ResponseEntity<ISC<PostDTO.Info>> postList(HttpServletRequest iscRq, @PathVariable(value = "id") Long id) throws IOException {
        List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(id);
        if (postGrades.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, postGrades.stream().filter(pg -> pg.getDeleted() == null).map(PostGradeDTO.Info::getId).collect(Collectors.toList()), "postGrade", EOperator.inSet);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/personnelIscList/{id}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> personnelList(HttpServletRequest iscRq, @PathVariable(value = "id") Long id) throws IOException {
        List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(id);
        if (postGrades == null || postGrades.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.CriteriaRq criteriaRq=new SearchDTO.CriteriaRq();
        criteriaRq.setCriteria(new ArrayList<>());
        criteriaRq.setOperator(EOperator.and);

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.postGrade", postGrades.stream().filter(pg -> pg.getDeleted() == null).map(PostGradeDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null)) ;
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.deleted",null, EOperator.isNull, null));
        SearchDTO.SearchRs<PostDTO.TupleInfo> postList = postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.TupleInfo.class));
        if (postList.getList() == null || postList.getList().isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        searchRq = ISC.convertToSearchRq(iscRq, postList.getList().stream().map(PostDTO.TupleInfo::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
        SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = personnelService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity<PostGradeGroupDTO.Info> get(@PathVariable long id) {
        return new ResponseEntity<>(postGradeGroupService.get(id), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object req) {
        try {
            PostGradeGroupDTO.Create create = modelMapper.map(req, PostGradeGroupDTO.Create.class);
            return new ResponseEntity<>(postGradeGroupService.create(create), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object req) {
        PostGradeGroupDTO.Update update = modelMapper.map(req, PostGradeGroupDTO.Update.class);
        try {
            return new ResponseEntity<>(postGradeGroupService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            postGradeGroupService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    null,
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<PostGradeGroupDTO.PostGradeGroupSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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
        BaseService.setCriteriaToNotSearchDeleted(request);
        SearchDTO.SearchRs<PostGradeGroupDTO.Info> response = postGradeGroupService.searchWithoutPermission(request);
        final PostGradeGroupDTO.SpecRs specResponse = new PostGradeGroupDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final PostGradeGroupDTO.PostGradeGroupSpecRs specRs = new PostGradeGroupDTO.PostGradeGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{postGradeGroupId}/getPostGrades")
//    @PreAuthorize("hasAnyAuthority('r_post_group')")
    public ResponseEntity<ISC> getPostGrades(@PathVariable Long postGradeGroupId) {
        List<PostGradeDTO.Info> list = postGradeGroupService.getPostGrades(postGradeGroupId);
        ISC.Response<PostGradeDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC, HttpStatus.OK);
    }


    @Loggable
    @DeleteMapping(value = "/removePostGrades/{postGradeGroupId}/{postGradeIds}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity removePostGrades(@PathVariable Long postGradeGroupId, @PathVariable Set<Long> postGradeIds) {
        postGradeGroupService.removePostGrades(postGradeGroupId, postGradeIds);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addPostGrades/{postGradeGroupId}/{postGradeIds}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity addPostGrades(@PathVariable Long postGradeGroupId, @PathVariable Set<Long> postGradeIds) {
        postGradeGroupService.addPostGrades(postGradeGroupId, postGradeIds);
        return new ResponseEntity(HttpStatus.OK);
    }
}
