package com.nicico.training.controller;


import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.minio.MinIoClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ExamsType;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.dto.question.ElsResendExamRequestResponse;
import com.nicico.training.dto.question.ExamQuestionsObject;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.QuestionBank.QuestionBankBeanMapper;
import com.nicico.training.mapper.attendance.AttendanceBeanMapper;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.mapper.person.PersonBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EGender;
import com.nicico.training.service.*;
import dto.evaluuation.EvalTargetUser;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import request.attendance.ElsTeacherAttendanceListSaveDto;
import request.evaluation.ElsEvalRequest;
import request.evaluation.ElsUserEvaluationListResponseDto;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import request.exam.*;
import response.BaseResponse;
import response.attendance.AttendanceListSaveResponse;
import response.evaluation.ElsEvaluationsListResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.evaluation.dto.ElsContactEvaluationDto;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ResendExamTimes;
import response.question.dto.ElsCategoryDto;
import response.question.dto.ElsQuestionBankDto;
import response.question.dto.ElsQuestionDto;
import response.question.dto.ElsSubCategoryDto;
import response.tclass.ElsSessionAttendanceResponse;
import response.tclass.ElsSessionResponse;
import response.tclass.ElsStudentAttendanceListResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@RestController
@RequestMapping("/anonymous/api")
@RequiredArgsConstructor
public class AnonymousRestController {
    private final IPersonnelRegisteredService personnelRegisteredService;

    @GetMapping("/changeContactInfo/{id}")
    public void changeContactInfo(@PathVariable long id) {
        personnelRegisteredService.changeContactInfo(id);
    }


}
