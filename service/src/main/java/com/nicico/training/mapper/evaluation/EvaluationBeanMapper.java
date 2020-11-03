package com.nicico.training.mapper.evaluation;


import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.Questionnaire;
import com.nicico.training.model.Student;
import dto.EvalQuestionDto;
import dto.EvalTargetUser;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import request.evaluation.ElsEvalRequest;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface EvaluationBeanMapper {

    @Mapping(source = "firstName", target = "surname")
    @Mapping(source = "lastName", target = "lastName")
    @Mapping(source = "nationalCode", target = "nationalCode")
    @Mapping(source = "gender", target = "gender")
    @Mapping(source = "mobile", target = "cellNumber")
    EvalTargetUser toTargetUser(Student student);

    default ElsEvalRequest toElsEvalRequest(Evaluation evaluation, Questionnaire questionnaire,List<ClassStudent> classStudents,
                                            List<EvalQuestionDto> questionDtos) {
        ElsEvalRequest request = new ElsEvalRequest();
        request.setId(evaluation.getId());
        request.setTitle(questionnaire.getTitle());
        try {
            request.setOrganizer(evaluation.getTclass().getOrganizer().getTitleFa());
            request.setPlanner(evaluation.getTclass().getPlanner().getFirstName() + " " +
                    evaluation.getTclass().getPlanner().getLastName());
        }catch (NullPointerException ignored) {
        }
        request.setTargetUsers(classStudents.stream()
        .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));
        request.setQuestions(questionDtos);
        return request;
    }
}
