package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.model.Address;
import com.nicico.training.model.ContactInfo;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.repository.ContactInfoDAO;
import io.netty.channel.AdaptiveRecvByteBufAllocator;
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
public class ContactInfoService implements IContactInfoService {
    private final ModelMapper modelMapper;
    private final ContactInfoDAO contactInfoDAO;

    private final AddressService addressService;

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
    public ContactInfoDTO.Info createOrUpdate(ContactInfoDTO.Create request) {
        if (request.getId() == null)
            return create(request);
        else {
            ContactInfoDTO.Update updating = modelMapper.map(request, ContactInfoDTO.Update.class);
            return update(updating.getId(), updating);
        }
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

    // ------------------------------

    @Override
    public ContactInfoDTO.Create modify(ContactInfoDTO.Create contactInfo) {
        ContactInfo contactInfo_new = null;
        if (contactInfo.getHomeAddress().getId() != null && contactInfo.getHomeAddress().getPostalCode() != null) {
            contactInfo_new = modelMapper.map(contactInfo,ContactInfo.class);
            AddressDTO.Info addressDTO = addressService.getOneByPostalCode(contactInfo.getHomeAddress().getPostalCode());
            if(addressDTO != null) {
                Address address_old = modelMapper.map(addressDTO, Address.class);
                contactInfo_new.getHomeAddress().setId(address_old.getId());
                contactInfo_new.setHomeAddressId(address_old.getId());
                modelMapper.map(contactInfo_new.getHomeAddress(), address_old);
            }
        }
        return  modelMapper.map(contactInfo_new,ContactInfoDTO.Create.class);
    }

}
