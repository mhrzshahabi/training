package com.nicico.training.service;


import com.nicico.training.iservice.IElsService;
import org.springframework.stereotype.Service;
import request.exam.ExamResult;
import response.BaseResponse;

import java.util.List;

@Service
public class ElsService implements IElsService {



  @Override
    public BaseResponse checkValidScores(Long id, List<ExamResult> examResults) {
        BaseResponse baseResponse =new BaseResponse();



        return baseResponse;
    }

}
