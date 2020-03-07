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
import java.util.List;

@Service
@RequiredArgsConstructor
public class EvaluationAnalysistLearningService implements IEvaluationAnalysistLearningService {
    private final ModelMapper mapper;
    private final ClassStudentDAO classStudentDAO;

    @Transactional
    @Override
    public Float[] getStudents(Long id)
    {

       DecimalFormat df = new DecimalFormat("0.00");
        Float[] ans=new Float[3] ;
        Float sumScore= Float.valueOf(0);
        Float sumPreScore= Float.valueOf(0);
        List<ClassStudent> classStudents=classStudentDAO.findByTclassId(id);
        List<ClassStudentDTO.evaluationAnalysistLearning> list;
        list = mapper.map(classStudents, new TypeToken<List<ClassStudentDTO.evaluationAnalysistLearning>>() {
        }.getType());

        for (ClassStudentDTO.evaluationAnalysistLearning score: list) {
         if(score.getScore() == null)
         score.setScore((float) 0.0);
         if(score.getPreTestScore() == null)
         score.setPreTestScore((float) 0.0);
         sumScore += score.getScore();
         sumPreScore +=score.getPreTestScore();
        }
                ans[0] = Float.valueOf(df.format(sumScore/list.size()));
                ans[1] = Float.valueOf(df.format(sumPreScore/list.size()));
                ans[2]= Float.valueOf(list.size());
                Float x[]=ans;
                return ans;
                }
                }
