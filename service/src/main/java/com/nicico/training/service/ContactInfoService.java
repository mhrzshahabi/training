package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.iservice.IAddressService;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.model.Address;
import com.nicico.training.model.ContactInfo;
import com.nicico.training.repository.AddressDAO;
import com.nicico.training.repository.ContactInfoDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ContactInfoService implements IContactInfoService {
    private final ModelMapper modelMapper;
    private final ContactInfoDAO contactInfoDAO;

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
        return save(contactInfo);
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request) {
        final Optional<ContactInfo> cById = contactInfoDAO.findById(id);
        final ContactInfo contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        ContactInfo updating = new ContactInfo();
        modelMapper.map(contactInfo, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<ContactInfo> one = contactInfoDAO.findById(id);
        final ContactInfo contactInfo = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        contactInfoDAO.delete(contactInfo);
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

    private ContactInfoDTO.Info save(ContactInfo contactInfo) {
        final ContactInfo saved = contactInfoDAO.saveAndFlush(contactInfo);
        return modelMapper.map(saved, ContactInfoDTO.Info.class);
    }
}
