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
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.service.NeedsAssessmentTempService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment")
public class NeedsAssessmentRestController {

    private final NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final MessageSource messageSource;
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
    @GetMapping("/editList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentDTO.Info>> iscList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(needsAssessmentService.fullSearch(objectId, objectType), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{objectType}/{objectId}")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> objectIdIscList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String objectType, @PathVariable Long objectId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "objectId", "equals", objectId.toString()));
    }

    @Loggable
    @PutMapping("/commit/{objectType}/{objectId}")
    public ResponseEntity commit(@PathVariable String objectType, @PathVariable Long objectId) {
        needsAssessmentTempService.verify(objectType, objectId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/rollBack/{objectType}/{objectId}")
    public ResponseEntity rollBack(@PathVariable String objectType, @PathVariable Long objectId) {
        needsAssessmentTempService.rollback(objectType, objectId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object rq) {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        if (!needsAssessmentTempService.isEditable(create.getObjectType(), create.getObjectId()))
            return new ResponseEntity<>(messageSource.getMessage("student.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
        return new ResponseEntity<>(needsAssessmentTempService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object rq) {
        NeedsAssessmentDTO.Update update = modelMapper.map(rq, NeedsAssessmentDTO.Update.class);
        if (!needsAssessmentTempService.isEditable(update.getObjectType(), update.getObjectId()))
            return new ResponseEntity<>(messageSource.getMessage("student.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
        return new ResponseEntity<>(needsAssessmentTempService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}/{objectType}/{objectId}")
    public ResponseEntity delete(@PathVariable Long id, @PathVariable String objectType, @PathVariable Long objectId) {
        if (!needsAssessmentTempService.isEditable(objectType, objectId))
            return new ResponseEntity<>(messageSource.getMessage("student.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
        try {
            return new ResponseEntity<>(needsAssessmentTempService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @PostMapping("/workflow")
    public ResponseEntity createInWorkflow(@RequestBody Object rq) {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        return new ResponseEntity<>(needsAssessmentTempService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/workflow/{id}")
    public ResponseEntity updateInWorkflow(@PathVariable Long id, @RequestBody Object rq) {
        NeedsAssessmentDTO.Update update = modelMapper.map(rq, NeedsAssessmentDTO.Update.class);
        return new ResponseEntity<>(needsAssessmentTempService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/workflow/{id}")
    public ResponseEntity deleteInWorkflow(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(needsAssessmentTempService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @GetMapping("/iscTree")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Tree>> iscTree(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        TotalResponse<NeedsAssessmentDTO.Tree> treeTotalResponse = needsAssessmentService.tree(nicicoCriteria);
        return new ResponseEntity<>(treeTotalResponse, HttpStatus.OK);
    }
}
