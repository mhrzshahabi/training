package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.controller.client.els.ElsClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import response.BaseResponse;
import response.evaluation.EvaluationDoneOnlineResponse;
import response.evaluation.dto.EvaluationDoneOnlineDto;
import java.util.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationDoneOnline")
public class EvaluationDoneOnlineRestController {
    private final ElsClient client;

    @Loggable
    @GetMapping(value = "/{fromDate}/{toDate}")
    public ResponseEntity<EvaluationDoneOnlineResponse> get(@PathVariable("fromDate") String fromDate, @PathVariable("toDate") String toDate) {
        try {
            List<EvaluationDoneOnlineDto> evaluations = client.getDoneEvaluations(fromDate, toDate);
            if (evaluations != null && !evaluations.isEmpty()) {
                evaluations.forEach(dto -> {
                    if (dto.getUsers() != null && dto.getUsers().size() > 0) {
                        long answeredCount = dto.getUsers().values().stream().filter(EvaluationDoneOnlineDto.UserDetailDto::getAnswered).count();
                        long unAnsweredCount = dto.getUsers().values().stream().filter(user -> (user.getAnswered() != null && !user.getAnswered())).count();
                        dto.setAnsweredCount((int) answeredCount);
                        dto.setUnAnsweredCount((int) unAnsweredCount);
                        dto.getUsers().entrySet().stream().forEach(stringUserDetailDtoEntry -> {stringUserDetailDtoEntry.getValue().setPhoneNumber(stringUserDetailDtoEntry.getKey());});
                    }
                });
            }
            int size = (evaluations == null ? 0 : evaluations.size());
            EvaluationDoneOnlineResponse response = new EvaluationDoneOnlineResponse().setResponse(new EvaluationDoneOnlineResponse.SpecRs().setData(evaluations).setStartRow(0).setEndRow(size).setTotalRows(size));
            return new ResponseEntity(response, HttpStatus.OK);
        } catch (Exception e) {
            BaseResponse response = new BaseResponse();
            if (e.getCause() != null && e.getCause().getMessage() != null && e.getCause().getMessage().equals("Read timed out")) {
                response.setMessage("پاسخی از سیستم ارزشیابی آنلاین دریافت نشد");
                response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                return new ResponseEntity(response, HttpStatus.REQUEST_TIMEOUT);
            }
            response.setMessage("خطا در سیستم آموزش آنلاین");
            response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
            return new ResponseEntity(response, HttpStatus.REQUEST_TIMEOUT);
        }
    }
}
