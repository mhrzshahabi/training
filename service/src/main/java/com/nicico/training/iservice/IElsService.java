package com.nicico.training.iservice;

import dto.exam.ElsImportedExam;
import dto.exam.ExamNotSentToElsDTO;
import dto.exam.ExamStudentDTO;
import request.exam.ElsSendExamToTrainingResponse;
import request.exam.ExamNotSentToElsResponse;
import request.exam.ExamResult;
import response.BaseResponse;

import java.util.List;

public interface IElsService {
    BaseResponse checkValidScores(Long id, List<ExamResult> examResults);

    ElsSendExamToTrainingResponse submitExamFromEls(ElsImportedExam importedExam);

    List<ExamNotSentToElsDTO.Info> getAllExamsNotSentToElsByTeacherNationalCode(String nationalCode);

    List<ExamStudentDTO.Info> getAllStudentsOfExam(Long examId);

    List<String> updateScores(List<ExamStudentDTO.Score> list);

    Boolean updateQuestionActivationState(Long questionId, Boolean isActive);
}
