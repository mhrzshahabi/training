package com.nicico.training.controller;

import com.nicico.training.controller.client.minio.MinIoClient;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.minio.CreateFmsGroupReq;
import response.minio.CreateFmsGroupRes;
import response.minio.FmsConfig;


@RestController
@RequestMapping("/api/fms/")
@RequiredArgsConstructor
public class FmsRestController {

    private final MinIoClient client;

    @Value("${nicico.minioUrl}")
    private String minioUrl;
    @Value("${nicico.minioQuestionsGroup}")
    private String groupId;

    @PostMapping("createFmsGroup")
    public CreateFmsGroupRes createFmsGroup(String token,String name){
//a token that it's user be a admin in training
        CreateFmsGroupReq req=new CreateFmsGroupReq();
        req.setEncrypted(false);
        req.setGeneral(true);
        req.setName(name);
        return client.createGroup(token,req);

    }
//
//    @PostMapping("uploadFile")
//    public UploadFmsRes uploadFile(String token, String groupId , MultipartFile file) {
//        return client.uploadFile(token,file,groupId);
//    }


    @GetMapping("config")
    public ResponseEntity<FmsConfig> getConfig() {
        FmsConfig fmsConfig=new FmsConfig();
        fmsConfig.setGroupId(groupId);
        fmsConfig.setUrl(minioUrl);
        return new ResponseEntity<>(fmsConfig, HttpStatus.OK);
    }

//    @PostMapping("download")
//    public void download(@RequestBody JsonObject object) {
//        FmsConfig fmsConfig=new FmsConfig();
//        fmsConfig.setGroupId(groupId);
//        fmsConfig.setUrl(minioUrl);
//    }
}
