package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/target-society")
public class TargetSocietyRestController {

    private final TclassService tclassService;
    private final TargetSocietyService societyService;

    @Loggable
    @GetMapping("/getList")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getList(){
        List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getListById/{id}")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getListById(@PathVariable Long id){
        Long targetType = tclassService.getTargetSocietyTypeById(id).getId();
        Iterator<TargetSocietyDTO.Info> infoIterator = tclassService.getTargetSocietiesListById(id).iterator();
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(societyService.getTargetSocietiesById(infoIterator, targetType), HttpStatus.OK);
    }
}
