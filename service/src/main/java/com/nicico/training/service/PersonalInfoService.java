package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.PersonalInfoDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PersonalInfoService implements IPersonalInfoService {
    private final ModelMapper modelMapper;
    private final PersonalInfoDAO personalInfoDAO;

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
        Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findByNationalCode(nationalCode);
        return optionalPersonalInfo.map(personalInfo -> modelMapper.map(personalInfo, PersonalInfoDTO.Info.class)).orElse(null);
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

        Optional<PersonalInfo> byNationalCode = personalInfoDAO.findByNationalCode(request.getNationalCode());
        if (!byNationalCode.isPresent())
            return create(request);
        else {
            PersonalInfoDTO.Update updating = modelMapper.map(request, PersonalInfoDTO.Update.class);
            return update(byNationalCode.get().getId(), updating);
        }
    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info create(PersonalInfoDTO.Create request) {

        if (request.getAccountInfo() != null) {
            AccountInfoDTO.Info accountInfoDTO = accountInfoService.create(request.getAccountInfo());
            request.setAccountInfoId(accountInfoDTO.getId());
            request.setAccountInfo(null);
        }
        if (request.getContactInfo() != null) {
            ContactInfoDTO.Info contactInfoDTO = contactInfoService.create(request.getContactInfo());
            request.setContactInfoId(contactInfoDTO.getId());
            request.setContactInfo(null);
        }

        PersonalInfo personalInfo = modelMapper.map(request, PersonalInfo.class);
        setEnums(personalInfo, personalInfo.getMarriedId(), personalInfo.getMilitaryId(), personalInfo.getGenderId());

        try {
            return modelMapper.map(personalInfoDAO.saveAndFlush(personalInfo), PersonalInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

    }

    @Transactional
    @Override
    public PersonalInfoDTO.Info update(Long id, PersonalInfoDTO.Update request) {

        Optional<PersonalInfo> pById = personalInfoDAO.findById(id);
        PersonalInfo personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        if (request.getAccountInfo() != null) {
            request.getAccountInfo().setId(personalInfo.getAccountInfoId());
            AccountInfoDTO.Info accountInfoDTO = accountInfoService.createOrUpdate(request.getAccountInfo());
            request.setAccountInfoId(accountInfoDTO.getId());
            request.setAccountInfo(null);
        } else if (personalInfo.getAccountInfo() != null) {
            request.setAccountInfoId(personalInfo.getAccountInfoId());
            request.setAccountInfo(modelMapper.map(personalInfo.getAccountInfo(), AccountInfoDTO.Create.class));
        }
        if (request.getContactInfo() != null) {
            request.getContactInfo().setId(personalInfo.getContactInfoId());
            ContactInfoDTO.Info contactInfoDTO = contactInfoService.createOrUpdate(request.getContactInfo());
            request.setContactInfoId(contactInfoDTO.getId());
            request.setContactInfo(null);
        } else if (personalInfo.getContactInfo() != null) {
            request.setContactInfoId(personalInfo.getContactInfoId());
            request.setContactInfo(modelMapper.map(personalInfo.getContactInfo(), ContactInfoDTO.Create.class));
        }


        setEnums(personalInfo, request.getMarriedId(), request.getMilitaryId(), request.getGenderId());
        PersonalInfo pUpdating = new PersonalInfo();
        modelMapper.map(personalInfo, pUpdating);
        modelMapper.map(request, pUpdating);

        if (request.getAccountInfo() == null)
            pUpdating.setAccountInfo(null);
        if (request.getContactInfo() == null)
            pUpdating.setContactInfo(null);

        try {
            return modelMapper.map(personalInfoDAO.saveAndFlush(pUpdating), PersonalInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        Optional<PersonalInfo> pById = personalInfoDAO.findById(id);
        PersonalInfo personalInfo = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        try {
            personalInfoDAO.deleteById(id);
            accountInfoService.delete(personalInfo.getAccountInfoId());
            contactInfoService.delete(personalInfo.getContactInfoId());
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
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
