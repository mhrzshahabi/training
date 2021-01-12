package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/person/")
public class PersonRestController {
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final IPersonalInfoService personalInfoService;


    @Loggable
    @GetMapping(value = "/peopleByNationalCode/{nationalCode}")
    public ResponseEntity<PersonDTO> findPeopleByNationalCode(@PathVariable String nationalCode) {
        PersonDTO personDTO = new PersonDTO();
        PersonnelDTO.PersonalityInfo personnel = personnelService.getByNationalCode(nationalCode);
        PersonnelRegisteredDTO.Info personnelRegistered = null;
        PersonalInfoDTO.Info personalInfo = personalInfoService.getOneByNationalCode(nationalCode);
        List<String> roles = new ArrayList<>();
        if (personnel != null ) {
            personDTO.setFirstName(personnel.getFirstName());
            personDTO.setLastName(personnel.getLastName());
            personDTO.setFatherName(personnel.getFatherName());
            personDTO.setBirthDate(personnel.getBirthDate());
            personDTO.setGender(personnel.getGender());
            personDTO.setNationalCode(personnel.getNationalCode());
            personDTO.setMobile(personnel.getMobile());
            personDTO.setEducationLevelTitle(personnel.getEducationLevelTitle());
            personDTO.setEducationMajorTitle(personnel.getEducationMajorTitle());
            personDTO.setPhone(personnel.getPhone());
            personDTO.setEmail(personnel.getEmail());
            String role = "User";
            roles.add(role);
            personDTO.setRoles(roles);
        } else {
            personnelRegistered = personnelRegisteredService.getOneByNationalCode(nationalCode);
            if (personnelRegistered != null){
                personDTO.setFirstName(personnelRegistered.getFirstName());
                personDTO.setLastName(personnelRegistered.getLastName());
                personDTO.setFatherName(personnelRegistered.getFatherName());
                personDTO.setBirthDate(personnelRegistered.getBirthDate());
                personDTO.setGender(personnelRegistered.getGender());
                personDTO.setNationalCode(personnelRegistered.getNationalCode());
                personDTO.setMobile(personnelRegistered.getMobile());
                personDTO.setEducationLevelTitle(personnelRegistered.getEducationLevel());
                personDTO.setEducationMajorTitle(personnelRegistered.getEducationMajor());
                personDTO.setPhone(personnelRegistered.getPhone());
                personDTO.setEmail(personnelRegistered.getEmail());
                String role = "User";
                roles.add(role);
            }
        }
        if (personalInfo != null){
            String role = "Instructor";
            roles.add(role);
            if (personnel == null && personnelRegistered == null){
                personDTO.setFirstName(personalInfo.getFirstNameFa());
                personDTO.setLastName(personalInfo.getLastNameFa());
                personDTO.setFatherName(personalInfo.getFatherName());
                personDTO.setBirthDate(personalInfo.getBirthDate());
                if (personalInfo.getEGender() != null) {
                    personDTO.setGender(personalInfo.getEGender().getTitleFa());
                }
                personDTO.setNationalCode(personalInfo.getNationalCode());
                if (personalInfo.getContactInfo() != null) {
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                    personDTO.setMobile(personalInfo.getContactInfo().getMobile());
                }
                if (personalInfo.getEducationLevel() != null) {
                    personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
                }
                if (personalInfo.getEducationMajor() != null) {
                    personDTO.setEducationMajorTitle(personalInfo.getEducationMajor().getTitleFa());
                }
            }
        }
        if ( personnel != null || personnelRegistered != null || personalInfo != null){
            personDTO.setRoles(roles);
        }

        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
        return new ResponseEntity<>(personDTO, HttpStatus.OK);
    }


}
