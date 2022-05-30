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
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.NeedAssessmentTempDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.iservice.INeedsAssessmentService;
import com.nicico.training.iservice.INeedsAssessmentTempService;
import com.nicico.training.mapper.needsassessment.NeedsAssessmentBeanMapper;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import request.dataForNewSkill.DataForNewSkillDto;
import request.needsassessment.NeedsAssessmentUpdateRequest;
import response.needsassessment.NeedsAssessmentUpdateResponse;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment")
public class NeedsAssessmentRestController {

    private final INeedsAssessmentService iNeedsAssessmentService;
    private final INeedsAssessmentTempService iNeedsAssessmentTempService;
    private final MessageSource messageSource;
    private final ModelMapper modelMapper;
    private final NeedsAssessmentBeanMapper mapper;
    private final com.nicico.training.service.needsassessment.NeedsAssessmentTempService tempService;


    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedsAssessmentDTO.Info>> list() {
        return new ResponseEntity<>(iNeedsAssessmentService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(iNeedsAssessmentService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/editList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentDTO.Info>> iscList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentService.fullSearch(objectId, objectType), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/verifiedNeedsAssessmentList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentDTO.Info>> verifiedNeedsAssessmentList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentService.verifiedNeedsAssessmentList(objectId, objectType), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/workflowList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentDTO.Info>> iscWorkflowList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentService.workflowSearch(objectId, objectType), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{objectType}/{objectId}")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> objectIdIscList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String objectType, @PathVariable Long objectId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "objectId", "equals", objectId.toString()));
    }

    @Loggable
    @PutMapping("/commit/{objectType}/{objectId}")
    public ResponseEntity commit(@PathVariable String objectType, @PathVariable Long objectId) {
        iNeedsAssessmentTempService.verify(objectType, objectId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/rollBack/{objectType}/{objectId}")
    public ResponseEntity rollBack(@PathVariable String objectType, @PathVariable Long objectId) {
        if (iNeedsAssessmentTempService.rollback(objectType, objectId))
            return new ResponseEntity<>(HttpStatus.OK);
        return new ResponseEntity<>(messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
    }

    @Loggable
    @GetMapping("/copy/{typeCopyOf}/{idCopyOf}/{typeCopyTo}/{idCopyTo}")
    public ResponseEntity<Boolean> copyOf(@PathVariable String typeCopyOf,
                                          @PathVariable Long idCopyOf,
                                          @RequestParam(value = "competenceId", required = false) Long competenceId,
                                          @PathVariable String typeCopyTo,
                                          @PathVariable Long idCopyTo) {
        return new ResponseEntity<>(iNeedsAssessmentTempService.copyNA(typeCopyOf, idCopyOf, competenceId, typeCopyTo, idCopyTo), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getValuesForCopyNA/{typeCopyOf}/{idCopyOf}/{typeCopyTo}/{idCopyTo}")
    public ResponseEntity<List<NeedsAssessmentDTO.Info>> getValuesForCopyNA(@PathVariable String typeCopyOf,
                                                                            @PathVariable Long idCopyOf,
                                                                            @RequestParam(value = "competenceId", required = false) Long competenceId,
                                                                            @PathVariable String typeCopyTo,
                                                                            @PathVariable Long idCopyTo) {
        return new ResponseEntity<>(iNeedsAssessmentTempService.getValuesForCopyNA(typeCopyOf, idCopyOf, competenceId, typeCopyTo, idCopyTo), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody Object rq) throws IOException {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        TrainingException exception = iNeedsAssessmentTempService.checkCategoryNotEquals(create);
        if (exception != null)
            throw exception;
        if (!iNeedsAssessmentTempService.isEditable(create.getObjectType(), create.getObjectId()))
            return new ResponseEntity<>(messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
        return new ResponseEntity<>(iNeedsAssessmentTempService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PostMapping("/createOrUpdateList")
    public ResponseEntity<Boolean> createOrUpdateList(@RequestBody Object rq) {
        List<NeedsAssessmentDTO.Create> createList = modelMapper.map(rq, new TypeToken<List<NeedsAssessmentDTO.Create>>() {
        }.getType());
        Boolean hasAlreadySentToWorkFlow = iNeedsAssessmentTempService.createOrUpdateList(createList);
        //zaza
        return new ResponseEntity<>(hasAlreadySentToWorkFlow, HttpStatus.OK);
    }

    @Loggable
    @PostMapping("/updateWorkFlowStatesToSent")
    public ResponseEntity updateWorkFlowStatesToSent(@RequestParam String objectType, @RequestParam Long objectId) {
        iNeedsAssessmentTempService.updateNeedsAssessmentTempMainWorkflowProcessInstanceId(objectType, objectId, 0, "ارسال به گردش کار اصلی");
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<NeedsAssessmentUpdateResponse> update(@PathVariable Long id, @RequestBody NeedsAssessmentUpdateRequest rq) {
        NeedsAssessmentUpdateResponse response = new NeedsAssessmentUpdateResponse();

        if (!iNeedsAssessmentTempService.isEditable(rq.getObjectType(), rq.getObjectId())) {
            response.setMessage(messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()));
            response.setStatus(HttpStatus.CONFLICT.value());
            return new ResponseEntity<>(response, HttpStatus.CONFLICT);
        }

        tempService.update(mapper.toUpdatedNeedsTemp(rq, tempService.get(id)));
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("ویرایش موفقیت آمیز");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}/{objectType}/{objectId}")
    public ResponseEntity delete(@PathVariable Long id, @PathVariable String objectType, @PathVariable Long objectId) {
        if (!iNeedsAssessmentTempService.isEditable(objectType, objectId))
            return new ResponseEntity<>(messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()), HttpStatus.CONFLICT);
        try {
            return new ResponseEntity<>(iNeedsAssessmentTempService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @PostMapping("/workflow")
    public ResponseEntity createInWorkflow(@RequestBody Object rq) {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        return new ResponseEntity<>(iNeedsAssessmentTempService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/workflow/{id}")
    public ResponseEntity updateInWorkflow(@PathVariable Long id, @RequestBody Object rq) {
        NeedsAssessmentDTO.Update update = modelMapper.map(rq, NeedsAssessmentDTO.Update.class);
        return new ResponseEntity<>(iNeedsAssessmentTempService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/workflow/{id}")
    public ResponseEntity deleteInWorkflow(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(iNeedsAssessmentTempService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @GetMapping("/iscTree")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Tree>> iscTree(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        TotalResponse<NeedsAssessmentDTO.Tree> treeTotalResponse = iNeedsAssessmentService.tree(nicicoCriteria);
        return new ResponseEntity<>(treeTotalResponse, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/isReadOnly/{objectType}/{objectId}")
    public ResponseEntity<Boolean> isReadOnly(@PathVariable String objectType,
                                              @PathVariable Long objectId) {
        if (iNeedsAssessmentTempService.readOnlyStatus(objectType, objectId) > 1)
            return new ResponseEntity<>(true, HttpStatus.OK);
        return new ResponseEntity<>(false, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/isCreatedByCurrentUser/{objectType}/{objectId}")
    public ResponseEntity<Boolean> isCreatedByCurrentUser(@PathVariable String objectType,
                                                          @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentTempService.isCreatedByCurrentUser(objectType, objectId), HttpStatus.OK);
    }


    @Loggable
    @PostMapping("/createOrUpdateListForNewSkill")
    public ResponseEntity<Long> createOrUpdateListForNewSkill(@RequestBody DataForNewSkillDto rq) {

        List<NeedsAssessmentDTO.Create> createList = modelMapper.map(rq.getList(), new TypeToken<List<NeedsAssessmentDTO.Create>>() {
        }.getType());
        Long savedId = iNeedsAssessmentTempService.createOrUpdateListForNewSkill(createList,rq.getSkillId());
        return new ResponseEntity<>(savedId, HttpStatus.OK);
    }
    @Loggable
    @GetMapping("/getNeedAssessmentTempByCode")
    public ResponseEntity<NeedAssessmentTempDTO> getNeedAssessmentByCode(@RequestParam String code){
      NeedAssessmentTempDTO dto= tempService.getAllNeedAssessmentTemp(code);
       if(!dto.getCreatedBy().equals(null))
       return new ResponseEntity<>(dto,HttpStatus.OK);
       else
           return new ResponseEntity<>(dto,HttpStatus.NOT_FOUND);

    }
    @Loggable
    @GetMapping("/removeConfirmation")
    public ResponseEntity<Boolean> getNeedAssessmentRemoveConfirmation(@RequestParam String code) {

        boolean b = tempService.removeUnCompleteNaByCode(code);

          if(b)
        return new ResponseEntity<>(b, HttpStatus.OK);
          else
        return new ResponseEntity<>(b,HttpStatus.BAD_REQUEST);

    }

}
