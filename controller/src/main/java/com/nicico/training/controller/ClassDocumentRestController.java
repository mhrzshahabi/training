package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
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
import javax.servlet.http.HttpServletResponse;
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

    @Loggable
    @PostMapping
    public ResponseEntity<ClassDocumentDTO.Info> create(@RequestBody ClassDocumentDTO.Create request, HttpServletResponse response) {
        return new ResponseEntity<>(classDocumentService.create(request, response), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<ClassDocumentDTO.Info> update(@PathVariable Long id, @RequestBody ClassDocumentDTO.Update request, HttpServletResponse response) {
        return new ResponseEntity<>(classDocumentService.update(id, request, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            classDocumentService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);

    }
    @GetMapping(value = "/checkLetterNum/{classId}/{letterNum}")
    public ResponseEntity<Boolean> checkLetterNum(@PathVariable Long classId, @PathVariable String letterNum){
        Boolean checkLetterNum = classDocumentService.checkLetterNum(classId, letterNum);
        return new ResponseEntity<>(checkLetterNum, HttpStatus.OK);
    }
}
