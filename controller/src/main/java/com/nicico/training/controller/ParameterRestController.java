package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.dto.ParameterValueDTO;
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
@RequestMapping("/api/parameter")
public class ParameterRestController {

    private final ParameterService parameterService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/iscList/{code}")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> getByCode(@PathVariable String code) {
        return new ResponseEntity<>(parameterService.getByCode(code), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterDTO.Info>> list() {
        return new ResponseEntity<>(parameterService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<ParameterDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object rq) {
        ParameterDTO.Create create = modelMapper.map(rq, ParameterDTO.Create.class);
        try {
            return new ResponseEntity<>(parameterService.create(create), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object rq) {
        ParameterDTO.Update update = modelMapper.map(rq, ParameterDTO.Update.class);
        try {
            return new ResponseEntity<>(parameterService.update(id, update), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(parameterService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }


    //////////////////////////////////////////config//////////////////////////////////////////

    @Loggable
    @GetMapping("/config-list")
    public ResponseEntity<SearchDTO.SearchRs<ParameterDTO.Config>> configList() {
        return new ResponseEntity<>(parameterService.allConfig(new SearchDTO.SearchRq()), HttpStatus.OK);
    }
}
