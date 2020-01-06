package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.service.ParameterValueService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/parameter-value")
public class ParameterValueRestController {

    private final ParameterValueService parameterValueService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterValueDTO.Info>> list() {
        return new ResponseEntity<>(parameterValueService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterValueService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{parameterId}")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> getParametersValueList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable Long parameterId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "parameterId", "equals", parameterId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity<ParameterValueDTO.Info> create(@RequestBody Object rq) {
        ParameterValueDTO.Create create = modelMapper.map(rq, ParameterValueDTO.Create.class);
        return new ResponseEntity<>(parameterValueService.checkAndCreate(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<ParameterValueDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        ParameterValueDTO.Update update = modelMapper.map(rq, ParameterValueDTO.Update.class);
        return new ResponseEntity<>(parameterValueService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<ParameterValueDTO.Info> delete(@PathVariable Long id) {
        return new ResponseEntity<>(parameterValueService.delete(id), null, HttpStatus.OK);
    }

    //////////////////////////////////////////config//////////////////////////////////////////

    @Loggable
    @PutMapping(value = "/edit-config-list")
    public ResponseEntity<List<ParameterValueDTO.Info>> editConfigList(@Validated @RequestBody ParameterValueDTO.ConfigUpdate[] rq) {
        return new ResponseEntity<>(parameterValueService.editConfigList(rq), HttpStatus.OK);
    }
}
