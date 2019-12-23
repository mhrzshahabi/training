package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.model.Address;

import java.util.List;

public interface IAddressService {
    AddressDTO.Info get(Long id);

    List<AddressDTO.Info> list();

    AddressDTO.Info create(AddressDTO.Create request);

    AddressDTO.Info update(Long id, AddressDTO.Update request);

    void delete(Long id);

    void delete(AddressDTO.Delete request);

    SearchDTO.SearchRs<AddressDTO.Info> search(SearchDTO.SearchRq request);

    AddressDTO.Info getOneByPostalCode(String postalCode);

    AddressDTO.Info createOrUpdate(AddressDTO.Create request);

    Address getAddress(Long id);
}
