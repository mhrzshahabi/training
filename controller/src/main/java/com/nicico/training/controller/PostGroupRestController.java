package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGroupDTO;
import com.nicico.training.service.PostGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/post-group")
public class PostGroupRestController {
    private final ReportUtil reportUtil;
    private final PostGroupService postGroupService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final DateUtil dateUtil;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_post_group')")
    public ResponseEntity<PostGroupDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(postGroupService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_post_group')")
    public ResponseEntity<List<PostGroupDTO.Info>> list() {
        return new ResponseEntity<>(postGroupService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_post_group')")
    public ResponseEntity<PostGroupDTO.Info> create(@Validated @RequestBody PostGroupDTO.Create request) {
        return new ResponseEntity<>(postGroupService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_post_group')")
    public ResponseEntity<PostGroupDTO.Info> update(@PathVariable Long id, @Validated @RequestBody PostGroupDTO.Update request) {
        return new ResponseEntity<>(postGroupService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_post_group')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        postGroupService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_post_group')")
    public ResponseEntity<Void> delete(@Validated @RequestBody PostGroupDTO.Delete request) {
        postGroupService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{postGroupId}/canDelete")
//    @PreAuthorize("hasAuthority('d_post_group')")
    public ResponseEntity<Boolean> canDelete(@PathVariable Long postGroupId) {
        return new ResponseEntity<>(postGroupService.canDelete(postGroupId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_post_group')")
    public ResponseEntity<PostGroupDTO.PostGroupSpecRs> list(@RequestParam("_startRow") Integer startRow,
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



        //SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<PostGroupDTO.Info> response = postGroupService.search(request);

        final PostGroupDTO.SpecRs specResponse = new PostGroupDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final PostGroupDTO.PostGroupSpecRs specRs = new PostGroupDTO.PostGroupSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_post_group')")
    public ResponseEntity<SearchDTO.SearchRs<PostGroupDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(postGroupService.search(request), HttpStatus.OK);
    }

    // ------------------------------

//    @Loggable
//    @GetMapping(value = "/{postGroupId}/getCompetences")
////    @PreAuthorize("hasAnyAuthority('r_post_group')")
//    public ResponseEntity<CompetenceDTO.CompetenceSpecRs> getCompetences(@PathVariable Long postGroupId) {
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//
//        List<CompetenceDTO.Info> list = postGroupService.getCompetence(postGroupId);
//
//        final CompetenceDTO.SpecRs specResponse = new CompetenceDTO.SpecRs();
//        specResponse.setData(list)
//                .setStartRow(0)
//                .setEndRow( list.size())
//                .setTotalRows(list.size());
//
//        final CompetenceDTO.CompetenceSpecRs specRs = new CompetenceDTO.CompetenceSpecRs();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs,HttpStatus.OK);
//
//
//    }

/*
    @Loggable
    @GetMapping(value = "/{postGroupId}/getPosts")
//    @PreAuthorize("hasAnyAuthority('r_post_group')")
    public ResponseEntity<PostDTO.IscRes> getPosts(@PathVariable Long postGroupId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<PostDTO.Info> list = postGroupService.getPosts(postGroupId);

        final PostDTO.SpecRs specResponse = new PostDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow( list.size())
                .setTotalRows(list.size());

        final PostDTO.IscRes specRs = new PostDTO.IscRes();

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs,HttpStatus.OK);


    }*/



    @Loggable
    @PostMapping(value = "/addPost/{postId}/{postGroupId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void>  addPost(@PathVariable Long postId,@PathVariable Long postGroupId) {
        postGroupService.addPost(postId,postGroupId);
        return new ResponseEntity(HttpStatus.OK);
    }




    @Loggable
    @PostMapping(value = "/addPosts/{postGroupId}/{postIds}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void>  addPosts(@PathVariable Long postGroupId,@PathVariable Set<Long> postIds) {
        postGroupService.addPosts(postGroupId, postIds);
        return new ResponseEntity(HttpStatus.OK);
    }



    @Loggable
    @DeleteMapping(value = "/removePost/{postGroupId}/{postId}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removePost(@PathVariable Long postGroupId,@PathVariable Long postId) {
        postGroupService.removePost(postGroupId,postId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removeCompetence/{postGroupId}/{competenceId}")
    public ResponseEntity<Void> removeFromCompetence(@PathVariable Long postGroupId,@PathVariable Long competenceId){
        postGroupService.removeFromCompetency(postGroupId,competenceId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removeAllCompetence/{postGroupId}/")
    public ResponseEntity<Void> removeFromAllCompetences(@PathVariable Long postGroupId){
        postGroupService.removeFromAllCompetences(postGroupId);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/{postGroupId}/unAttachPosts")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<ISC.Response<PostDTO.Info>> unAttachPosts(@PathVariable Long postGroupId) {

        Set<PostDTO.Info> posts;
        posts = postGroupService.unAttachPosts(postGroupId);
        List<PostDTO.Info> postList=new ArrayList<>();
        for (PostDTO.Info postDTOInfo:posts)
        {
            postList.add(postDTOInfo);
        }
        ISC.Response<PostDTO.Info> response = new ISC.Response<>();
        response.setData(postList)
                .setStartRow(0)
                .setEndRow(postList.size())
                .setTotalRows(postList.size());

        return new ResponseEntity<>(response,HttpStatus.OK);
    }



    @Loggable
    @DeleteMapping(value = "/removePosts/{postGroupId}/{postIds}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removePosts(@PathVariable Long postGroupId,@PathVariable Set<Long> postIds) {
        postGroupService.removePosts(postGroupId,postIds);
        return new ResponseEntity(HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/{postGroupId}/getPosts")
//    @PreAuthorize("hasAnyAuthority('r_post_group')")
    public ResponseEntity<ISC> getPosts(@PathVariable Long postGroupId) {
        List<PostDTO.Info> list = postGroupService.getPosts(postGroupId);
        ISC.Response<PostDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC,HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/postGroup.jasper", params, response);
    }


    @Loggable
    @GetMapping(value = {"/printAll/{type}"})
    public void printAll(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/postgroupwithposts.jasper", params, response);
    }

    @Loggable
    @GetMapping(value = {"/printSelected/{type}/{postGroupIds}"})
    public void printWithSelectedPostGroup(HttpServletResponse response, @PathVariable String type,@PathVariable String postGroupIds) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        params.put("postGroupIds",postGroupIds);
        reportUtil.export("/reports/selectedPostGroup.jasper", params, response);
    }


//
//    @Loggable
//    @PostMapping(value = {"/printWithCriteria/{type}"})
//    public void printWithCriteria(HttpServletResponse response,
//                                  @PathVariable String type,
//                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
//
//        final SearchDTO.CriteriaRq criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
//        final SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
//
//        final SearchDTO.SearchRs<PostGroupDTO.Info> searchRs = postGroupService.search(searchRq);
//
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//
//        final List<SearchDTO.CriteriaRq> criteriaRqList = criteriaRq.getCriteria();
//        criteriaRqList.forEach(criteriaRqFE -> {
//            switch (criteriaRqFE.getFieldName()) {
//                case "startDate":
//                    params.put("startDate", criteriaRqFE.getValue().toString());
//                    break;
//                case "endDate":
//                    params.put("endDate", criteriaRqFE.getValue().toString());
//                    break;
//                case "group":
//                    params.put("group", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//                case "course.id":
//                    params.put("course.id", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//                case "teacher.id":
//                    params.put("teacher.id", criteriaRqFE.getValue().toString().replace(".0", "").replace("[", "").replace("]", ""));
//                    break;
//            }
//        });
//
//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
//    }
}
