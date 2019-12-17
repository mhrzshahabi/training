package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.service.ParameterService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/parameter-type")
public class ParameterRestController {

    private final ParameterService parameterTypeService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterDTO.Info>> list() {
        return new ResponseEntity<>(parameterTypeService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<ParameterDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterTypeService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<ParameterDTO.Info> create(@RequestBody Object rq) {
        ParameterDTO.Create create = modelMapper.map(rq, ParameterDTO.Create.class);
        return new ResponseEntity<>(parameterTypeService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<ParameterDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        ParameterDTO.Update update = modelMapper.map(rq, ParameterDTO.Update.class);
        return new ResponseEntity<>(parameterTypeService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<ParameterDTO.Info> delete(@PathVariable Long id) {
        return new ResponseEntity<>(parameterTypeService.delete(id), HttpStatus.OK);
    }
}
