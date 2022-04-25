package com.nicico.training.controller;

import com.nicico.training.dto.enums.*;
import com.nicico.training.model.enums.ETechnicalType;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/enum/")
public class EnumsRestController {

    @GetMapping("eRunType/spec-list")
    public ResponseEntity<ERunTypeDTO.ERunTypeSpecRs> getERunType() {
        return new ResponseEntity<>(new ERunTypeDTO.ERunTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eLevelType")
    public ResponseEntity<ELevelTypeDTO.ELevelTypeSpecRs> getELevelType() {
        return new ResponseEntity<>(new ELevelTypeDTO.ELevelTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eTechnicalType/spec-list")
    public ResponseEntity<ETechnicalTypeDTO.ETechnicalTypeSpecRs> getETechnicalType() {
        ETechnicalTypeDTO.ETechnicalTypeSpecRs rs = new ETechnicalTypeDTO.ETechnicalTypeSpecRs();
        ETechnicalTypeDTO.SpecRs response = rs.getResponse();
        Map<Integer, String> map = new HashMap<>();
        ETechnicalType[] data = response.getData();
        for (ETechnicalType datum : data) {
            map.put(datum.getId(), datum.getTitleFa());
        }
        return new ResponseEntity<>(new ETechnicalTypeDTO.ETechnicalTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eTechnicalType/map")
    public ResponseEntity<Map<Integer, String>> getETechnicalTypeMap() {
        ETechnicalType[] data = ETechnicalType.values();
        Map<Integer, String> map = new HashMap<>();
        for (ETechnicalType datum : data) {
            map.put(datum.getId(), datum.getTitleFa());
        }
        return new ResponseEntity<>(map, HttpStatus.OK);
    }

    @GetMapping("eTheoType")
    public ResponseEntity<ETheoTypeDTO.ETheoTypeSpecRs> getETheoType() {
        return new ResponseEntity<>(new ETheoTypeDTO.ETheoTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eCompetenceInputType/spec-list")
    public ResponseEntity<ECompetenceInputTypeDTO.ECompetenceInputTypeSpecRs> getECompetenceInputType() {
        return new ResponseEntity<>(new ECompetenceInputTypeDTO.ECompetenceInputTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eJobCompetenceType/spec-list")
    public ResponseEntity<EJobCompetenceTypeDTO.EJobCompetenceTypeSpecRs> getEJobCompetenceType() {
        return new ResponseEntity<>(new EJobCompetenceTypeDTO.EJobCompetenceTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eDomainType")
    public ResponseEntity<EDomainTypeDTO.EDomainTypeSpecRs> getEDomainType() {
        return new ResponseEntity<>(new EDomainTypeDTO.EDomainTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eInstituteType/spec-list")
    public ResponseEntity<EInstituteTypeDTO.EInstituteTypeSpecRs> getEInstituteType() {
        return new ResponseEntity<>(new EInstituteTypeDTO.EInstituteTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eLicenseType/spec-list")
    public ResponseEntity<ELicenseTypeDTO.ELicenseTypeSpecRs> getELicenseType() {
        return new ResponseEntity<>(new ELicenseTypeDTO.ELicenseTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eGender/spec-list")
    public ResponseEntity<EGenderDTO.EGenderSpecRs> getEGender() {
        return new ResponseEntity<>(new EGenderDTO.EGenderSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eMilitary/spec-list")
    public ResponseEntity<EMilitaryDTO.EMilitarySpecRs> getEMilitary() {
        return new ResponseEntity<>(new EMilitaryDTO.EMilitarySpecRs(), HttpStatus.OK);
    }

    @GetMapping("eMarried/spec-list")
    public ResponseEntity<EMarriedDTO.EMarriedSpecRs> getEMarried() {
        return new ResponseEntity<>(new EMarriedDTO.EMarriedSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eNeedAssessmentPriority/spec-list")
    public ResponseEntity<ENeedAssessmentPriorityDTO.ENeedAssessmentPrioritySpecRs> getENeedAssessmentPriority() {
        return new ResponseEntity<>(new ENeedAssessmentPriorityDTO.ENeedAssessmentPrioritySpecRs(), HttpStatus.OK);
    }

    @GetMapping("ePlaceType/spec-list")
    public ResponseEntity<EPlaceTypeDTO.EPlaceTypeSpecRs> getEPlaceType() {
        return new ResponseEntity<>(new EPlaceTypeDTO.EPlaceTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eArrangementType/spec-list")
    public ResponseEntity<EArrangementTypeDTO.EArrangementTypeSpecRs> getEArrangementType() {
        return new ResponseEntity<>(new EArrangementTypeDTO.EArrangementTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eTeacherAttachmentType/spec-list")
    public ResponseEntity<ETeacherAttachmentTypeDTO.ETeacherAttachmentTypeSpecRs> ETeacherAttachmentType() {
        return new ResponseEntity<>(new ETeacherAttachmentTypeDTO.ETeacherAttachmentTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eClassAttachmentType/spec-list")
    public ResponseEntity<EClassAttachmentTypeDTO.EClassAttachmentTypeSpecRs> EClassAttachmentType() {
        return new ResponseEntity<>(new EClassAttachmentTypeDTO.EClassAttachmentTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eLangLevel/spec-list")
    public ResponseEntity<ELangLevelDTO.ELangLevelSpecRs> ELangLevel() {
        return new ResponseEntity<>(new ELangLevelDTO.ELangLevelSpecRs(), HttpStatus.OK);
    }

    @GetMapping("ePublicationSubjectType/spec-list")
    public ResponseEntity<EPublicationSubjectTypeDTO.EPublicationSubjectTypeSpecRs> EPublicationSubjectType() {
        return new ResponseEntity<>(new EPublicationSubjectTypeDTO.EPublicationSubjectTypeSpecRs(), HttpStatus.OK);
    }

    @GetMapping("eQuestionLevel/spec-list")
    public ResponseEntity<EQuestionLevelDTO.EQuestionLevelSpecRs> getEQuestionLevel() {
        return new ResponseEntity<>(new EQuestionLevelDTO.EQuestionLevelSpecRs(), HttpStatus.OK);
    }

    @GetMapping("serviceType/spec-list")
    public ResponseEntity<EServiceTypeDTO.EServiceTypeSpecRs> getEServiceType() {
        return new ResponseEntity<>(new EServiceTypeDTO.EServiceTypeSpecRs(), HttpStatus.OK);
    }

}
