package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.controller.client.els.ElsClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;
import response.exam.ElsExamMonitoringRespDto;
import response.exam.ElsExamStudentsStateDto;

import java.util.List;


@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exam-monitoring")
public class ExamMonitoringRestController {

    private final ElsClient elsClient;

    @GetMapping(value = "/list/{classCode}")
    public ResponseEntity<ISC<ElsExamStudentsStateDto>> getExamMonitoring(@PathVariable String classCode) {

        ISC.Response<ElsExamStudentsStateDto> response = new ISC.Response<>();
        try {
            ElsExamMonitoringRespDto respDto = elsClient.getExamMonitoring(classCode);
            if (respDto.getExamParticipants() != null) {
                response.setStartRow(0);
                response.setEndRow(respDto.getExamParticipants().size());
                response.setTotalRows(respDto.getExamParticipants().size());
                response.setData(respDto.getExamParticipants());
            }
            ISC<ElsExamStudentsStateDto> infoISC = new ISC<>(response);
            return new ResponseEntity<>(infoISC, HttpStatus.OK);
        } catch (Exception e) {
            ISC<ElsExamStudentsStateDto> infoISC = new ISC<>(response);
            return new ResponseEntity<>(infoISC, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Loggable
    @PostMapping(value = "/send-preparation-test")
    public BaseResponse sendPreparationTest(@RequestBody List<Object> records) {
        BaseResponse baseResponse = new BaseResponse();
//        if (testQuestion preparation does not exist for this classCode)
//        create testQuestion
//        else
//        send same testQuestion for these students
        baseResponse.setStatus(HttpStatus.OK.value());
        return baseResponse;
    }

}
