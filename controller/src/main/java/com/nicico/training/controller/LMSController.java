package com.nicico.training.controller;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.ClassSession.ClassSessionMapper;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Tclass;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@Transactional
@RequestMapping("/api/lms")

public class LMSController {

    private final ITclassService iTclassService;
    private final IClassSession iClassSession;
    private final TclassBeanMapper tclassBeanMapper;
    private final ClassSessionMapper classSessionMapper;

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

    /**
     * date  should be like this "1395/07/18"
     *
     * @param classCode
     * @param sessionDate
     * @return
     */
    @GetMapping("/getTClassSessionsByDate/")
    public ResponseEntity<List<ClassSessionDTO.TClassSessionsDetail>> getTClassSessionsByDate(@RequestParam String classCode,
                                                                                              @RequestParam String sessionDate) {
        Tclass tclass = iTclassService.getClassByCode(classCode);
        if (tclass != null) {
            List<ClassSession> classSessions = iClassSession.getClassSessionsByDate(tclass.getId(), sessionDate);
            List<ClassSessionDTO.TClassSessionsDetail> tClassSessionsDetails = classSessionMapper.toClassSessionDetailsList(classSessions);
            return ResponseEntity.ok(tClassSessionsDetails);
        } else
            throw new TrainingException(TrainingException.ErrorType.TclassNotFound);
    }
}
