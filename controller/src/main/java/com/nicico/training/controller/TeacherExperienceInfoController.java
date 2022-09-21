package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.model.enums.TeacherRank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacherExperienceInfo")
public class TeacherExperienceInfoController {
    private final ITeacherExperienceInfoService teacherExperienceInfoService;

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<TeacherExperienceInfoDTO.ExcelInfo>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TeacherExperienceInfoDTO.ExcelInfo> searchRs = teacherExperienceInfoService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    @Transactional

    public ResponseEntity addTeacherExecutionInfo(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId, HttpServletResponse response) {



        TeacherExperienceInfoDTO teacherExperienceInfoDTO =new TeacherExperienceInfoDTO();
        teacherExperienceInfoDTO.setTeacherId((Long) request.get("teacher"));
        teacherExperienceInfoDTO.setTeachingExperience(Long.valueOf( request.get("teachingExperience").toString()));

        Integer idRank= (Integer) request.get("teacherRank");

       TeacherRank.values();
       Object o = null;
       for (TeacherRank t:TeacherRank.values()){

           if(t.getId().equals(idRank)){
              o=t;

           }
           }
         teacherExperienceInfoDTO.setTeacherRank((TeacherRank) o);
//       teacherExperienceInfoDTO.setTeacherRank((TeacherRank.valueOf(id));
//        teacherExperienceInfoDTO.setTeacherRank(TeacherRank.);
        teacherExperienceInfoDTO.setSalaryBase(Long.valueOf(request.get("salaryBase").toString()));


        teacherExperienceInfoDTO.setTeacherId(teacherId);

        try {
           teacherExperienceInfoService.addTeacherExperienceInfo(teacherExperienceInfoDTO,response);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }



    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request, HttpServletResponse response) {




        TeacherExperienceInfoDTO update =new TeacherExperienceInfoDTO();
        update.setTeacherId((Long) request.get("teacher"));
       update.setTeachingExperience(Long.valueOf( request.get("teachingExperience").toString()));

        Integer idRank= (Integer)request.get("teacherRank");


        TeacherRank.values();
        Object o = null;
        for (TeacherRank t:TeacherRank.values()){

            if(t.getId().equals(idRank)){
                o=t;

            }
        }
        update.setTeacherRank((TeacherRank) o);
       update.setSalaryBase(Long.valueOf(request.get("salaryBase").toString()));





        try {
            return new ResponseEntity<>(teacherExperienceInfoService.update(id, update,response), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{teacherId},{id}")
    public ResponseEntity deleteTeacherCertification(@PathVariable Long teacherId, @PathVariable Long id) {
        try {
           teacherExperienceInfoService.deleteTeacherExperienceInfo(teacherId, id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @PostMapping("/addTeacherFurtherInfo")
    public ResponseEntity<List<TeacherExperienceInfoDTO.Create>> addTeacherFurtherInfoToTeacher(@RequestBody List<TeacherExperienceInfoDTO.Create> createList) {
        List<TeacherExperienceInfoDTO.Create> returnTeacherNationalCodes = new ArrayList<>();
        try {
            returnTeacherNationalCodes = teacherExperienceInfoService.addTeacherFurtherInfoList(createList);
            return new ResponseEntity<>(returnTeacherNationalCodes, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(returnTeacherNationalCodes, HttpStatus.NOT_FOUND);
        }
    }

}
