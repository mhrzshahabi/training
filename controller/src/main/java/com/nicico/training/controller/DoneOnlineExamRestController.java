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
import response.exam.DoneOnlineExamDto;
import response.exam.DoneOnlineExamResponse;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/doneOnlineExam")
public class DoneOnlineExamRestController {

    private final ElsClient client;

    @Loggable
    @GetMapping(value = "/{startDate}/{endDate}")
    public ResponseEntity<DoneOnlineExamResponse> get(@PathVariable("startDate") String startDate, @PathVariable("endDate") String endDate) {
        try {
            List<DoneOnlineExamDto> exams = client.getDoneOnlineExams(startDate, endDate);
            if (exams != null && !exams.isEmpty()) {
                exams.forEach(dto -> {
                    if (dto.getUsers() != null && dto.getUsers().size() > 0) {
                        long answeredCount = dto.getUsers().values().stream().filter(DoneOnlineExamDto.UserDetailDto::getAnswered).count();
                        long unAnsweredCount = dto.getUsers().values().stream().filter(user -> (user.getAnswered() != null && !user.getAnswered())).count();
                        dto.setAnsweredCount((int) answeredCount);
                        dto.setUnAnsweredCount((int) unAnsweredCount);
                        dto.getUsers().entrySet().stream().forEach(stringUserDetailDtoEntry -> {
                            stringUserDetailDtoEntry.getValue().setPhoneNumber(stringUserDetailDtoEntry.getKey());
                        });
                    }
                });
            }
            int examSize = (exams == null ? 0 : exams.size());
            DoneOnlineExamResponse response = new DoneOnlineExamResponse().setResponse(new DoneOnlineExamResponse.SpecRs().setData(exams).setStartRow(0).setEndRow(examSize).setTotalRows(examSize));
            return new ResponseEntity(response, HttpStatus.OK);
        } catch (Exception e) {
            BaseResponse response = new BaseResponse();
            if (e.getCause() != null && e.getCause().getMessage() != null && e.getCause().getMessage().equals("Read timed out")) {
                response.setMessage("پاسخی از سیستم آزمون آنلاین دریافت نشد");
                response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                return new ResponseEntity(response, HttpStatus.REQUEST_TIMEOUT);
            }
            response.setMessage("خطا در سیستم آموزش آنلاین");
            response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
            return new ResponseEntity(response, HttpStatus.REQUEST_TIMEOUT);
        }
    }

}
