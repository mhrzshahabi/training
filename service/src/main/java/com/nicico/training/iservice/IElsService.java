package com.nicico.training.iservice;

import request.exam.ExamResult;
import response.BaseResponse;

import java.util.List;

public interface IElsService {
    BaseResponse checkValidScores(Long id, List<ExamResult> examResults);
}
