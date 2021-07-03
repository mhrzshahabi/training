package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.model.enums.EGender;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
            setPersonnelFields(personDTO, personnel);
            String role = "User";
            roles.add(role);
        } else {
            personnelRegistered = personnelRegisteredService.getOneByNationalCode(nationalCode);
            if (personnelRegistered != null){
                setPersonnelRegisteredFields(personDTO, personnelRegistered);
                String role = "User";
                roles.add(role);
            }
        }
        //if user is a teacher or a company owner
        if (personalInfo != null){
            String role = "Instructor";
            roles.add(role);
            if (personnel == null && personnelRegistered == null){
                setPersonalInfoFields(personDTO, personalInfo);
            } else {
                // we fill fields if there are valid values in other objects
                if(personDTO.getEmail() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getEmail() != null){
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                }
                if(personDTO.getAddress() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null){
                    personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
                }
                if(personDTO.getMobile() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getMobile() != null){
                    personDTO.setMobile(checkMobileFormat(personalInfo.getContactInfo().getMobile()));
                }
                if(personDTO.getPhone() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null){
                    personDTO.setPhone(personalInfo.getContactInfo().getHomeAddress().getPhone());
                }
                if(personDTO.getBirthDate() == null && personalInfo.getBirthDate() != null){
                    personDTO.setBirthDate(personalInfo.getBirthDate());
                }
                if(personDTO.getGender() == null && personalInfo.getGenderId() != null){
                    if (personalInfo.getGenderId().equals(EGender.Male.getId())) {
                        personDTO.setGender(0);
                    } else {
                        personDTO.setGender(1);
                    }
                }
                if(personDTO.getEducationLevelTitle() == null && personalInfo.getEducationLevel() != null){
                    personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
                }
                if(personDTO.getEducationMajorTitle() == null && personalInfo.getEducationMajor() != null){
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

    /**
     * set personal info's fields such as teacher or a company owners or ...
     * @param personDTO
     * @param personalInfo
     */
    private void setPersonalInfoFields(PersonDTO personDTO, PersonalInfoDTO.Info personalInfo) {
        personDTO.setFirstName(personalInfo.getFirstNameFa());
        personDTO.setLastName(personalInfo.getLastNameFa());
        personDTO.setFatherName(personalInfo.getFatherName());
        personDTO.setBirthDate(personalInfo.getBirthDate());
        if (personalInfo.getGenderId() != null) {
            if (personalInfo.getGenderId().equals(EGender.Male.getId())) {
                personDTO.setGender(0);
            } else {
                personDTO.setGender(1);
            }
        }
        personDTO.setNationalCode(personalInfo.getNationalCode());
        if (personalInfo.getContactInfo() != null) {
            personDTO.setEmail(personalInfo.getContactInfo().getEmail());
            personDTO.setMobile(checkMobileFormat(personalInfo.getContactInfo().getMobile()));
            if (personalInfo.getContactInfo().getHomeAddress() != null) {
                personDTO.setPhone(personalInfo.getContactInfo().getHomeAddress().getPhone());
                personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
            }
        }
        if (personalInfo.getEducationLevel() != null) {
            personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
        }
        if (personalInfo.getEducationMajor() != null) {
            personDTO.setEducationMajorTitle(personalInfo.getEducationMajor().getTitleFa());
        }
    }

    /**
     * set personnel registered's fields
     * @param personDTO
     * @param personnelRegistered
     */
    private void setPersonnelRegisteredFields(PersonDTO personDTO, PersonnelRegisteredDTO.Info personnelRegistered) {
        personDTO.setFirstName(personnelRegistered.getFirstName());
        personDTO.setLastName(personnelRegistered.getLastName());
        personDTO.setFatherName(personnelRegistered.getFatherName());
        personDTO.setBirthDate(personnelRegistered.getBirthDate());
        if (personnelRegistered.getGender() != null) {
            if (personnelRegistered.getGender().equals(EGender.Male.getTitleFa())) {
                personDTO.setGender(0);
            } else if (personnelRegistered.getGender().equals(EGender.Female.getTitleFa())) {
                personDTO.setGender(1);
            }
        }
        personDTO.setNationalCode(personnelRegistered.getNationalCode());
        personDTO.setMobile(checkMobileFormat(personnelRegistered.getContactInfo().getMobile()));
        personDTO.setEducationLevelTitle(personnelRegistered.getEducationLevel());
        personDTO.setEducationMajorTitle(personnelRegistered.getEducationMajor());
        personDTO.setPhone(personnelRegistered.getPhone());
        personDTO.setEmail(personnelRegistered.getContactInfo().getEmail());
        personDTO.setPersonnelNo(personnelRegistered.getPersonnelNo());

    }

    /**
     * set personnel's fields
     * @param personDTO
     * @param personnel
     */
    private void setPersonnelFields(PersonDTO personDTO, PersonnelDTO.PersonalityInfo personnel) {
        personDTO.setFirstName(personnel.getFirstName());
        personDTO.setLastName(personnel.getLastName());
        personDTO.setFatherName(personnel.getFatherName());
        personDTO.setBirthDate(personnel.getBirthDate());
        if (personnel.getGender() != null) {
            if (personnel.getGender().equals(EGender.Male.getTitleFa())) {
                personDTO.setGender(0);
            } else if (personnel.getGender().equals(EGender.Female.getTitleFa())) {
                personDTO.setGender(1);
            }
        }
        personDTO.setNationalCode(personnel.getNationalCode());
        personDTO.setMobile(checkMobileFormat(personnel.getContactInfo().getMobile()));
        personDTO.setEducationLevelTitle(personnel.getEducationLevelTitle());
        personDTO.setEducationMajorTitle(personnel.getEducationMajorTitle());
        personDTO.setPhone(personnel.getPhone());
        personDTO.setEmail(personnel.getContactInfo().getEmail());
        personDTO.setPersonnelNo(personnel.getPersonnelNo());
        personDTO.setPersonnelNo2(personnel.getPersonnelNo2());

    }

    public String checkMobileFormat(String mobileNumber) {
        if (mobileNumber == null || mobileNumber.equals("")) {
            return null;
        } else {
            mobileNumber = StringUtils.leftPad(mobileNumber, 11, "0");
            String regexStr = "^09\\d{9}";
            Pattern pattern = Pattern.compile(regexStr);
            Matcher matcher = pattern.matcher(mobileNumber);
            if (!matcher.find())
                return null;
            return mobileNumber;
        }
    }


}
