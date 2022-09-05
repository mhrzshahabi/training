package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IParameterService;
import com.nicico.training.iservice.IParameterValueService;
import com.nicico.training.model.Parameter;
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
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/parameter-value")
public class ParameterValueRestController {

    private final IParameterValueService iParameterValueService;
    private final IParameterService iParameterService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<ParameterValueDTO.Info>> list() {
        return new ResponseEntity<>(iParameterValueService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(iParameterValueService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/listByCode/{parameterCode}")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> getParametersValueListByCode(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String parameterCode) {
        return new ResponseEntity<>(iParameterService.getByCode(parameterCode), HttpStatus.OK);
    }
    @Loggable
    @GetMapping("/listByCode/v2/gapCompetenceType/iscList")
    public ResponseEntity<TotalResponse<ParameterValueDTO.Info>> gapCompetenceType(@RequestParam MultiValueMap<String, String> criteria) {

        Long parameterId = iParameterService.findByCode("gapCompetenceType");
        if (parameterId!=null)
        return iscList(CriteriaUtil.addCriteria(criteria, "parameterId", "equals", String.valueOf(parameterId)));
        else
            return null;
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
            ParameterValueDTO.Info info=iParameterValueService.checkAndCreate(create);
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
            return new ResponseEntity<>(iParameterValueService.update(id, update), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(iParameterValueService.delete(id), null, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    //////////////////////////////////////////config//////////////////////////////////////////

    @Loggable
    @PutMapping(value = "/edit-config-list")
    public ResponseEntity<List<ParameterValueDTO.Info>> editConfigList(@Validated @RequestBody ParameterValueDTO.ConfigUpdate[] rq) {
        return new ResponseEntity<>(iParameterValueService.editConfigList(rq), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/get-id")
    public ResponseEntity<Long> getParametersValueList(@RequestParam String code) {
        return new ResponseEntity<>(iParameterValueService.getId(code), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/messages/{type}/{target}")
    public ResponseEntity<TotalResponse<ParameterValueDTO>> getMessages(@PathVariable String type,@PathVariable String target) throws IOException {
        return new ResponseEntity<>(iParameterValueService.getMessages(type,target), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-parameter-value/{id}")
    public ResponseEntity editParameterValue(@RequestParam String value,@RequestParam String title,@RequestParam String des,@RequestParam String code,@PathVariable Long id) {
        iParameterValueService.editParameterValue(value,title,des,code,id);
        return new ResponseEntity(null, HttpStatus.OK);
    }
    @Loggable
    @PutMapping(value = "/del-space-parameter-value-des/{id}")
    public ResponseEntity deleteSpaceDescription(@PathVariable Long id) {
        iParameterValueService.editDescription(id);
        return new ResponseEntity(null, HttpStatus.OK);
    }
    @Loggable
    @PutMapping(value = "/edit-des-parameter-value-des/{id}")
    public ResponseEntity editDesDescription(@PathVariable Long id,@RequestParam String des) {
        iParameterValueService.editDesDescription(id,des);
        return new ResponseEntity(null, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-code-parameter-value-des/{id}")
    public ResponseEntity editCodeDescription(@PathVariable Long id,@RequestParam String code) {
        iParameterValueService.editCodeDescription(id,code);
        return new ResponseEntity(null, HttpStatus.OK);
    }
}
