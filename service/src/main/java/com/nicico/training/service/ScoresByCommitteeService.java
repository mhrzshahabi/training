package com.nicico.training.service;


import com.nicico.training.dto.ScoresByCommitteeDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IScoresByCommitteeService;
import com.nicico.training.model.Course;
import com.nicico.training.model.ScoresByCommittee;
import com.nicico.training.repository.ScoresByCommitteeDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class ScoresByCommitteeService implements IScoresByCommitteeService {

    private final ScoresByCommitteeDAO scoresByCommitteeDAO;
    private final ICourseService courseService;


    @Transactional
    @Override
    public BaseResponse addScores(List<ScoresByCommitteeDTO> addScoresData) {
        BaseResponse response = new BaseResponse();
        response.setStatus(200);
        for (ScoresByCommitteeDTO scoresByCommitteeDTO : addScoresData) {
            Course course = courseService.getByCode(scoresByCommitteeDTO.getCourse());
            if (course != null) {
                try {
                    Optional<ScoresByCommittee> optionalScoresByCommittee = scoresByCommitteeDAO.getLasEnteredData(scoresByCommitteeDTO.getNationalCode(),course.getId());
                    ScoresByCommittee scoresByCommittee;
                    if (optionalScoresByCommittee.isPresent()) {
                        scoresByCommittee = optionalScoresByCommittee.get();
                        scoresByCommittee.setId(scoresByCommittee.getId());
                        scoresByCommittee.setScore(scoresByCommitteeDTO.getScore());

                    } else {
                        scoresByCommittee = new ScoresByCommittee();
                        scoresByCommittee.setScore(scoresByCommitteeDTO.getScore());
                        scoresByCommittee.setCourseId(course.getId());
                        scoresByCommittee.setNationalCode(scoresByCommitteeDTO.getNationalCode());
                    }
                    scoresByCommitteeDAO.save(scoresByCommittee);

                } catch (Exception e) {
                    response.setStatus(400);
                    response.setMessage("خطا در ذخیره سازی اطلاعات");
                    break;
                }


            } else {
                response.setStatus(404);
                response.setMessage("دوره ی " + scoresByCommitteeDTO.getCourse() + "در سیستم وجود ندارد");
                break;
            }

        }


        return response;
    }

    @Override
    public String getScore(String nationalCode, Long id) {
        Optional<ScoresByCommittee> optionalScoresByCommittee = scoresByCommitteeDAO.getLasEnteredData(nationalCode,id);
        return optionalScoresByCommittee.map(ScoresByCommittee::getScore).orElse(null);
    }
}
