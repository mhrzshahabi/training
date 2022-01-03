package com.nicico.training.controller;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ClassStatusDTO;
import com.nicico.training.dto.enums.ClassTypeDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.ClassSession.ClassSessionMapper;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Tclass;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
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
    public ResponseEntity<TclassTimeDetailBaseDTO> getCourseTimeDetails(@PathVariable String classCode) {
        TclassTimeDetailBaseDTO tclassTimeDetailBaseDTO=new TclassTimeDetailBaseDTO();
       Tclass tclass= iTclassService.getClassByCode(classCode);
        if (tclass != null) {
            TclassDTO.TClassTimeDetails tClassTimeDetails = tclassBeanMapper.toTcClassTimeDetail(tclass);
            tclassTimeDetailBaseDTO.setStatus(200);
            tclassTimeDetailBaseDTO.setData(tClassTimeDetails);
        } else{
            tclassTimeDetailBaseDTO.setStatus(409);
            tclassTimeDetailBaseDTO.setData(null);
            tclassTimeDetailBaseDTO.setMessage("کلاس موجود نیست");
        }
        return ResponseEntity.ok(tclassTimeDetailBaseDTO);
    }

    @GetMapping("/getTClassDataService/{classCode}")
    public ResponseEntity<TclassDataBaseDTO>  getTClassDataService(@PathVariable String classCode) {
        TclassDataBaseDTO tclassDataBaseDTO=new TclassDataBaseDTO();

        Tclass tclass = iTclassService.getClassByCode(classCode);
        if (tclass != null){
            tclassDataBaseDTO.setStatus(200);
            tclassDataBaseDTO.setData(tclassBeanMapper.getTClassDataService(tclass));
        } else{
            tclassDataBaseDTO.setStatus(409);
            tclassDataBaseDTO.setData(null);
            tclassDataBaseDTO.setMessage("کلاس موجود نیست");
        }
        return ResponseEntity.ok(tclassDataBaseDTO);
    }

    /**
     * classStatus  should be like this PLANNING,INPROGRESS,...
     * classType should be like this JOBTRAINING,RETRAINING,...
     *
     * @param classStatus
     * @param classType
     * @return
     */
    @GetMapping("/getCourseDetails")
    public ResponseEntity<TclassBaseDTO> getCourseTimeDetailsViaStatusAndType(@RequestParam ClassStatusDTO classStatus, @RequestParam ClassTypeDTO classType){
        List<Tclass> classes=iTclassService.getClassesViaTypeAndStatus(classStatus,classType);
        List<TclassDTO.TClassTimeDetails> classDTOs=  tclassBeanMapper.toTclassTimeDetailList(classes);
        TclassBaseDTO tclassBaseDTO=new TclassBaseDTO();
        tclassBaseDTO.setStatus(200);
        tclassBaseDTO.setData(classDTOs);
        return ResponseEntity.ok(tclassBaseDTO);
    }


    /**
     * date  should be like this "1395/07/18"
     *
     * @param classCode
     * @param sessionDate
     * @return
     */
    @GetMapping("/getTClassSessionsByDate/")
    public ResponseEntity<TclassSessionDetailBaseDTO> getTClassSessionsByDate(@RequestParam String classCode,
                                                                                              @RequestParam String sessionDate) {
        TclassSessionDetailBaseDTO tclassSessionDetailBaseDTO=new TclassSessionDetailBaseDTO();
        Tclass tclass = iTclassService.getClassByCode(classCode);
        if (tclass != null) {
            List<ClassSession> classSessions = iClassSession.getClassSessionsByDate(tclass.getId(), sessionDate);
            List<ClassSessionDTO.TClassSessionsDetail> tClassSessionsDetails = classSessionMapper.toClassSessionDetailsList(classSessions);
            tclassSessionDetailBaseDTO.setData(tClassSessionsDetails);
            tclassSessionDetailBaseDTO.setStatus(200);
        } else{
            tclassSessionDetailBaseDTO.setData(null);
            tclassSessionDetailBaseDTO.setStatus(409);
            tclassSessionDetailBaseDTO.setMessage("کلاس موجود نیست");
        }
        return ResponseEntity.ok(tclassSessionDetailBaseDTO);
    }

    /**
     * @param classStatus should be like this PLANNING,INPROGRESS,...
     * @param classType should be like this JOBTRAINING,RETRAINING,...
     * @param year  should be like this  "1395"
     * @param term  should be like "1" ,"2" , "3" or "4"
     * @return
     */
    @GetMapping("/getClassDetailsViaYearAndTErm/{page}/{size}")
    public ResponseEntity<TclassBaseDTO> getCourseDetailsViaStatusAndTypeAndYearAndTerm(@RequestParam ClassStatusDTO classStatus, @RequestParam ClassTypeDTO classType,
                                                                                        @RequestParam String year, @RequestParam String term, @PathVariable("page") int page, @PathVariable("size") int size){
      ClassBaseResponse classBaseResponse=  iTclassService.getClassViaTypeAndStatusAndTermInfo(classStatus,classType,year,term,page,size);
      TclassBaseDTO tclassBaseDTO=new TclassBaseDTO();
      tclassBaseDTO.setStatus(classBaseResponse.getStatus());
      tclassBaseDTO.setMessage(classBaseResponse.getMessage());
      if(classBaseResponse.getData()!=null){
         tclassBaseDTO.setData(tclassBeanMapper.toTclassTimeDetailList(classBaseResponse.getData()));
         tclassBaseDTO.setPagination(classBaseResponse.getPaginationDto());
      }
      else{
          tclassBaseDTO.setData(null);
      }
      return ResponseEntity.ok(tclassBaseDTO);
    }
}
