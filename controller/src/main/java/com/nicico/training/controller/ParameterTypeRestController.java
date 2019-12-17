package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterTypeDTO;
import com.nicico.training.service.ParameterTypeService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/parameter-type")
public class ParameterTypeRestController {

    private final ParameterTypeService parameterTypeService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterTypeDTO.Info>> list() {
        return new ResponseEntity<>(parameterTypeService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<ParameterTypeDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterTypeService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<ParameterTypeDTO.Info> create(@RequestBody Object rq) {
        ParameterTypeDTO.Create create = modelMapper.map(rq, ParameterTypeDTO.Create.class);
        return new ResponseEntity<>(parameterTypeService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<ParameterTypeDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        ParameterTypeDTO.Update update = modelMapper.map(rq, ParameterTypeDTO.Update.class);
        return new ResponseEntity<>(parameterTypeService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<ParameterTypeDTO.Info> delete(@PathVariable Long id) {
        return new ResponseEntity<>(parameterTypeService.delete(id), HttpStatus.OK);
    }
}
