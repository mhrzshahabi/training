package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IPersonnelInformationService;
import com.nicico.training.model.Tclass;
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

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnelInformation/")
public class PersonnelInformationRestController {

    private final IPersonnelInformationService iPersonnelInformationService;
    private final ModelMapper modelMapper;

    @Loggable
    @Transactional
    @GetMapping(value = "/findCourseByCourseId/{courseId}")
    public ResponseEntity<CourseDTO.CourseDetailInfo> findCourseByCourseId(@PathVariable Long courseId) {
        return new ResponseEntity<>(iPersonnelInformationService.findCourseById(courseId), HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/findClassByClassId/{classId}")
    public ResponseEntity<TclassDTO.ClassDetailInfo> findClassByClassId(@PathVariable Long classId) {
        return new ResponseEntity<>(iPersonnelInformationService.findClassById(classId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/findClassByCourseId/{courseId}")
    public ResponseEntity<TclassDTO.TclassSpecRsHistory> findClassByCourseId(@PathVariable Long courseId) {
        List<TclassDTO.TclassHistory> list = iPersonnelInformationService.findClassesByCourseId(courseId);


        final TclassDTO.SpecRsHistory specResponse = new TclassDTO.SpecRsHistory();
        final TclassDTO.TclassSpecRsHistory specRs = new TclassDTO.TclassSpecRsHistory();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
