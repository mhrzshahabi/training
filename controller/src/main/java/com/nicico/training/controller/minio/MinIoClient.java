package com.nicico.training.controller.minio;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import request.minio.CreateFmsGroupReq;
import response.BaseResponse;
import response.minio.CreateFmsGroupRes;
import response.minio.UploadFmsRes;


@FeignClient(value = "minIoClient", url = "http://devapp01.icico.net.ir/fms/")
public interface MinIoClient {


    @RequestMapping(method = RequestMethod.POST, value = "group/create")
    CreateFmsGroupRes createGroup(@RequestHeader("Authorization") String token,@RequestBody CreateFmsGroupReq request);

    @RequestMapping(method = RequestMethod.POST,value = "{groupId}")
    UploadFmsRes uploadFile(@RequestHeader("Authorization") String token,
                            @RequestParam MultipartFile file,
                            @PathVariable("groupId") String groupId);

    @RequestMapping(method = RequestMethod.GET,value = "{groupId}/{key}")
    UploadFmsRes downloadFile(@RequestHeader("Authorization") String token,
                            @PathVariable("groupId") String groupId,
                            @PathVariable("key") String key);



//
//    @RequestMapping(method = RequestMethod.POST, value = "/group/leave")
//    BaseResponse leaveGroup(@RequestBody ElsEvalRequest request);
//
//    @RequestMapping(method = RequestMethod.POST, value = "/{bucketName}/{groupId}")
//    BaseResponse uploadFile(@PathVariable("bucketName") String bucketName,@PathVariable("groupId") String groupId);
//
//    @RequestMapping(method = RequestMethod.GET, value = "/{bucketName}/{groupId}/{uuid}")
//    BaseResponse downloadFile(@PathVariable("bucketName") String bucketName,@PathVariable("groupId") String groupId,
//                              @PathVariable("uuid") String uuid);
//
//    @RequestMapping(method = RequestMethod.GET, value = "/info/{uuid}")
//    BaseResponse getInfo(@PathVariable("uuid") String uuid);
//
//    @RequestMapping(method = RequestMethod.POST, value = "/tag/{uuid}")
//    BaseResponse createTag(@PathVariable("uuid") String uuid);


}
