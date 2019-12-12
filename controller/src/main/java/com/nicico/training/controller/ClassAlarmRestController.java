package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ClassAlarmDTO;
import com.nicico.training.service.ClassAlarmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/classAlarm")
public class ClassAlarmRestController {

//    private final ClassAlarmService classAlarmService;
//    private final ModelMapper modelMapper;
//
//    //*********************************
//
//    @Loggable
//    @GetMapping(value = "/list")
//    public ResponseEntity<List<ClassAlarmDTO>> list() {
//        return new ResponseEntity<>(classAlarmService.list(), HttpStatus.OK);
//    }

    //*********************************
}
