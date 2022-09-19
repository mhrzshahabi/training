package com.nicico.training.mapper.person;



import com.nicico.training.dto.PersonDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.model.enums.EGender;
import org.apache.commons.lang3.StringUtils;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class PersonBeanMapper {

    /**
     * set personnel registered's fields
     * @param personDTO
     * @param personnelRegistered
     */
    public void setPersonnelRegisteredFields(PersonDTO personDTO, PersonnelRegisteredDTO.Info personnelRegistered) {
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
    public void setPersonnelFields(PersonDTO personDTO, PersonnelDTO.PersonalityInfo personnel) {
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
        personDTO.setMobile(personnel.getContactInfo()!=null ? checkMobileFormat(personnel.getContactInfo().getMobile()) : null);
        personDTO.setEducationLevelTitle(personnel.getEducationLevelTitle());
        personDTO.setEducationMajorTitle(personnel.getEducationMajorTitle());
        personDTO.setPhone(personnel.getPhone());
        personDTO.setEmail(personnel.getContactInfo()!=null ? personnel.getContactInfo().getEmail() : null);
        personDTO.setPersonnelNo(personnel.getPersonnelNo());
        personDTO.setPersonnelNo2(personnel.getPersonnelNo2());

    }
    /**
     * set personal info's fields such as teacher or a company owners or ...
     * @param personDTO
     * @param personalInfo
     */
    public void setPersonalInfoFields(PersonDTO personDTO, PersonalInfoDTO.Info personalInfo) {
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
