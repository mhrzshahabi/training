package com.nicico.training.controller;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ClassStatusDTO;
import com.nicico.training.dto.enums.ClassTypeDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.ClassSession.ClassSessionMapper;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.mapper.teacher.TeacherBeanMapper;
import com.nicico.training.mapper.teacher.TeacherBeanMapperImpl;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import response.PaginationDto;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@Transactional
@RequestMapping("/api/lms")

public class LMSController {

    private final ITclassService iTclassService;
    private final IClassSession iClassSession;
    private final ITeacherService iTeacherService;
    private final TclassBeanMapper tclassBeanMapper;
    private final ClassSessionMapper classSessionMapper;
    private final TeacherBeanMapper teacherBeanMapper;

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

    @GetMapping("/getActiveTeachers/{page}/{size}")
    public ResponseEntity<TeacherInfoBaseDTO> getActiveTeachers(@PathVariable("page")  int page,@PathVariable("size") int size){
      Page<Teacher> teachers= iTeacherService.getActiveTeachers(page,size);
       TeacherInfoBaseDTO teacherInfoBaseDTO=new TeacherInfoBaseDTO();
        if(teachers==null) {
            teacherInfoBaseDTO.setMessage("استاد فعالی وجود ندارد");
            teacherInfoBaseDTO.setStatus(409);
            teacherInfoBaseDTO.setData(null);
        }
        else {
            teacherInfoBaseDTO.setStatus(200);
            teacherInfoBaseDTO.setData(teacherBeanMapper.toTeacherInfoDTOs(teachers.stream().toList()));
            PaginationDto paginationDto=new PaginationDto();
            paginationDto.setSize(size);
            paginationDto.setTotal(teachers.getTotalPages()-1);
            paginationDto.setTotalItems(teachers.get().count());
            teacherInfoBaseDTO.setPaginationDto(paginationDto);
        }

      return ResponseEntity.ok(teacherInfoBaseDTO);

    }

}
