package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.service.ClassStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/class-student")
public class ClassStudentRestController {
    private final ClassStudentService classStudentService;

    @Loggable
    @GetMapping(value = "/students-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.ClassStudentInfo>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs =
                classStudentService.searchClassStudents(searchRq, classId, ClassStudentDTO.ClassStudentInfo.class);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/attendance-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.AttendanceInfo>> attendanceList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassStudentDTO.AttendanceInfo> searchRs =
                classStudentService.searchClassStudents(searchRq, classId, ClassStudentDTO.AttendanceInfo.class);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/classes-of-student/{nationalCode}")
    public ResponseEntity<ISC<ClassStudentDTO.CoursesOfStudent>> classesOfStudentList(HttpServletRequest iscRq, @PathVariable String nationalCode) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassStudentDTO.CoursesOfStudent> searchRs =
                classStudentService.searchClassesOfStudent(searchRq, nationalCode, ClassStudentDTO.CoursesOfStudent.class);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/scores-iscList/{classId}")
    public ResponseEntity<ISC<ClassStudentDTO.ScoresInfo>> scoresList(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ClassStudentDTO.ScoresInfo> searchRs =
                classStudentService.searchClassStudents(searchRq, classId, ClassStudentDTO.ScoresInfo.class);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/register-students/{classId}")
    public ResponseEntity registerStudents(@RequestBody List<ClassStudentDTO.Create> request, @PathVariable Long classId) {
        try {
            classStudentService.registerStudents(request, classId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object request) {
        try {
            return new ResponseEntity<>(classStudentService.update(id, request, ClassStudentDTO.ScoresInfo.class), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping
    //    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity removeStudents(@RequestBody ClassStudentDTO.Delete request) {
        try {
            classStudentService.delete(request);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            classStudentService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

//    @Loggable
//    @PutMapping(value = "/setStudentFormIssuance/{idClassStudent}/{reaction}")
//    public Integer setStudentFormIssuance(@PathVariable Long idClassStudent, @PathVariable Integer reaction) {
//        return classStudentService.setStudentFormIssuance(idClassStudent, reaction);
//    }


    @Loggable
    @PutMapping(value = "/setStudentFormIssuance")
    public Integer setStudentFormIssuance(@RequestBody Map<String, Integer> formIssuance) {
        return classStudentService.setStudentFormIssuance(formIssuance);
    }
}