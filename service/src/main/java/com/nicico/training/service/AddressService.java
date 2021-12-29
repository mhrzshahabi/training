package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.iservice.IAddressService;
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
public class AddressService implements IAddressService {
    private final ModelMapper modelMapper;
    private final AddressDAO addressDAO;
    private final ContactInfoDAO contactInfoDAO;

    @Transactional(readOnly = true)
    @Override
    public AddressDTO.Info get(Long id) {
        final Optional<Address> gById = addressDAO.findById(id);
        final Address address = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(address, AddressDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AddressDTO.Info> list() {
        final List<Address> gAll = addressDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<AddressDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AddressDTO.Info createOrUpdate(AddressDTO.Create request) {

        if (request.getPostalCode() != null) {
            Optional<Address> byPostalCode = addressDAO.findByPostalCode(request.getPostalCode());
            if (byPostalCode.isPresent() && !byPostalCode.get().getId().equals(request.getId())) {
                request.setId(byPostalCode.get().getId());
                AddressDTO.Update updating = modelMapper.map(request, AddressDTO.Update.class);
                return update(request.getId(), updating);
            }
        }

        if (request.getId() == null)
            return create(request);
        else {
            AddressDTO.Update updating = modelMapper.map(request, AddressDTO.Update.class);
            return update(request.getId(), updating);
        }
    }

    @Transactional
    @Override
    public AddressDTO.Info create(AddressDTO.Create request) {
        if (request.getPostalCode() != null && request.getPostalCode().length() != 10)
            throw new TrainingException(TrainingException.ErrorType.WrongPostalCode);
        final Address address = modelMapper.map(request, Address.class);
        return modelMapper.map(addressDAO.saveAndFlush(address), AddressDTO.Info.class);
    }

    @Transactional
    @Override
    public AddressDTO.Info update(Long id, AddressDTO.Update request) {
        if (request.getPostalCode() != null && request.getPostalCode().length() != 10)
            throw new TrainingException(TrainingException.ErrorType.WrongPostalCode);
        final Optional<Address> cById = addressDAO.findById(id);
        final Address address = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Address updating = new Address();
        modelMapper.map(address, updating);
        modelMapper.map(request, updating);
        return modelMapper.map(addressDAO.saveAndFlush(updating), AddressDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Address> one = addressDAO.findById(id);
        final Address address = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        addressDAO.delete(address);
    }

    @Transactional
    @Override
    public void delete(AddressDTO.Delete request) {
        final List<Address> gAllById = addressDAO.findAllById(request.getIds());
        addressDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AddressDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(addressDAO, request, address -> modelMapper.map(address, AddressDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public AddressDTO.Info getOneByPostalCode(String postalCode) {
        Optional<Address> address = addressDAO.findByPostalCode(postalCode);
        return address.map(value -> modelMapper.map(value, AddressDTO.Info.class)).orElse(null);
    }

    @Transactional(readOnly = true)
    @Override
    public Address getByPostalCode(String postalCode) {
        Optional<Address> address = addressDAO.findByPostalCode(postalCode);
        return address.orElse(null);
    }

    @Override
    public Address getAddress(Long id) {
        return addressDAO.getById(id);
    }

    @Transactional(readOnly = true)
    @Override
    public ContactInfoDTO.Info getByPostalCodeWithContact(String postalCode) {
        Optional<ContactInfo> address = contactInfoDAO.findByWorkAddressPostalCode(postalCode);

        return  modelMapper.map(address.orElse(null),ContactInfoDTO.Info.class);
    }
}
