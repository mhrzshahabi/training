package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.model.AccountInfo;
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

        if (personalInfo.getAccountInfo() != null) {
            personalInfo.setAccountInfoId(accountInfoService.create(request.getAccountInfo()).getId());
        }

        if (personalInfo.getContactInfo() != null) {
            personalInfo.setContactInfoId(contactInfoService.create(request.getContactInfo()).getId());
        }
        setEnums(personalInfo, personalInfo.getMarriedId(), personalInfo.getMilitaryId(), personalInfo.getGenderId());

//        personalInfo.setAccountInfo(null);
//        personalInfo.setContactInfo(null);

        return modelMapper.map(personalInfoDAO.save(personalInfo), PersonalInfoDTO.Info.class);

    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info update(Long id, PersonalInfoDTO.Update request) {

        AccountInfoDTO.Info accountInfoDto = null;

        Optional<PersonalInfo> pById = personalInfoDAO.findById(id);
        PersonalInfo personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        setEnums(personalInfo, request.getMarriedId(), request.getMilitaryId(), request.getGenderId());

        PersonalInfo pUpdating = new PersonalInfo();
        modelMapper.map(personalInfo, pUpdating);
        modelMapper.map(request, pUpdating);

        if (personalInfo.getAccountInfoId() != null && request.getAccountInfo() != null) {
            accountInfoDto = accountInfoService.update(personalInfo.getAccountInfoId(),
                    modelMapper.map(pUpdating.getAccountInfo(), AccountInfoDTO.Update.class));
        } else if (personalInfo.getAccountInfoId() == null && request.getAccountInfo() != null) {
            accountInfoDto = accountInfoService.create(modelMapper.map(pUpdating.getAccountInfo(), AccountInfoDTO.Create.class));
        }
        if (accountInfoDto != null) {
            pUpdating.setAccountInfoId(accountInfoDto.getId());
            pUpdating.setAccountInfo(modelMapper.map(accountInfoDto, AccountInfo.class));
        }


//        if (personalInfo.getContactInfoId() != null && request.getContactInfo() != null) {
//            ContactInfoDTO.Info contactInfoDto = contactInfoService.update(personalInfo.getContactInfoId(), request.getContactInfo());
//            contactInfo = modelMapper.map(contactInfoDto, ContactInfo.class);
//            contactInfoId = contactInfo.getId();
//        }
//
//        if (personalInfo.getContactInfoId() == null && request.getContactInfo() != null) {
//            ContactInfoDTO.Info contactInfoDto = contactInfoService.create(modelMapper.map(request.getContactInfo(), ContactInfoDTO.Create.class));
//            contactInfo = modelMapper.map(contactInfoDto, ContactInfo.class);
//            contactInfoId = contactInfo.getId();
//        }
//
//        if (personalInfo.getContactInfoId() != null && request.getContactInfo() == null) {
//            contactInfoService.delete(personalInfo.getContactInfoId());
//            contactInfo = null;
//            contactInfoId = null;
//        }

        return modelMapper.map(personalInfoDAO.save(pUpdating), PersonalInfoDTO.Info.class);
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

//    private PersonalInfoDTO.Info save(PersonalInfo personalInfo) {
//        final PersonalInfo saved = personalInfoDAO.saveAndFlush(personalInfo);
//        return modelMapper.map(saved, PersonalInfoDTO.Info.class);
//    }

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
