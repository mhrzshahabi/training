package com.nicico.training.controller.minio;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ElsExtendedExamRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.PdfResponse;
import response.evaluation.dto.EvaluationDoneOnlineDto;
import response.exam.DoneOnlineExamDto;
import response.exam.ExamListResponse;

import java.util.List;


@FeignClient(value = "minIoClient", url = "http://devapp01.icico.net.ir")
public interface MinIoClient {


    @RequestMapping(method = RequestMethod.POST, value = "/group/create")
    BaseResponse createGroup(@RequestBody ElsEvalRequest request);


    @RequestMapping(method = RequestMethod.POST, value = "/group/join")
    BaseResponse joinGroup(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/group/leave")
    BaseResponse leaveGroup(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/{bucketName}/{groupId}")
    BaseResponse uploadFile(@PathVariable("bucketName") String bucketName,@PathVariable("groupId") String groupId);

    @RequestMapping(method = RequestMethod.GET, value = "/{bucketName}/{groupId}/{uuid}")
    BaseResponse downloadFile(@PathVariable("bucketName") String bucketName,@PathVariable("groupId") String groupId,
                              @PathVariable("uuid") String uuid);

    @RequestMapping(method = RequestMethod.GET, value = "/info/{uuid}")
    BaseResponse getInfo(@PathVariable("uuid") String uuid);

    @RequestMapping(method = RequestMethod.POST, value = "/tag/{uuid}")
    BaseResponse createTag(@PathVariable("uuid") String uuid);


}
