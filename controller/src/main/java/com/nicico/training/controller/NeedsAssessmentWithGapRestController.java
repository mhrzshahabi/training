package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.NeedsAssessmentWithGapDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.iservice.INeedsAssessmentWithGapService;
import com.nicico.training.iservice.ISkillService;
import lombok.RequiredArgsConstructor;

import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.util.List;
import java.util.Set;

import static com.nicico.training.controller.util.CriteriaUtil.createCriteria;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessmentWithGap")
public class NeedsAssessmentWithGapRestController {
    private final INeedsAssessmentWithGapService iNeedsAssessmentService;


    @Loggable
    @GetMapping("/iscList/{competenceId}/{objectId}/{objectType}")
    public ResponseEntity<SearchDTO.SearchRs<SkillDTO.Info2>> iscList(@PathVariable String objectType, @PathVariable Long objectId, @PathVariable Long competenceId) {
        return new ResponseEntity<>(iNeedsAssessmentService.fullSearchForSkills(objectId, objectType, competenceId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/competence/iscList/{objectId}/{objectType}")
    public ResponseEntity<SearchDTO.SearchRs<CompetenceDTO.Info>> CompetencesIscList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentService.fullSearchForCompetences(objectId, objectType), HttpStatus.OK);
    }

    @Loggable
    @PostMapping("/addSkills")
    public ResponseEntity<BaseResponse> addSkills(@RequestBody NeedsAssessmentWithGapDTO.CreateNeedAssessment createNeedAssessment) {
        BaseResponse response;
        response = iNeedsAssessmentService.addSkills(createNeedAssessment);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @Loggable
    @GetMapping("/sendToWorkFlow/{objectId}/{objectType}")
    public ResponseEntity<BaseResponse> sendToWorkFlow(@PathVariable String objectType, @PathVariable Long objectId) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            baseResponse = iNeedsAssessmentService.sendToWorkFlow(objectId, objectType);
        }catch(Exception e) {
        baseResponse.setStatus(400);
        }
        return new ResponseEntity<>(baseResponse,HttpStatus.valueOf(baseResponse.getStatus()));
}

    @Loggable
    @GetMapping("/deleteUnCompleteData/{objectId}/{objectType}")
    public ResponseEntity<BaseResponse> deleteUnCompleteData(@PathVariable String objectType, @PathVariable Long objectId) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            baseResponse = iNeedsAssessmentService.deleteUnCompleteData(objectId, objectType);
        }catch(Exception e) {
            baseResponse.setStatus(400);
        }
        return new ResponseEntity<>(baseResponse,HttpStatus.valueOf(baseResponse.getStatus()));
    }
    @Loggable
    @GetMapping("/canChangeData/{objectId}/{objectType}")
    public ResponseEntity<Boolean> canChangeData(@PathVariable String objectType, @PathVariable Long objectId) {
        return ResponseEntity.ok(iNeedsAssessmentService.canChangeData(objectType, objectId));

    }

}
