package com.nicico.training.iservice;


import com.nicico.training.dto.ScoresByCommitteeDTO;
import response.BaseResponse;

import java.util.List;

public interface IScoresByCommitteeService {

    BaseResponse addScores(List<ScoresByCommitteeDTO> addScoresData);

    String getScore(String nationalCode, Long id);
}
