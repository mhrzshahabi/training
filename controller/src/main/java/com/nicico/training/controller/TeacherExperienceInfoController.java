package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.dto.enums.TeacherRankDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.model.enums.TeacherRank;
import com.nicico.training.repository.TeacherExperienceInfoDAO;
import com.sun.jdi.LongValue;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.javassist.expr.Instanceof;
import org.aspectj.apache.bcel.classfile.Unknown;
import org.exolab.castor.xml.validators.LongValidator;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacherExperienceInfo")
public class TeacherExperienceInfoController {
    private final ITeacherExperienceInfoService teacherExperienceInfoService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<TeacherExperienceInfoDTO>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TeacherExperienceInfoDTO> searchRs = teacherExperienceInfoService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    @Transactional

    public ResponseEntity addTeacherExecutionInfo(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId, HttpServletResponse response) {



        TeacherExperienceInfoDTO teacherExperienceInfoDTO =new TeacherExperienceInfoDTO();
        teacherExperienceInfoDTO.setTeacherId((Long) request.get("teacher"));
        teacherExperienceInfoDTO.setTeachingExperience(Long.valueOf( request.get("teachingExperience").toString()));
        HashMap hashMap=new HashMap();
        hashMap= (HashMap) request.get("teacherRank");
       Integer id= (Integer) hashMap.get("id");
       TeacherRank.values();
       Object o = null;
       for (TeacherRank t:TeacherRank.values()){

           if(t.getId().equals(id)){
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
        HashMap hashMap=new HashMap();
        hashMap= (HashMap) request.get("teacherRank");
        Integer idRank= (Integer) hashMap.get("id");
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

}
