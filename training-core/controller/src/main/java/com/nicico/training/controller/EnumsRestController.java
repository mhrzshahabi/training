package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/10/2019
TIME: 10:40 AM
*/

import com.nicico.training.dto.enums.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/enum/")
public class EnumsRestController {

    @GetMapping("eRunType/spec-list")
    public ResponseEntity<ERunTypeDTO.ERunTypeSpecRs> getERunType() {
        return  new ResponseEntity<>(new ERunTypeDTO.ERunTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eLevelType")
    public ResponseEntity<ELevelTypeDTO.ELevelTypeSpecRs> getELevelType() {
        return  new ResponseEntity<>(new ELevelTypeDTO.ELevelTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eTechnicalType/spec-list")
    public ResponseEntity<ETechnicalTypeDTO.ETechnicalTypeSpecRs> getETechnicalType() {
        return  new ResponseEntity<>(new ETechnicalTypeDTO.ETechnicalTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eTheoType")
    public ResponseEntity<ETheoTypeDTO.ETheoTypeSpecRs> getETheoType() {
        return  new ResponseEntity<>(new ETheoTypeDTO.ETheoTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eCompetenceInputType/spec-list")
    public ResponseEntity<ECompetenceInputTypeDTO.ECompetenceInputTypeSpecRs> getECompetenceInputType() {
        return  new ResponseEntity<>(new ECompetenceInputTypeDTO.ECompetenceInputTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eJobCompetenceType/spec-list")
    public ResponseEntity<EJobCompetenceTypeDTO.EJobCompetenceTypeSpecRs> getEJobCompetenceType() {
        return  new ResponseEntity<>(new EJobCompetenceTypeDTO.EJobCompetenceTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eDomainType")
    public ResponseEntity<EDomainTypeDTO.EDomainTypeSpecRs> getEDomainType(){
        return new ResponseEntity<>(new EDomainTypeDTO.EDomainTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eInstituteType/spec-list")
    public ResponseEntity<EInstituteTypeDTO.EInstituteTypeSpecRs> getEInstituteType() {
        return  new ResponseEntity<>(new EInstituteTypeDTO.EInstituteTypeSpecRs(),HttpStatus.OK);
    }

    @GetMapping("eLicenseType/spec-list")
    public ResponseEntity<ELicenseTypeDTO.ELicenseTypeSpecRs> getELicenseType() {
        return  new ResponseEntity<>(new ELicenseTypeDTO.ELicenseTypeSpecRs(),HttpStatus.OK);
    }
}
