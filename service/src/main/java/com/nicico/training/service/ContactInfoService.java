package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.ContactInfoDTO;
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
    private final AddressDAO addressDAO;

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
    public ContactInfoDTO.Info create(ContactInfoDTO.Create request) {
        ContactInfo contactInfo;
		Address homeAddress;
		Address workAddress;

		contactInfo = modelMapper.map(request,ContactInfo.class);;

		if (request.getHomeAddress() != null) {
				homeAddress = modelMapper.map(request.getHomeAddress(), Address.class);
				addressDAO.saveAndFlush(homeAddress);
				contactInfo.setHomeAddress(homeAddress);
				contactInfo.setHomeAddressId(homeAddress.getId());
		}

		if (request.getWorkAddress() != null) {
				workAddress = modelMapper.map(request.getWorkAddress(), Address.class);
				addressDAO.saveAndFlush(workAddress);
				contactInfo.setWorkAddress(workAddress);
				contactInfo.setWorkAddressId(workAddress.getId());
		}


		return modelMapper.map(contactInfoDAO.saveAndFlush(contactInfo), ContactInfoDTO.Info.class);
    }

    @Transactional
    @Override
    public ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request) {
		ContactInfo contactInfo = null;
		Address homeAddress = null;
		Address workAddress = null;

		Long homeAddressId = null;
		Long workAddressId = null;

        final Optional<ContactInfo> cById = contactInfoDAO.findById(id);
        contactInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


   		if(contactInfo.getHomeAddressId() != null && request.getHomeAddress() != null) {
			AddressDTO.Info addressDto = addressService.update(contactInfo.getHomeAddressId(),request.getHomeAddress());
			homeAddress = modelMapper.map(addressDto,Address.class);
			homeAddressId = homeAddress.getId();
		}

		if(contactInfo.getHomeAddressId() == null && request.getHomeAddress() != null) {
				AddressDTO.Info addressDto = addressService.create(modelMapper.map(request.getHomeAddress(),AddressDTO.Create.class));
				homeAddress = modelMapper.map(addressDto,Address.class);
				homeAddressId = homeAddress.getId();
		}

		if(contactInfo.getHomeAddressId() != null && request.getHomeAddress()==null) {
			addressService.delete(contactInfo.getHomeAddressId());
			homeAddress = null;
			homeAddressId = null;
		}

		if(contactInfo.getWorkAddressId() != null && request.getWorkAddress() != null) {
			AddressDTO.Info addressDto = addressService.update(contactInfo.getWorkAddressId(),request.getWorkAddress());
			workAddress = modelMapper.map(addressDto,Address.class);
			workAddressId = workAddress.getId();
		}

		if(contactInfo.getWorkAddressId() == null && request.getWorkAddress() != null) {
				AddressDTO.Info addressDto = addressService.create(modelMapper.map(request.getWorkAddress(),AddressDTO.Create.class));
				workAddress = modelMapper.map(addressDto,Address.class);
				workAddressId = workAddress.getId();
		}

		if(contactInfo.getWorkAddressId() != null && request.getWorkAddress()==null) {
			addressService.delete(contactInfo.getWorkAddressId());
			workAddress = null;
			workAddressId = null;
		}

        ContactInfo cupdating = new ContactInfo();
        modelMapper.map(contactInfo, cupdating);
        modelMapper.map(request, cupdating);
        cupdating.setHomeAddressId(homeAddressId);
        cupdating.setHomeAddress(homeAddress);
        cupdating.setWorkAddressId(workAddressId);
        cupdating.setWorkAddress(workAddress);
        return save(cupdating);
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
