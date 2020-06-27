package com.nicico.training.controller;


import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassDocumentDTO;
import com.nicico.training.iservice.IClassDocumentService;
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
@RequestMapping(value = "/api/classDocument")
public class ClassDocumentRestController {

    private final IClassDocumentService classDocumentService;

    @GetMapping(value = "/iscList/{classId}")
    public ResponseEntity<ISC<ClassDocumentDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, classId, "classId", EOperator.equals);
        SearchDTO.SearchRs<ClassDocumentDTO.Info> searchRs = classDocumentService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
