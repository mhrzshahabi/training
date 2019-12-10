package com.nicico.training.controller;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterTypeDTO;
import com.nicico.training.service.ParameterTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/parameterType")
public class ParameterTypeRestController {

    private final ParameterTypeService parameterTypeService;

    @GetMapping("/list")
    public ResponseEntity<List<ParameterTypeDTO.Info>> list() {
        return new ResponseEntity<>(parameterTypeService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<ParameterTypeDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterTypeService.search(nicicoCriteria), HttpStatus.OK);
    }
}
