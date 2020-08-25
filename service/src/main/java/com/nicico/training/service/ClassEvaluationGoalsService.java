package com.nicico.training.service;


import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassEvaluationGoalsDTO;
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
public class ClassEvaluationGoalsService extends BaseService<ClassEvaluationGoals, Long, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDAO>{

    @Autowired
    private final TclassDAO tclassDAO = null;

    @Autowired
    ClassEvaluationGoalsService(ClassEvaluationGoalsDAO classEvaluationGoalsDAO) {
        super(new ClassEvaluationGoals(), classEvaluationGoalsDAO);
    }

    @Transactional
    public List<ClassEvaluationGoalsDTO.Info> getClassGoals(Long classId){
        List<ClassEvaluationGoalsDTO.Info> result = new ArrayList<>();
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        for (Goal goal : tclass.getCourse().getGoalSet()) {
            ClassEvaluationGoalsDTO.Info info = new ClassEvaluationGoalsDTO.Info();
            info.setClassId(classId);
            info.setGoalId(goal.getId());
            info.setSkillId(null);
            info.setId(null);
            info.setGoalQuestion(goal.getTitleFa());
            info.setQuestion(null);
            ClassEvaluationGoals classEvaluationGoals = dao.findByClassIdAndSkillIdAndGoalId(classId,null,goal.getId());
            if(classEvaluationGoals != null) {
                info.setQuestion(classEvaluationGoals.getQuestion());
                info.setId(classEvaluationGoals.getId());
            }
            result.add(info);
        }

        for(Skill skill : tclass.getCourse().getSkillSet()){
            ClassEvaluationGoalsDTO.Info info = new ClassEvaluationGoalsDTO.Info();
            info.setClassId(classId);
            info.setSkillId(skill.getId());
            info.setGoalId(null);
            info.setId(null);
            info.setGoalQuestion(skill.getTitleFa());
            info.setQuestion(null);
            ClassEvaluationGoals classEvaluationGoals = dao.findByClassIdAndSkillIdAndGoalId(classId,skill.getId(),null);
            if(classEvaluationGoals != null){
                info.setQuestion(classEvaluationGoals.getQuestion());
                info.setId(classEvaluationGoals.getId());
            }
            result.add(info);
        }

        return result;
    }

    @Transactional
    public void editClassGoalsQuestions(ArrayList<LinkedHashMap> body){
        for (LinkedHashMap map : body) {
            Long id = null;
            Long classId = null;
            Long skillId = null;
            Long goalId = null;
            String question = null;
            String goalQuestion =  null;

            if(map.get("id") != null)
                id = Long.parseLong(map.get("id").toString());
            if(map.get("classId") != null)
                classId = Long.parseLong(map.get("classId").toString());
            if(map.get("skillId") != null)
                skillId = Long.parseLong(map.get("skillId").toString());
            if(map.get("goalId") != null)
                goalId = Long.parseLong(map.get("goalId").toString());
            if(map.get("question") != null)
                question =  map.get("question").toString();
            if(map.get("question") != null)
                goalQuestion = map.get("goalQuestion").toString();

           if(id == null && question != null && !question.equalsIgnoreCase("") && !question.equalsIgnoreCase(" ")){
               ClassEvaluationGoalsDTO.Info classEvaluationGoals = new ClassEvaluationGoalsDTO.Info();
               classEvaluationGoals.setQuestion(question);
               classEvaluationGoals.setClassId(classId);
               classEvaluationGoals.setSkillId(skillId);
               classEvaluationGoals.setGoalId(goalId);
               create(classEvaluationGoals);
           }
           else if(id != null &&  question != null  && !question.equalsIgnoreCase("") && !question.equalsIgnoreCase(" ")){
               ClassEvaluationGoalsDTO.Info classEvaluationGoals = new ClassEvaluationGoalsDTO.Info();
               classEvaluationGoals.setQuestion(question);
//               classEvaluationGoals.setClassId(classId);
//               classEvaluationGoals.setSkillId(skillId);
//               classEvaluationGoals.setGoalId(goalId);
               classEvaluationGoals.setId(null);

               final Optional<ClassEvaluationGoals> cById = dao.findById(id);
               final ClassEvaluationGoals classEvaluationGoals1 = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
               ClassEvaluationGoals updating = new ClassEvaluationGoals();
               modelMapper.map(classEvaluationGoals, updating);
               modelMapper.map(classEvaluationGoals1, updating);
               update(id,modelMapper.map(updating,ClassEvaluationGoalsDTO.Info.class));
           }
           else if(id != null && (question == null || question.equalsIgnoreCase("") || !question.equalsIgnoreCase(" "))){
               delete(id);
           }
        }
    }
}
