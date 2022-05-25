package com.nicico.training.mapper.agreement;

import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.Agreement;
import com.nicico.training.model.Institute;
import com.nicico.training.model.PersonalInfo;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class AgreementBeanMapper {


    @Autowired
    protected IAddressService addressService;
    @Autowired
    protected ITeacherService teacherService;
    @Autowired
    protected IInstituteService instituteService;
    @Autowired
    protected IAgreementService agreementService;
    @Autowired
    protected IAccountInfoService accountInfoService;
    @Autowired
    protected IContactInfoService contactInfoService;
    @Autowired
    protected IPersonalInfoService personalInfoService;
    @Autowired
    protected IEducationLevelService educationLevelService;
    @Autowired
    protected IParameterValueService parameterValueService;

    @Mapping(source = "firstPartyId", target = "firstParty", qualifiedByName = "toFirstParty")
    @Mapping(source = "id", target = "secondParty", qualifiedByName = "toSecondParty")
    @Mapping(source = "secondPartyTeacherId", target = "secondPartyTeacher", qualifiedByName = "toSecondPartyTeacher")
    @Mapping(source = "secondPartyInstituteId", target = "secondPartyInstitute", qualifiedByName = "toSecondPartyInstitute")
    @Mapping(source = "currencyId", target = "currency", qualifiedByName = "toStringCurrency")
    public abstract AgreementDTO.PrintInfo toAgreementPrintInfo (Agreement agreement);

    @Named("toFirstParty")
    Map<String, String> toFirstParty(Long firstPartyId) {
        Map<String, String> map = new HashMap<>();
        map.put("firstPartyName", "");
        map.put("firstPartyEconomicalId", "");
        map.put("firstPartyPhone", "");
        map.put("firstPartyFax", "");

        if (firstPartyId != null) {
            map.put("firstPartyName", instituteService.getInstitute(firstPartyId).getTitleFa());
            map.put("firstPartyEconomicalId", instituteService.getInstitute(firstPartyId).getEconomicalId());
            Long contactInfoId = instituteService.getInstitute(firstPartyId).getContactInfoId();
            if (contactInfoId != null) {
                Long workAddressId = contactInfoService.get(contactInfoId).getWorkAddressId();
                if (workAddressId != null) {
                    map.put("firstPartyPhone", addressService.get(workAddressId).getPhone());
                    map.put("firstPartyFax", addressService.get(workAddressId).getFax());
                }
            }
        }
        return map;
    }

    @Named("toSecondParty")
    Map<String, String> toSecondParty(Long agreementId) {
        Map<String, String> map = new HashMap<>();
        map.put("secondPartyName", "");
        map.put("secondPartyShaba", "");
        map.put("secondPartyBank", "");

        Agreement agreement = agreementService.get(agreementId);
        if (agreement != null) {
            if (agreement.getSecondPartyTeacherId() != null) {
                Long personalityId = teacherService.get(agreement.getSecondPartyTeacherId()).getPersonalityId();
                if (personalityId != null) {
                    PersonalInfo personalInfo = personalInfoService.getPersonalInfo(personalityId);
                    map.put("secondPartyName", personalInfo.getFirstNameFa());
                    Long accountInfoId = personalInfo.getAccountInfoId();
                    if (accountInfoId != null) {
                        map.put("secondPartyShaba", accountInfoService.get(accountInfoId).getShabaNumber());
                        map.put("secondPartyBank", accountInfoService.get(accountInfoId).getBank());
                    }
                }
            } else {
                Institute institute = instituteService.getInstitute(agreement.getSecondPartyInstituteId());
                map.put("secondPartyName", institute.getTitleFa());
//                if (institute.getAccountInfoSet().size() !=0) {
//                    Optional<AccountInfo> accountInfo = institute.getAccountInfoSet().stream().findFirst();
//                    if (accountInfo.isPresent()) {
//                        map.put("secondPartyShaba", accountInfo.get().getShabaNumber());
//                        map.put("secondPartyBank", accountInfo.get().getBank());
//                    }
//                }
            }
        }
        return map;
    }

    @Named("toSecondPartyTeacher")
    Map<String, String> toSecondPartyTeacher(Long secondPartyTeacherId) {
        Map<String, String> map = new HashMap<>();
        map.put("teacherName", "");
        map.put("teacherLastName", "");
        map.put("teacherFatherName", "");
        map.put("teacherBirthCertificate", "");
        map.put("teacherNationalCode", "");
        map.put("teacherBirthDate", "");
        map.put("teacherEducationLevel", "");
        map.put("teacherAddress", "");
        map.put("teacherPostalCode", "");
        map.put("teacherMobile", "");

        if (secondPartyTeacherId != null) {
            Long personalityId = teacherService.get(secondPartyTeacherId).getPersonalityId();
            if (personalityId != null) {
                PersonalInfo personalInfo = personalInfoService.getPersonalInfo(personalityId);
                map.put("teacherName", personalInfo.getFirstNameFa());
                map.put("teacherLastName", personalInfo.getLastNameFa());
                map.put("teacherFatherName", personalInfo.getFatherName());
                map.put("teacherBirthCertificate", personalInfo.getBirthCertificate());
                map.put("teacherNationalCode", personalInfo.getNationalCode());
                map.put("teacherBirthDate", personalInfo.getBirthDate());
                if (personalInfo.getEducationLevelId() != null) {
                    map.put("teacherEducationLevel", educationLevelService.get(personalInfo.getEducationLevelId()).getTitleFa());
                }
                if (personalInfo.getContactInfoId() != null) {
                    ContactInfoDTO contactInfoDTO = contactInfoService.get(personalInfo.getContactInfoId());
                    Long homeAddressId = contactInfoDTO.getHomeAddressId();
                    map.put("teacherMobile", contactInfoDTO.getMobile());
                    if (homeAddressId != null) {
                        map.put("teacherAddress", addressService.get(homeAddressId).getRestAddr());
                        map.put("teacherPostalCode", addressService.get(homeAddressId).getPostalCode());
                    }
                }
            }
        }
        return map;
    }

    @Named("toSecondPartyInstitute")
    Map<String, String> toSecondPartyInstitute(Long secondPartyInstituteId) {
        Map<String, String> map = new HashMap<>();
        map.put("instituteName", "");
        map.put("instituteId", "");
        map.put("instituteEconomicalId", "");
        map.put("instituteAddress", "");
        map.put("institutePhone", "");
        map.put("instituteManagerName", "");
        map.put("instituteManagerMobile", "");

        if (secondPartyInstituteId != null) {
            map.put("instituteName", instituteService.getInstitute(secondPartyInstituteId).getTitleFa());
            map.put("instituteId", instituteService.getInstitute(secondPartyInstituteId).getInstituteId());
            map.put("instituteEconomicalId", instituteService.getInstitute(secondPartyInstituteId).getEconomicalId());

            Long contactInfoId = instituteService.getInstitute(secondPartyInstituteId).getContactInfoId();
            if (contactInfoId != null) {
                Long workAddressId = contactInfoService.get(contactInfoId).getWorkAddressId();
                if (workAddressId != null) {
                    map.put("instituteAddress", addressService.get(workAddressId).getRestAddr());
                    map.put("institutePhone", addressService.get(workAddressId).getPhone());
                }
            }

            Long managerId = instituteService.getInstitute(secondPartyInstituteId).getManagerId();
            if (managerId != null) {
                PersonalInfo personalInfo = personalInfoService.getPersonalInfo(managerId);
                map.put("instituteManagerName", personalInfo.getFirstNameFa() + " " + personalInfo.getLastNameFa());
                Long managerContactInfoId = personalInfo.getContactInfoId();
                if (managerContactInfoId != null) {
                    map.put("instituteManagerMobile", contactInfoService.get(managerContactInfoId).getMobile());
                }
            }
        }
        return map;
    }

    @Named("toStringCurrency")
    String toStringCurrency(Long currencyId) {
        if (currencyId != null)
            return parameterValueService.getInfo(currencyId).getTitle();
        else return "";
    }

}
