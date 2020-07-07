package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.service.MasterDataService;
import com.nicico.training.service.TargetSocietyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/target-society")
public class TargetSocietyRestController {

    private final TargetSocietyService societyService;
    private final MasterDataService masterDataService;

    @Loggable
    @GetMapping("/getList")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getList(){
        List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getListById/{id}")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getListById(@PathVariable Long id){
        try{
        masterDataService.getDepartmentsByParams("{\"fieldName\":\"id\",\"operator\":\"inSet\",\"value\":{38370,28520}}","2","and","0","");
        List<TargetSocietyDTO.Info> infoList = societyService.getListById(id);
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
        }catch (IOException io){
            return null;
        }
    }
}
