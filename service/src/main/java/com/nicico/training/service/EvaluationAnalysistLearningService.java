package com.nicico.training.service;

import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.IEvaluationAnalysistLearningService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.*;
import java.util.HashMap;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EvaluationAnalysistLearningService implements IEvaluationAnalysistLearningService {
    private final ModelMapper mapper;
    private final ClassStudentDAO classStudentDAO;

    @Transactional
    @Override
    public Float[] getStudents(Long id, String scoringMethod) {
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("0", 0);
        map.put("1001", 20);
        map.put("1002", 50);
        map.put("1003", 65);
        map.put("1004", 100);
        DecimalFormat df = new DecimalFormat("0.00");
        Float[] ans = new Float[4];
        Float sumScore = Float.valueOf(0);
        Float sumPreScore = Float.valueOf(0);
        Float ScoreEvaluation=Float.valueOf(0);
        Float sumValence = Float.valueOf(0);
        int preTestVariable=0;
        int pastTestVariable=0;
        int scoreEvaluationVariable=0;
        List<ClassStudent> classStudents = classStudentDAO.findByTclassId(id);
        List<ClassStudentDTO.evaluationAnalysistLearning> list;
        list = mapper.map(classStudents, new TypeToken<List<ClassStudentDTO.evaluationAnalysistLearning>>() {
        }.getType());
        if (scoringMethod.equals("1")) {
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {
                if (score.getPreTestScore() == null)
                {
                    score.setPreTestScore((float) 0.0);
                    preTestVariable++;
                }

                if (score.getValence() == null)
                {
                    score.setValence(String.valueOf(0));
                    pastTestVariable++;
                }
                sumValence += map.get(score.getValence());
                sumPreScore += score.getPreTestScore();
                ScoreEvaluation += map.get(score.getValence())- score.getPreTestScore();
            }
            ans[0] = Float.valueOf(df.format(sumValence / (list.size()-pastTestVariable)));
            ans[1] = Float.valueOf(df.format(sumPreScore / (list.size()-preTestVariable)));
            //ans[2] = Float.valueOf(list.size());
            ans[3] =  Float.valueOf(df.format(ScoreEvaluation / list.size()));
            pastTestVariable=0;
            preTestVariable=0;
            return ans;
        }
        if (scoringMethod.equals("2")) {
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if(score.getScore() != null && score.getPreTestScore() != null)
                {
                    ScoreEvaluation +=(score.getScore()- score.getPreTestScore());
                    scoreEvaluationVariable++;
                }


                if (score.getScore() == null)
                {
                    score.setScore((float) 0.0);
                    pastTestVariable++;
                }
                if (score.getPreTestScore() == null)
                {
                   score.setPreTestScore((float) 0.0);
                   preTestVariable++;

                }
                sumScore += score.getScore();
                sumPreScore += score.getPreTestScore();
               }
            ans[0] = Float.valueOf(df.format(sumScore / (list.size()-pastTestVariable)));
            ans[1] = Float.valueOf(df.format(sumPreScore / (list.size()-preTestVariable)));
            ans[2] = Float.valueOf(list.size());
            ans[3] =  Float.valueOf(df.format(ScoreEvaluation /scoreEvaluationVariable));
            pastTestVariable=0;
            preTestVariable=0;
            scoreEvaluationVariable=0;
            return ans;
        }
        if(scoringMethod.equals("3"))
        {

            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {


                if(score.getScore() != null && score.getPreTestScore() != null)
                {
                    ScoreEvaluation +=((score.getScore() * 100)/20)- score.getPreTestScore();
                    scoreEvaluationVariable++;
                }


                if (score.getScore() == null)
                {
                    score.setScore((float) 0.0);
                    pastTestVariable++;
                }

                if (score.getPreTestScore() == null)
                {
                    score.setPreTestScore((float) 0.0);
                    preTestVariable++;
                }

                sumScore += ((score.getScore() * 100)/20);
                sumPreScore += score.getPreTestScore();

            }
            ans[0] = Float.valueOf(df.format(sumScore / (list.size()-pastTestVariable)));
            ans[1] = Float.valueOf(df.format(sumPreScore /(list.size()-preTestVariable)));
            ans[2] = Float.valueOf(list.size());
            ans[3] =  Float.valueOf(df.format(ScoreEvaluation /scoreEvaluationVariable));
            return ans;
        }
        if (scoringMethod.equals("4"))
        {
            for (ClassStudentDTO.evaluationAnalysistLearning score : list) {

                if (score.getPreTestScore() == null)
                    score.setPreTestScore((float) 0.0);
                     sumPreScore += score.getPreTestScore();
            }
            ans[0] = (float)0.0;
            ans[1] = Float.valueOf(df.format(sumPreScore / list.size()));
            ans[2] = Float.valueOf(list.size());
            ans[3] =  (float)0.0;
            return ans;
        }

       return null;
    }

    @Transactional
    @Override
    public List<ClassStudentDTO.evaluationAnalysistLearning> getStudentWithOutPreTest(Long id)
    {
        List<ClassStudent> classStudents = classStudentDAO.findByTclassIdAndPreTestScoreIsNull(id);
        return(mapper.map(classStudents, new TypeToken<List<ClassStudentDTO.evaluationAnalysistLearning>>() {}.getType()));
    }

}
