package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.model.Course;
import com.nicico.training.service.PersonnelInformationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnelInformation/")
public class PersonnelInformationRestController {

    private  final PersonnelInformationService personnelInformationService;
    private final ModelMapper modelMapper;

    @Loggable
    @Transactional
    @GetMapping(value = "/findCourseByCourseId/{courseId}")
    public ResponseEntity<CourseDTO.CourseDetailInfo> findCourseByCourseId(@PathVariable Long courseId)
    {
        CourseDTO.CourseDetailInfo  ddd= modelMapper.map(personnelInformationService.findCourseById(courseId), CourseDTO.CourseDetailInfo.class);

        ddd.setMainObjective("1 \n 2 <br/> 3");
        return new ResponseEntity<>( ddd, HttpStatus.OK);
    }
}
