/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.service.PostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/post")
public class PostRestController {

    private final PostService postService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ModelMapper modelMapper;


    @GetMapping("/list")
    public ResponseEntity<List<PostDTO.Info>> list() {
        return new ResponseEntity<>(postService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<PostDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        convertDate(searchRq.getCriteria());
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.searchWithoutPermission(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    private void convertDate(SearchDTO.CriteriaRq criteria) {
        if (criteria == null)
            return;
        if ("createdDate".equals(criteria.getFieldName()) || "lastModifiedDate".equals(criteria.getFieldName())) {
            criteria.setValue(new Date(criteria.getValue().get(0).toString()));
        }
        if (criteria.getCriteria() != null)
            criteria.getCriteria().forEach(this::convertDate);
    }

    @GetMapping(value = "/wpIscList")
    public ResponseEntity<ISC<PostDTO.Info>> withPermissionList(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping("/{postCode}")
    public ResponseEntity get(@PathVariable String postCode) {
        postCode = postCode.replace('.', '/');
        try {
            return new ResponseEntity<>(postService.getByPostCode(postCode), HttpStatus.OK);
        } catch (TrainingException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping(value = "/unassigned-iscList")
    public ResponseEntity<ISC<PostDTO.Info>> unassignedList(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.unassignedSearch(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/job/{jobId}")
    public ResponseEntity<ISC<PostDTO.Info>> listByJobId(HttpServletRequest iscRq, @PathVariable Long jobId) throws IOException {
        return null;
    }

    @Loggable
    @PostMapping(value = {"/print/{type}"})
    public void printList(HttpServletResponse response,
                          @PathVariable String type,
                          @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/PostList.jasper", params, jsonDataSource, response);
    }

//        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
//        Page<Post> postPage = postService.listByJobId(jobId, createPageable(iscRq));
//        Object x = ISC.convertToIscRs(postPage, startRow);
//        return new ResponseEntity<>(ISC.convertToIscRs(postPage, startRow), HttpStatus.OK);
       /* return new ResponseEntity<>(  ISC.convertToIscRs(postService.listByJobId(jobId, createPageable(iscRq)), startRow), HttpStatus.OK);

        return modelMapper.map(postPage.getContent(), new TypeToken<List<PostDTO.Info>>() {
        }.getType());

        return modelMapper.map(postPage.getContent(), new TypeToken<List<PostDTO.Info>>() {
        }.getType());*/
    /*
    Set<SkillDTO.Info> skills;
        skills=skillGroupService.unAttachSkills(skillGroupId);
        List<SkillDTO.Info> skillList=new ArrayList<>();
        for (SkillDTO.Info skillDTOInfo:skills)
        {
            skillList.add(skillDTOInfo);

        }
        final  SkillDTO.SpecRs specRs=new SkillDTO.SpecRs();
        specRs.setData(skillList)
                .setStartRow(0)
                .setEndRow(skills.size())
                .setTotalRows(skills.size());

        final SkillDTO.SkillSpecRs skillSpecRs=new SkillDTO.SkillSpecRs();
        skillSpecRs.setResponse(specRs);
        return new ResponseEntity<>(skillSpecRs,HttpStatus.OK);
     */

   /* Pageable createPageable(HttpServletRequest rq) {
        String startRowStr = rq.getParameter("_startRow");
        String endRowStr = rq.getParameter("_endRow");
        Integer startRow = (startRowStr != null) ? Integer.parseInt(startRowStr) : 0;
        Integer endRow = (endRowStr != null) ? Integer.parseInt(endRowStr) : 50;

        Integer pageSize = endRow - startRow;
        Integer pageNo = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNo, pageSize);
        return pageable;
    }*/

}
