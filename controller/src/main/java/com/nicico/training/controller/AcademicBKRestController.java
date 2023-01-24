package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AcademicBKDTO;
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
import java.util.LinkedHashMap;

import static com.nicico.training.controller.util.CriteriaUtil.addCriteria;
import static com.nicico.training.controller.util.CriteriaUtil.createCriteria;

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
    public String test() {


        SearchDTO.SearchRq re=new SearchDTO.SearchRq();
        re.setCount(20);
        re.setStartIndex(0);
        SearchDTO.CriteriaRq criteriaRq = addCriteria(new ArrayList<>(), EOperator.or);
        criteriaRq.getCriteria().add(createCriteria(EOperator.equals, "post.code", "10011201/1"));
        re.setCriteria(criteriaRq);



         String fooResourceUrl
                = "http://staging.icico.net.ir/hrm-backend/api/v1/post-persons/filter-by-criteria-custom";
        HttpEntity<SearchDTO.SearchRq> request = new HttpEntity<>(re);

        Object data=  restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, SearchDTO.SearchRq.class);
        return data.toString();

    }

}
