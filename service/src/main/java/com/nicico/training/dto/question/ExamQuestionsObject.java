package com.nicico.training.dto.question;

import dto.exam.ImportedQuestionProtocol;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.exam.ExamQuestionsDto;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class ExamQuestionsObject extends BaseResponse implements Serializable {
    private List<ImportedQuestionProtocol> protocols;
    private ExamQuestionsDto dto;
}
