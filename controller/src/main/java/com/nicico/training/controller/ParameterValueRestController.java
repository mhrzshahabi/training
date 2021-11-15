package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.service.ParameterService;
import com.nicico.training.service.ParameterValueService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/parameter-value")
public class ParameterValueRestController {

    private final ParameterValueService parameterValueService;
    private final ParameterService parameterService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterValueDTO.Info>> list() {
        return new ResponseEntity<>(parameterValueService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(parameterValueService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/listByCode/{parameterCode}")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> getParametersValueListByCode(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String parameterCode) {
        return new ResponseEntity<>(parameterService.getByCode(parameterCode), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{parameterId}")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> getParametersValueListById(@RequestParam MultiValueMap<String, String> criteria, @PathVariable Long parameterId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "parameterId", "equals", parameterId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object rq) {
        ParameterValueDTO.Create create = modelMapper.map(rq, ParameterValueDTO.Create.class);
        try {
            ParameterValueDTO.Info info=parameterValueService.checkAndCreate(create);
            return new ResponseEntity<>(info, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object rq) {
        ParameterValueDTO.Update update = modelMapper.map(rq, ParameterValueDTO.Update.class);
        try {
            return new ResponseEntity<>(parameterValueService.update(id, update), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(parameterValueService.delete(id), null, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    //////////////////////////////////////////config//////////////////////////////////////////

    @Loggable
    @PutMapping(value = "/edit-config-list")
    public ResponseEntity<List<ParameterValueDTO.Info>> editConfigList(@Validated @RequestBody ParameterValueDTO.ConfigUpdate[] rq) {
        return new ResponseEntity<>(parameterValueService.editConfigList(rq), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/get-id")
    public ResponseEntity<Long> getParametersValueList(@RequestParam String code) {
        return new ResponseEntity<>(parameterValueService.getId(code), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/messages/{type}/{target}")
    public ResponseEntity<TotalResponse<ParameterValueDTO>> getMessages(@PathVariable String type,@PathVariable String target) throws IOException {
        return new ResponseEntity<>(parameterValueService.getMessages(type,target), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-parameter-value/{id}")
    public ResponseEntity editParameterValue(@RequestParam String value,@RequestParam String title,@RequestParam String des,@RequestParam String code,@PathVariable Long id) {
        parameterValueService.editParameterValue(value,title,des,code,id);
        return new ResponseEntity(null, HttpStatus.OK);
    }
    @Loggable
    @PutMapping(value = "/edit-parameter-value/{id}")
    public ResponseEntity editDescription(@PathVariable Long id) {
        parameterValueService.editDescription(id);
        return new ResponseEntity(null, HttpStatus.OK);
    }
}
