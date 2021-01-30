package com.nicico.training.mapper.evaluation;


import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.*;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.utility.persianDate.PersianDate;
import dto.Question.QuestionData;
import dto.Question.QuestionScores;
import dto.evaluuation.EvalCourse;
import dto.evaluuation.EvalCourseProtocol;
import dto.evaluuation.EvalQuestionDto;
import dto.evaluuation.EvalTargetUser;
import dto.exam.*;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.evaluation.TrainingEvaluationDto;
import response.exam.ExamQuestionsDto;
import response.question.QuestionsDto;
import response.tclass.dto.TclassEvaluationsDto;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static dto.exam.EQuestionType.MULTI_CHOICES;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface EvaluationMapper {


    @Transactional
    default TclassEvaluationsDto toClassDto(Tclass tclass) {
        for (Evaluation z:tclass.getEvaluations())
        {
            System.out.println(z.getId()+"");
        }
        return null;
    }


    TrainingEvaluationDto toEvaluation(Evaluation evaluation);


    Set<TrainingEvaluationDto> toEvaluations(Set<Evaluation> evaluations);
}
