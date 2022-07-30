package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.iservice.ITeacherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacherExperienceInfo")
public class TeacherExperienceInfoController {
    private final ITeacherExperienceInfoService teacherExperienceInfoService;

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<TeacherExperienceInfoDTO>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
//        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
//        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
//        SearchDTO.SearchRs<TeacherExperienceInfoDTO> searchRs =teacherExperienceInfoService.search(searchRq, teacherId);
//        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
        return null;
    }

}
