package com.nicico.training.controller;

import com.nicico.training.TrainingException;
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
@RequestMapping("/api/lms")

public class LMSController {

    private final ITclassService iTclassService;
    private final TclassBeanMapper tclassBeanMapper;

    @GetMapping("/getCourseDetails/{classCode}")
    public ResponseEntity<TclassDTO.TClassTimeDetails> getCourseTimeDetails(@PathVariable String classCode) {

       Tclass tclass= iTclassService.getClassByCode(classCode);
        if (tclass != null) {
            TclassDTO.TClassTimeDetails tClassTimeDetails = tclassBeanMapper.toTcClassTimeDetail(tclass);
            return ResponseEntity.ok(tClassTimeDetails);
        } else
            throw new TrainingException(TrainingException.ErrorType.TclassNotFound);
    }

    @GetMapping("/getTClassDataService/{classCode}")
    public TclassDTO.TClassDataService  getTClassDataService(@PathVariable String classCode) {

        Tclass tclass = iTclassService.getClassByCode(classCode);
        if (tclass != null)
            return tclassBeanMapper.getTClassDataService(tclass);
        else
            throw new TrainingException(TrainingException.ErrorType.TclassNotFound);
    }
}
