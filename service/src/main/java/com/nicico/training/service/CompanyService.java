package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.ICompanyService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
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
    private final AccountInfoService accountInfoService;
    private final AddressService addressService;
    private final PersonalInfoService personalInfoService;


    @Transactional(readOnly = true)
    @Override
    public CompanyDTO.Info get(Long id) {
        final Optional<Company> optionalCompany = companyDAO.findById(id);
        final Company company = optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return modelMapper.map(company, CompanyDTO.Info.class);
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

        if (request.getAccountInfo() != null) {
            AccountInfoDTO.Info accountInfoDTO = accountInfoService.createOrUpdate(request.getAccountInfo());
            request.setAccountInfoId(accountInfoDTO.getId());
            request.setAccountInfo(null);
        }
        if (request.getAddress() != null) {
            AddressDTO.Info addressDTO = addressService.createOrUpdate(request.getAddress());
            request.setAddressId(addressDTO.getId());
            request.setAddress(null);
        }
        if (request.getManager() != null) {
            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.createOrUpdate(request.getManager());
            request.setManagerId(personalInfoDTO.getId());
            request.setManager(null);
        }


        final Company company = modelMapper.map(request, Company.class);
        try {
            return modelMapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

    }


    @Transactional
    @Override
    public CompanyDTO.Info update(Long id, CompanyDTO.Update request) {

        if (request.getAccountInfo() != null) {
            AccountInfoDTO.Info accountInfoDTO = accountInfoService.createOrUpdate(request.getAccountInfo());
            request.setAccountInfoId(accountInfoDTO.getId());
            request.setAccountInfo(null);
        }
        if (request.getAddress() != null) {
            AddressDTO.Info addressDTO = addressService.createOrUpdate(request.getAddress());
            request.setAddressId(addressDTO.getId());
            request.setAddress(null);
        }
        if (request.getManager() != null) {
            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.createOrUpdate(request.getManager());
            request.setManagerId(personalInfoDTO.getId());
            request.setManager(null);
        }

        Optional<Company> optionalCompany = companyDAO.findById(id);
        Company currentCompany = optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompanyNotFound));
        Company company = new Company();
        modelMapper.map(currentCompany, company);
        modelMapper.map(request, company);

        if (request.getAddress() == null)
            company.setAddress(null);
        if (request.getAccountInfo() == null)
            company.setAccountInfo(null);
        if (request.getManager() == null)
            company.setManager(null);

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


}
