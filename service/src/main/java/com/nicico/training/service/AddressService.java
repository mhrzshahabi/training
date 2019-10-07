package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.iservice.IAddressService;
import com.nicico.training.model.Address;
import com.nicico.training.repository.AddressDAO;
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
    public AddressDTO.Info create(AddressDTO.Create request) {
        final Address address = modelMapper.map(request, Address.class);
        return save(address);
    }

    @Transactional
    @Override
    public AddressDTO.Info update(Long id, AddressDTO.Update request) {
        final Optional<Address> cById = addressDAO.findById(id);
        final Address address = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Address updating = new Address();
        modelMapper.map(address, updating);
        modelMapper.map(request, updating);
        return save(updating);
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
        List<Address> addresses = addressDAO.findByPostalCode(postalCode);
        Address address;
        if(addresses != null && addresses.size() != 0) {
            address = addresses.get(0);
            return modelMapper.map(address, AddressDTO.Info.class);
        }
        else
            return null;
    }

    // ------------------------------

    private AddressDTO.Info save(Address address) {
        final Address saved = addressDAO.saveAndFlush(address);
        return modelMapper.map(saved, AddressDTO.Info.class);
    }
}
