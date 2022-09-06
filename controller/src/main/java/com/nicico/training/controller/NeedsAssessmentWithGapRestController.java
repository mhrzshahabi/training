package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedsAssessmentWithGapDTO;
import com.nicico.training.iservice.INeedsAssessmentWithGapService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessmentWithGap")
public class NeedsAssessmentWithGapRestController {
    private final INeedsAssessmentWithGapService iNeedsAssessmentService;


    @Loggable
    @GetMapping("/iscList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentWithGapDTO.Info>> iscList(@PathVariable String objectType, @PathVariable Long objectId) {
        return new ResponseEntity<>(iNeedsAssessmentService.fullSearch(objectId, objectType), HttpStatus.OK);
    }


}
