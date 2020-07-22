package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.service.TrainingPostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/training-post")
public class TrainingPostRestController {

    private final TrainingPostService trainingPostService;

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
    public ResponseEntity<ISC> getPosts(@PathVariable Long TrainingPostId) {
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
    @GetMapping(value = "/{TrainingPostId}/getPersonnel")
    public ResponseEntity<ISC> getPersonnel(@PathVariable Long TrainingPostId) {
        List<PersonnelDTO.Info> list = trainingPostService.getPersonnel(TrainingPostId);
        ISC.Response<PersonnelDTO.Info> response = new ISC.Response<>();
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<Object> objectISC = new ISC<>(response);
        return new ResponseEntity<>(objectISC, HttpStatus.OK);
    }
}
