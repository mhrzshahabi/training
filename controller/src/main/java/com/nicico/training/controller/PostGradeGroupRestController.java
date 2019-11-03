
package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.PostGradeGroupDTO;
import com.nicico.training.service.PostGradeGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/postGradeGroup")
public class PostGradeGroupRestController {

    private final PostGradeGroupService postGradeGroupService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<PostGradeGroupDTO.Info>> list() {
        return new ResponseEntity<>(postGradeGroupService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<PostGradeGroupDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<PostGradeGroupDTO.Info> searchRs = postGradeGroupService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
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
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_FOUND);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<PostGradeGroupDTO.Info> update(@PathVariable Long id, @RequestBody Object req) {
        PostGradeGroupDTO.Update update = modelMapper.map(req, PostGradeGroupDTO.Update.class);
        return new ResponseEntity<>(postGradeGroupService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        postGradeGroupService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<PostGradeGroupDTO.PostGradeGroupSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                                       @RequestParam("_endRow") Integer endRow,
                                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                                       @RequestParam(value = "operator", required = false) String operator,
                                                                       @RequestParam(value = "criteria", required = false) String criteria,
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

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<PostGradeGroupDTO.Info> response = postGradeGroupService.search(request);

        final PostGradeGroupDTO.SpecRs specResponse = new PostGradeGroupDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
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
