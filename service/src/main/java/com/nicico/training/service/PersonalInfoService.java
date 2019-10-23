package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.model.AccountInfo;
import com.nicico.training.model.Address;
import com.nicico.training.model.ContactInfo;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.AccountInfoDAO;
import com.nicico.training.repository.AddressDAO;
import com.nicico.training.repository.ContactInfoDAO;
import com.nicico.training.repository.PersonalInfoDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PersonalInfoService implements IPersonalInfoService {
    private final ModelMapper modelMapper;
    private final PersonalInfoDAO personalInfoDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final ContactInfoDAO contactInfoDAO;
    private final AddressDAO addressDAO;

    private final AccountInfoService accountInfoService;
    private final ContactInfoService contactInfoService;

    private final EnumsConverter.EGenderConverter eGenderConverter = new EnumsConverter.EGenderConverter();
    private final EnumsConverter.EMarriedConverter eMarriedConverter = new EnumsConverter.EMarriedConverter();
    private final EnumsConverter.EMilitaryConverter eMilitaryConverter = new EnumsConverter.EMilitaryConverter();

    @Transactional(readOnly = true)
    @Override
    public PersonalInfoDTO.Info get(Long id) {
        final Optional<PersonalInfo> gById = personalInfoDAO.findById(id);
        final PersonalInfo personalInfo = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personalInfo, PersonalInfoDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public PersonalInfoDTO.Info getOneByNationalCode(String nationalCode) {
        List<PersonalInfo> personalInfoList = personalInfoDAO.findByNationalCode(nationalCode);
        PersonalInfo personalInfo = null;
        if (personalInfoList != null && personalInfoList.size() != 0) {
            personalInfo = personalInfoList.get(0);
            return modelMapper.map(personalInfo, PersonalInfoDTO.Info.class);
        } else
            return null;
    }

    @Transactional(readOnly = true)
    @Override
    public List<PersonalInfoDTO.Info> list() {
        final List<PersonalInfo> gAll = personalInfoDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<PersonalInfoDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info createOrUpdate(PersonalInfoDTO.Create request) {

        List<PersonalInfo> byNationalCode = personalInfoDAO.findByNationalCode(request.getNationalCode());
        if (byNationalCode == null || byNationalCode.size() == 0)
            return create(request);
        else {
            PersonalInfoDTO.Update updating = modelMapper.map(request, PersonalInfoDTO.Update.class);
            return update(byNationalCode.get(0).getId(), updating);
        }
    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info create(PersonalInfoDTO.Create request) {

        PersonalInfo personalInfo = modelMapper.map(request, PersonalInfo.class);

        if (request.getAccountInfo() != null) {
            personalInfo.setAccountInfoId(accountInfoService.create(request.getAccountInfo()).getId());
        }

        if (request.getContactInfo() != null) {
            personalInfo.setContactInfoId(contactInfoService.create(request.getContactInfo()).getId());
        }
        setEnums(personalInfo, request.getMarriedId(), request.getMilitaryId(), request.getGenderId());

        personalInfo.setAccountInfo(null);
        personalInfo.setContactInfo(null);
        return save(personalInfo);


//        ContactInfo contactInfo;
//        AccountInfo accountInfo;
//        Address homeAddress;
//        Address workAddress;
//        PersonalInfo personalInfo;
//
//        personalInfo = modelMapper.map(request, PersonalInfo.class);
//
//        if (request.getAccountInfo() != null) {
//            accountInfo = modelMapper.map(request.getAccountInfo(), AccountInfo.class);
//            accountInfoDAO.saveAndFlush(accountInfo);
//            personalInfo.setAccountInfo(accountInfo);
//            personalInfo.setAccountInfoId(accountInfo.getId());
//        }
//
//        if (request.getContactInfo() != null) {
//            contactInfo = modelMapper.map(request.getContactInfo(), ContactInfo.class);
//            if (request.getContactInfo().getHomeAddress() != null) {
//                homeAddress = modelMapper.map(request.getContactInfo().getHomeAddress(), Address.class);
//                addressDAO.saveAndFlush(homeAddress);
//                contactInfo.setHomeAddress(homeAddress);
//                contactInfo.setHomeAddressId(homeAddress.getId());
//            }
//            if (request.getContactInfo().getWorkAddress() != null) {
//                workAddress = modelMapper.map(request.getContactInfo().getWorkAddress(), Address.class);
//                addressDAO.saveAndFlush(workAddress);
//                contactInfo.setWorkAddress(workAddress);
//                contactInfo.setWorkAddressId(workAddress.getId());
//            }
//            contactInfoDAO.saveAndFlush(contactInfo);
//            personalInfo.setContactInfo(contactInfo);
//            personalInfo.setContactInfoId(contactInfo.getId());
//        }
//
//        if (request.getMarriedId() != null) {
//            personalInfo.setMarried(eMarriedConverter.convertToEntityAttribute(request.getMarriedId()));
////				personalInfo.setMarriedTitleFa(personalInfo.getMarried().getTitleFa());
//        }
//        if (request.getMilitaryId() != null) {
//            personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(request.getMilitaryId()));
////				 personalInfo.setMilitaryTitleFa(personalInfo.getMilitary().getTitleFa());
//        }
//        if (request.getGenderId() != null) {
//            personalInfo.setGender(eGenderConverter.convertToEntityAttribute(request.getGenderId()));
////				personalInfo.setGenderTitleFa(personalInfo.getGender().getTitleFa());
//        }
//
//        return modelMapper.map(personalInfoDAO.saveAndFlush(personalInfo), PersonalInfoDTO.Info.class);
    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info update(Long id, PersonalInfoDTO.Update request) {

        PersonalInfo personalInfo;
        ContactInfo contactInfo;
        AccountInfo accountInfo;

        Long contactInfoId = null;
        Long accountInfoId = null;

        final Optional<PersonalInfo> pById = personalInfoDAO.findById(id);
        personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


        if (personalInfo.getAccountInfoId() != null && request.getAccountInfo() != null) {
            AccountInfoDTO.Info accountInfoDto = accountInfoService.update(personalInfo.getAccountInfoId(), request.getAccountInfo());
            accountInfo = modelMapper.map(accountInfoDto, AccountInfo.class);
            accountInfoId = accountInfo.getId();
        }

        if (personalInfo.getAccountInfoId() == null && request.getAccountInfo() != null) {
            AccountInfoDTO.Info accountInfoDto = accountInfoService.create(modelMapper.map(request.getAccountInfo(), AccountInfoDTO.Create.class));
            accountInfo = modelMapper.map(accountInfoDto, AccountInfo.class);
            accountInfoId = accountInfo.getId();
        }

        if (personalInfo.getAccountInfoId() != null && request.getAccountInfo() == null) {
            accountInfoService.delete(personalInfo.getAccountInfoId());
            accountInfo = null;
            accountInfoId = null;
        }


        if (personalInfo.getContactInfoId() != null && request.getContactInfo() != null) {
            ContactInfoDTO.Info contactInfoDto = contactInfoService.update(personalInfo.getContactInfoId(), request.getContactInfo());
            contactInfo = modelMapper.map(contactInfoDto, ContactInfo.class);
            contactInfoId = contactInfo.getId();
        }

        if (personalInfo.getContactInfoId() == null && request.getContactInfo() != null) {
            ContactInfoDTO.Info contactInfoDto = contactInfoService.create(modelMapper.map(request.getContactInfo(), ContactInfoDTO.Create.class));
            contactInfo = modelMapper.map(contactInfoDto, ContactInfo.class);
            contactInfoId = contactInfo.getId();
        }

        if (personalInfo.getContactInfoId() != null && request.getContactInfo() == null) {
            contactInfoService.delete(personalInfo.getContactInfoId());
            contactInfo = null;
            contactInfoId = null;
        }

        setEnums(personalInfo, request.getMarriedId(), request.getMilitaryId(), request.getGenderId());

        PersonalInfo pUpdating = new PersonalInfo();
        modelMapper.map(personalInfo, pUpdating);
        modelMapper.map(request, pUpdating);
//        pUpdating.setAccountInfo(accountInfo);
        pUpdating.setAccountInfoId(accountInfoId);
//        pUpdating.setContactInfo(contactInfo);
        pUpdating.setContactInfoId(contactInfoId);
        pUpdating.setAccountInfo(null);
        pUpdating.setContactInfo(null);
        return save(pUpdating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<PersonalInfo> one = personalInfoDAO.findById(id);
        final PersonalInfo personalInfo = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        personalInfoDAO.delete(personalInfo);
    }

    @Transactional
    @Override
    public void delete(PersonalInfoDTO.Delete request) {
        final List<PersonalInfo> gAllById = personalInfoDAO.findAllById(request.getIds());
        personalInfoDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonalInfoDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(personalInfoDAO, request, personalInfo -> modelMapper.map(personalInfo, PersonalInfoDTO.Info.class));
    }

    // ------------------------------

    private PersonalInfoDTO.Info save(PersonalInfo personalInfo) {
        final PersonalInfo saved = personalInfoDAO.saveAndFlush(personalInfo);
        return modelMapper.map(saved, PersonalInfoDTO.Info.class);
    }

    private void setEnums(PersonalInfo personalInfo, Integer marriedId, Integer militaryId, Integer genderId) {
        if (marriedId != null) {
            personalInfo.setMarried(eMarriedConverter.convertToEntityAttribute(marriedId));
        }
        if (militaryId != null) {
            personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(militaryId));
        }
        if (genderId != null) {
            personalInfo.setGender(eGenderConverter.convertToEntityAttribute(genderId));
        }
    }
}
