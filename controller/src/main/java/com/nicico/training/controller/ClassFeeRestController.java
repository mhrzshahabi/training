package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassFeeDTO;
import com.nicico.training.iservice.IClassFeeService;
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
@RequestMapping(value = "/api/class-fees")
public class ClassFeeRestController {

    private final IClassFeeService classFeeService;

    @Loggable
    @PostMapping
    public ResponseEntity<ClassFeeDTO.Info> create(@RequestBody ClassFeeDTO.Create create) {
        return new ResponseEntity<>(classFeeService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping
    public ResponseEntity<?> update(@RequestBody ClassFeeDTO.Create update) {
        try {
            classFeeService.update(update);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        classFeeService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<ClassFeeDTO.Info>> list(HttpServletRequest iscRq,
                                                      @RequestParam(value = "_startRow", required = false) Integer startRow,
                                                      @RequestParam(value = "_endRow", required = false) Integer endRow) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);
        SearchDTO.SearchRs<ClassFeeDTO.Info> result = classFeeService.search(searchRq);

        ISC.Response<ClassFeeDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + result.getList().size());
        response.setTotalRows(result.getTotalCount().intValue());
        response.setData(result.getList());
        ISC<ClassFeeDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
