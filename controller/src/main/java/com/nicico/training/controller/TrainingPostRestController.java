package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.TrainingPostDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.service.TrainingPostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/training-post")
public class TrainingPostRestController {

    private final TrainingPostService trainingPostService;
    private final IPersonnelService personnelService;

    @Loggable
    @PostMapping
    public ResponseEntity<TrainingPostDTO> create(@Validated @RequestBody TrainingPostDTO.Create request, HttpServletResponse response) throws IOException {
        return new ResponseEntity<>(trainingPostService.create(request, response), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<TrainingPostDTO> update(@PathVariable Long id, @Validated @RequestBody TrainingPostDTO.Update request, HttpServletResponse response) throws IOException {
        return new ResponseEntity<>(trainingPostService.update(id, request, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        trainingPostService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addPosts/{TrainingPostId}/{postIds}")
    public ResponseEntity<Void> addPosts(@PathVariable Long TrainingPostId, @PathVariable Set<Long> postIds) {
        trainingPostService.addPosts(TrainingPostId, postIds);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removePost/{TrainingPostId}/{postId}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removePost(@PathVariable Long TrainingPostId, @PathVariable Long postId) {
        trainingPostService.removePost(TrainingPostId, postId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/removePosts/{TrainingPostId}/{postIds}")
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removePosts(@PathVariable Long TrainingPostId, @PathVariable Set<Long> postIds) {
        trainingPostService.removePosts(TrainingPostId, postIds);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{TrainingPostId}/getPosts")
    public ResponseEntity<ISC> getPosts(@PathVariable Long TrainingPostId) throws IOException {
        List<PostDTO.Info> list = trainingPostService.getPosts(TrainingPostId);
        ISC.Response<PostDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getNullPosts")
    public ResponseEntity<ISC> getNullPosts() throws IOException {
        List<PostDTO.Info> list = trainingPostService.getNullPosts();
        ISC.Response<PostDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{trainingPostId}/getPersonnel")
//    @PreAuthorize("hasAnyAuthority('r_post_group')")
    public ResponseEntity<ISC<PersonnelDTO.Info>> getPersonnel(@PathVariable Long trainingPostId, HttpServletRequest iscRq) throws IOException {
        List<PostDTO.Info> postList = trainingPostService.getPosts(trainingPostId);
        if (postList == null || postList.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, postList.stream().map(PostDTO.Info::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
        searchRq.setDistinct(true);
        SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = personnelService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
