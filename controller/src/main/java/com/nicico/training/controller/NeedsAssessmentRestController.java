/*
ghazanfari_f,
1/14/2020,
2:46 PM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.NeedAssessmentSkillBasedDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.service.NeedsAssessmentService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment")
public class NeedsAssessmentRestController {

    private final NeedsAssessmentService needsAssessmentService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedsAssessmentDTO.Info>> list() {
        return new ResponseEntity<>(needsAssessmentService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(needsAssessmentService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{objectType}/{objectId}")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> objectIdIscList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String objectType, @PathVariable Long objectId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "objectId", "equals", objectId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity<NeedsAssessmentDTO.Info> create(@RequestBody Object rq) {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        return new ResponseEntity<>(needsAssessmentService.checkAndCreate(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<NeedsAssessmentDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        NeedsAssessmentDTO.Update update = modelMapper.map(rq, NeedsAssessmentDTO.Update.class);
        return new ResponseEntity<>(needsAssessmentService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(needsAssessmentService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

}
