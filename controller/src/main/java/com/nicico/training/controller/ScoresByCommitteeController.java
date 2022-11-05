package com.nicico.training.controller;

import com.nicico.training.dto.ScoresByCommitteeDTO;
import com.nicico.training.iservice.IScoresByCommitteeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import response.BaseResponse;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/scores-by-committee")
public class ScoresByCommitteeController {

    private final IScoresByCommitteeService iScoresByCommitteeService;

    @PostMapping("/add-scores")
    public ResponseEntity<BaseResponse> addScores(@RequestBody List<ScoresByCommitteeDTO> addScoresData) {
        return ResponseEntity.ok(iScoresByCommitteeService.addScores(addScoresData));
    }

}
