package com.nicico.training.controller;

import com.google.gson.JsonObject;
import com.nicico.training.controller.minio.MinIoClient;
import com.nicico.training.dto.AttachmentDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import request.minio.CreateFmsGroupReq;
import response.minio.CreateFmsGroupRes;
import response.minio.FmsConfig;
import response.minio.UploadFmsRes;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;


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
