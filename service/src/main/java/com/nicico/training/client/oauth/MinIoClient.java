package com.nicico.training.client.oauth;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import request.minio.CreateFmsGroupReq;
import response.minio.CreateFmsGroupRes;
import response.minio.UploadFmsRes;


@FeignClient(value = "minIoClient", url ="${nicico.minioUrl}")
public interface MinIoClient {

    @RequestMapping(method = RequestMethod.GET,value = "{groupId}/{key}")
    ByteArrayResource downloadFile(@RequestHeader("user-id") String token,
                                   @RequestHeader("app-id") String appId,
                                   @PathVariable("groupId") String groupId,
                                   @PathVariable("key") String key);

}
