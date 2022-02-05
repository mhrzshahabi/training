package com.nicico.training.service;


import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassEvaluationGoalsDTO;
import com.nicico.training.iservice.IClassEvaluationGoalsService;
import com.nicico.training.model.ClassEvaluationGoals;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Skill;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.ClassEvaluationGoalsDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class ClassEvaluationGoalsService extends BaseService<ClassEvaluationGoals, Long, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDAO> implements IClassEvaluationGoalsService {

    @Autowired
    private final TclassDAO tclassDAO = null;

    @Autowired
    ClassEvaluationGoalsService(ClassEvaluationGoalsDAO classEvaluationGoalsDAO) {
        super(new ClassEvaluationGoals(), classEvaluationGoalsDAO);
    }

    @Transactional
    public List<ClassEvaluationGoalsDTO.Info> getClassGoals(Long classId){
        List<ClassEvaluationGoals> list = dao.findByClassId(classId);
        List<ClassEvaluationGoalsDTO.Info> result = new ArrayList<>();
        if(list != null && list.size() != 0){
            for (ClassEvaluationGoals info : list) {
                result.add(modelMapper.map(info,ClassEvaluationGoalsDTO.Info.class));
            }
        }
        else{
            Optional<Tclass> byId = tclassDAO.findById(classId);
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            for (Goal goal : tclass.getCourse().getGoalSet()) {
                ClassEvaluationGoalsDTO.Info info = new ClassEvaluationGoalsDTO.Info();
                info.setClassId(classId);
                info.setGoalId(goal.getId());
                info.setSkillId(null);
                info.setId(null);
                info.setOriginQuestion(goal.getTitleFa());
                info.setQuestion(goal.getTitleFa());
                result.add(info);
            }

            for(Skill skill : tclass.getCourse().getSkillSet()){
                ClassEvaluationGoalsDTO.Info info = new ClassEvaluationGoalsDTO.Info();
                info.setClassId(classId);
                info.setSkillId(skill.getId());
                info.setGoalId(null);
                info.setId(null);
                info.setOriginQuestion(skill.getTitleFa());
                info.setQuestion(skill.getTitleFa());
                result.add(info);
            }
        }
        return result;
    }

    public void editClassGoalsQuestions(ArrayList<LinkedHashMap> body){
        for (LinkedHashMap map : body) {
            Long classId = null;
            Long skillId = null;
            Long goalId = null;
            String question = null;
            String originQuestion =  null;

            if(map.get("classId") != null)
                classId = Long.parseLong(map.get("classId").toString());
            if(map.get("skillId") != null)
                skillId = Long.parseLong(map.get("skillId").toString());
            if(map.get("goalId") != null)
                goalId = Long.parseLong(map.get("goalId").toString());
            if(map.get("question") != null)
                question =  map.get("question").toString();
            if(map.get("originQuestion") != null)
                originQuestion = map.get("originQuestion").toString();

           if(question != null && !question.equalsIgnoreCase("") && !question.equalsIgnoreCase(" ")){
               ClassEvaluationGoalsDTO.Info classEvaluationGoals = new ClassEvaluationGoalsDTO.Info();
               classEvaluationGoals.setQuestion(question);
               classEvaluationGoals.setClassId(classId);
               classEvaluationGoals.setSkillId(skillId);
               classEvaluationGoals.setGoalId(goalId);
               classEvaluationGoals.setOriginQuestion(originQuestion);
               create(classEvaluationGoals);
           }
           else{
               ClassEvaluationGoalsDTO.Info classEvaluationGoals = new ClassEvaluationGoalsDTO.Info();
               classEvaluationGoals.setQuestion(originQuestion);
               classEvaluationGoals.setClassId(classId);
               classEvaluationGoals.setSkillId(skillId);
               classEvaluationGoals.setGoalId(goalId);
               classEvaluationGoals.setOriginQuestion(originQuestion);
               create(classEvaluationGoals);
           }
        }
    }

    public void deleteClassGoalsQuestions(Long classID){
        List<ClassEvaluationGoals> list = dao.findByClassId(classID);
        if(list != null && list.size() != 0){
            for (ClassEvaluationGoals classEvaluationGoals : list) {
                dao.delete(classEvaluationGoals);
            }
        }
    }

}
