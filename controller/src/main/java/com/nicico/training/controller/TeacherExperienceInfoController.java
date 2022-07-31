package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacherExperienceInfo")
public class TeacherExperienceInfoController {
    private final ITeacherExperienceInfoService teacherExperienceInfoService;

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<TeacherExperienceInfoDTO>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TeacherExperienceInfoDTO> searchRs = teacherExperienceInfoService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
