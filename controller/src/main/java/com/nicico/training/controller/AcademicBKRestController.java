package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.dto.HrmFilterDTO;
import com.nicico.training.iservice.IAcademicBKService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/academicBK")
public class AcademicBKRestController {

    private final IAcademicBKService academicBKService;
    private final ModelMapper modelMapper;

    @Autowired
    private RestTemplate restTemplate;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<AcademicBKDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(academicBKService.get(id), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<AcademicBKDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        if(teacherId != null) {
            Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
            SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
            SearchDTO.SearchRs<AcademicBKDTO.Info> searchRs = academicBKService.search(searchRq, teacherId);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
        }
        else
            return new ResponseEntity<>(null,HttpStatus.OK);
    }



    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request) {
        AcademicBKDTO.Update update = modelMapper.map(request, AcademicBKDTO.Update.class);
        try {
            return new ResponseEntity<>(academicBKService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    public ResponseEntity addAcademicBK(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId) {
        AcademicBKDTO.Create create = modelMapper.map(request, AcademicBKDTO.Create.class);
        create.setTeacherId(teacherId);
        try {
            academicBKService.addAcademicBK(create, teacherId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{teacherId},{id}")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity deleteAcademicBK(@PathVariable Long teacherId, @PathVariable Long id) {
        try {
            academicBKService.deleteAcademicBK(teacherId, id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/test")
    public void test() {
        List<HrmFilterDTO> entitys=new ArrayList<>();
        HrmFilterDTO entity =new HrmFilterDTO();
        entity.setField("postId");
        entity.setType("select");
        entity.setOperator("=");
        entity.setValues(Collections.singletonList(40832));
        entity.setFromValues(Collections.singletonList(null));
        entity.setToValues(Collections.singletonList(null));

        ///////////////////////////

        HrmFilterDTO entity2 =new HrmFilterDTO();
        entity2.setField("date");
        entity2.setType("select");
        entity2.setOperator("=");
        entity2.setValues(Collections.singletonList(1647808200));
        entity2.setFromValues(Collections.singletonList(null));
        entity2.setToValues(Collections.singletonList(null));


        entitys.add(entity);
        entitys.add(entity2);


         String fooResourceUrl
                = "http://devapp01.icico.net.ir/hrm-backend/api/v1/post-persons/filter-history?count=30&startIndex=0";
        HttpEntity<List<HrmFilterDTO>> request = new HttpEntity<>(entitys);

          restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, HrmFilterDTO.class);

    }

}
