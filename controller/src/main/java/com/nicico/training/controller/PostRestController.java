/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.service.PostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/post")
public class PostRestController {

    private final PostService postService;
    private final ModelMapper modelMapper;

    @GetMapping("/list")
    public ResponseEntity<List<PostDTO.Info>> list() {
        return new ResponseEntity<>(postService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<PostDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = postService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/job/{jobId}")
    public ResponseEntity<ISC<PostDTO.Info>> listByJobId(HttpServletRequest iscRq, @PathVariable Long jobId) throws IOException {
        return null;
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
