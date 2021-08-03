package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.hrm.HrmFeignClient;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ContactInfoService implements IContactInfoService {
    private final ModelMapper modelMapper;
    private final ContactInfoDAO contactInfoDAO;
    private final AddressService addressService;
    private final HrmFeignClient hrmClient;
    private final PersonnelDAO personnelDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;
    private final StudentDAO studentDAO;

    @Transactional(readOnly = true)
    @Override
    public ContactInfoDTO.Info get(Long id) {
        final Optional<ContactInfo> gById = contactInfoDAO.findById(id);
        final ContactInfo contactInfo = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(contactInfo, ContactInfoDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<ContactInfoDTO.Info> list() {
        final List<ContactInfo> gAll = contactInfoDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<ContactInfoDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info create(ContactInfoDTO.Create request) {

        final ContactInfo contactInfo = modelMapper.map(request, ContactInfo.class);
        try {
            return modelMapper.map(contactInfoDAO.saveAndFlush(contactInfo), ContactInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }


    @Transactional
    @Override
    public ContactInfoDTO.Info createNewFor(Long id, String type) {
        ContactInfo contactInfo = contactInfoDAO.saveAndFlush(new ContactInfo());
        switch (type) {
            case "Personnel":
                Personnel personnel = personnelDAO.findById(id).get();
                personnel.setContactInfo(contactInfo);
                personnelDAO.saveAndFlush(personnel);
                break;
            case "RegisteredPersonnel":
                PersonnelRegistered personnelRegistered = personnelRegisteredDAO.getOne(id);
                personnelRegistered.setContactInfo(contactInfo);
                personnelRegisteredDAO.saveAndFlush(personnelRegistered);
                break;
            case "Student":
                Student student = studentDAO.getOne(id);
                student.setContactInfo(contactInfo);
                studentDAO.saveAndFlush(student);
                break;
            default:
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
        return modelMapper.map(contactInfo, ContactInfoDTO.Info.class);
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request) {

        final Optional<ContactInfo> cById = contactInfoDAO.findById(id);
        ContactInfo contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        ContactInfo cUpdating = new ContactInfo();
        modelMapper.map(contactInfo, cUpdating);
        modelMapper.map(request, cUpdating);

        try {
            return modelMapper.map(contactInfoDAO.saveAndFlush(cUpdating), ContactInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            contactInfoDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(ContactInfoDTO.Delete request) {
        final List<ContactInfo> gAllById = contactInfoDAO.findAllById(request.getIds());
        contactInfoDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ContactInfoDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(contactInfoDAO, request, contactInfo -> modelMapper.map(contactInfo, ContactInfoDTO.Info.class));
    }


    @Transactional
    @Override
    public void modify(ContactInfoDTO.CreateOrUpdate request, ContactInfo contactInfo) {
        if (request.getHomeAddress() != null && request.getHomeAddress().getPostalCode() != null) {
            Address address = addressService.getByPostalCode(request.getHomeAddress().getPostalCode());
            if (address != null) {
                request.getHomeAddress().setId(address.getId());
                request.setHomeAddressId(address.getId());
                if (contactInfo != null)
                    contactInfo.setHomeAddress(address);
                else {
                    modelMapper.map(request.getHomeAddress(), address);
                    request.setHomeAddress(modelMapper.map(address, AddressDTO.CreateOrUpdate.class));
                }
            }
        }
        if (request.getWorkAddress() != null && request.getWorkAddress().getPostalCode() != null) {
            Address address = addressService.getByPostalCode(request.getWorkAddress().getPostalCode());
            if (address != null) {
                request.getWorkAddress().setId(address.getId());
                request.setWorkAddressId(address.getId());
                if (contactInfo != null)
                    contactInfo.setWorkAddress(address);
                else {
                    modelMapper.map(request.getWorkAddress(), address);
                    request.setWorkAddress(modelMapper.map(address, AddressDTO.CreateOrUpdate.class));
                }
            }
        }
    }

    @Transactional
    @Override
    public ContactInfo fetchAndUpdateLastHrMobile(Long id, String type, String token) {

        String nationalCode;
        ContactInfo contactInfo;
        switch (type) {
            case "Personnel":
            Personnel personnel = personnelDAO.findById(id).get();
            contactInfo = personnel.getContactInfo();
            if (personnel.getContactInfoId() == null) {
                contactInfo = new ContactInfo();
                contactInfoDAO.save(contactInfo);
                personnel.setContactInfo(contactInfo);
                personnelDAO.saveAndFlush(personnel);
            }
            nationalCode = personnel.getNationalCode();
            break;
            case "RegisteredPersonnel":
                PersonnelRegistered personnelRegistered = personnelRegisteredDAO.getOne(id);
                contactInfo = personnelRegistered.getContactInfo();
                if (personnelRegistered.getContactInfoId() == null) {
                    contactInfo = new ContactInfo();
                    contactInfoDAO.save(contactInfo);
                    personnelRegistered.setContactInfo(contactInfo);
                    personnelRegisteredDAO.saveAndFlush(personnelRegistered);
                }
                nationalCode = personnelRegistered.getNationalCode();
                break;
            case "Student":
                Student student = studentDAO.findById(id).get();
                contactInfo = student.getContactInfo();
                if (contactInfo == null) {
                    contactInfo = new ContactInfo();
                    contactInfoDAO.save(contactInfo);
                    student.setContactInfo(contactInfo);
                    studentDAO.saveAndFlush(student);
                }
                nationalCode = student.getNationalCode();
                break;
            default:
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
        if (nationalCode == null)
            return contactInfo;
        long now = new Date().getTime();
        long lastModified = contactInfo.getLastModifiedDate() == null ? 0 : contactInfo.getLastModifiedDate().getTime();
        String hrMobile;
        if ((now - lastModified) / 1000 / 60 / 60 > 12) {
            try {
                HrmPersonDTO person = hrmClient.getPersonByNationalCode(nationalCode, token);
                hrMobile = person.getMobile();
                final Optional<ContactInfo> cById = contactInfoDAO.findById(contactInfo.getId());
                if (cById.isPresent()) {
                    ContactInfo contact = cById.get();
                    contact.setHrMobile(hrMobile);
                    contactInfoDAO.saveAndFlush(contact);
                }
            } catch (Exception ex) {
            }
        }
        return contactInfo;
    }

}
