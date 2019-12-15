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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/classAlarm")
public class ClassAlarmRestController {

    private final ClassAlarmService classAlarmService;
    private final ModelMapper modelMapper;

    //*********************************

    @Loggable
    @GetMapping(value = "/list/{classId}")
    public ResponseEntity<ClassAlarmDTO.ClassAlarmSpecRs> list(@PathVariable Long classId) {

        List<ClassAlarmDTO> list = new ArrayList<>();
        list = classAlarmService.list(classId);

        final ClassAlarmDTO.SpecRs specResponse = new ClassAlarmDTO.SpecRs();
        final ClassAlarmDTO.ClassAlarmSpecRs specRs = new ClassAlarmDTO.ClassAlarmSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************
}
