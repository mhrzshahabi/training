package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.ICompanyService;
import com.nicico.training.model.Address;
import com.nicico.training.model.Company;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.repository.CompanyDAO;
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
public class CompanyService implements ICompanyService {
    private final CompanyDAO companyDAO;
    private final ModelMapper modelMapper;
    private final AddressService addressService;
    private final PersonalInfoService personalInfoService;


    @Transactional(readOnly = true)
    @Override
    public CompanyDTO.Info get(Long id) {
        return modelMapper.map(getCompany(id), CompanyDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Company getCompany(Long id) {
        final Optional<Company> optionalCompany = companyDAO.findById(id);
        return optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
    }

    @Transactional
    @Override
    public List<CompanyDTO.Info> list() {
        List<Company> companyList = companyDAO.findAll();
        return modelMapper.map(companyList, new TypeToken<List<CompanyDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CompanyDTO.Info create(CompanyDTO.Create request) {
        final Company company = modelMapper.map(request, Company.class);
        setManager(request, company);
        setAddress(request, company);
        try {
            return modelMapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

    }


    @Transactional
    @Override
    public CompanyDTO.Info update(Long id, CompanyDTO.Update request) {
        Company currentCompany = getCompany(id);
        Company company = new Company();
        modelMapper.map(currentCompany, company);
        setManager(request, company);
        setAddress(request, company);
        modelMapper.map(request, company);
        try {
            return modelMapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            companyDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(CompanyDTO.Delete request) {
        final List<Company> companyList = companyDAO.findAllById(request.getIds());
        companyDAO.deleteAll(companyList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CompanyDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(companyDAO, request, company -> modelMapper.map(company, CompanyDTO.Info.class));
    }

    private void setAddress(CompanyDTO.Create request, Company company) {
        if (request.getAddress() != null && request.getAddress().getPostalCode() != null) {
            Address address = addressService.getByPostalCode(request.getAddress().getPostalCode());
            if (address != null) {
                request.setAddressId(address.getId());
                request.getAddress().setId(address.getId());
                modelMapper.map(request.getAddress(), address);
                company.setAddress(address);
                request.setAddress(modelMapper.map(address, AddressDTO.CompanyAddress.class));
            }
        }
    }

    private void setManager(CompanyDTO.Create request, Company company) {
        if (request.getManager() != null && request.getManager().getId() != null) {
            PersonalInfo manager = personalInfoService.getPersonalInfo(request.getManager().getId());
            request.setManagerId(manager.getId());
            modelMapper.map(request.getManager(), manager);
            company.setManager(manager);
            request.setManager(modelMapper.map(manager, PersonalInfoDTO.CompanyManager.class));
        }
    }


}
