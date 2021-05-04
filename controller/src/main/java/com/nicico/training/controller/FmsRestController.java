package com.nicico.training.controller;

import com.nicico.training.controller.minio.MinIoClient;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import request.minio.CreateFmsGroupReq;
import response.minio.CreateFmsGroupRes;
import response.minio.UploadFmsRes;


@RestController
@RequestMapping("/api/fms/")
@RequiredArgsConstructor
public class FmsRestController {

    private final MinIoClient client;

    @PostMapping("createFmsGroup")
    public CreateFmsGroupRes createFmsGroup(String token,String name){
//a token that it's user be a admin in training
        CreateFmsGroupReq req=new CreateFmsGroupReq();
        req.setEncrypted(false);
        req.setGeneral(true);
        req.setName(name);
        return client.createGroup(token,req);

    }

    @PostMapping("uploadFile")
    public UploadFmsRes uploadFile(String token, String groupId , MultipartFile file) {
        return client.uploadFile(token,file,groupId);
    }



    @PostMapping("downloadFile")
    public UploadFmsRes downloadFile(String token, String groupId , String key) {
        return client.downloadFile(token,groupId,key);
    }







}
