package com.nicico.training.controller;

import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.Tclass;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@Transactional
@RequestMapping("/api/test")

public class TestController {
    private final ITclassService tclassService;
    private final TclassBeanMapper tclassBeanMapper;


    @GetMapping("/getCourseDetails/{code}")
    public ResponseEntity<TclassDTO.TClassTimeDetails> getCourseTimeDetails(@PathVariable String code){
       Tclass tclass= tclassService.getClassByCode(code);
              TclassDTO.TClassTimeDetails tClassTimeDetails      = tclassBeanMapper.toTcClassTimeDetail(tclass);

 return ResponseEntity.ok(tClassTimeDetails);
    }
}
